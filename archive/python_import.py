import psycopg2 #import the postgres library
from decimal import Decimal
import csv
from datetime import date, datetime, time
import ciso8601
from os import walk
from psycopg2.errors import UniqueViolation
from psycopg2 import extras
import time

def fetch_address_pk(addresses_set):
  t_start = time.time()
  addresses_lst = list(addresses_set)
  addresses_lst2 = []
  for addr in addresses_lst:
    addresses_lst2.append((addr,0))
  insert_query = 'insert into addresses (address,received_count) values %s on conflict(address) do nothing'
  cur = conn.cursor()
  extras.execute_values (
      cur, insert_query, addresses_lst2, template=None, page_size=1000
  )
  conn.commit()
  t_commit = time.time()

  cur = conn.cursor()
  addresses_lst = tuple(addresses_lst)
  #print(addresses_lst)
  sel_sql = "select pk, address from addresses where address in " + str(addresses_lst)
  #print(sel_sql)
  cur.execute(sel_sql)
  records = cur.fetchall()
  records_hash = {}
  for rec in records:
    records_hash[rec[1]] = rec[0]
  print("Address insert time: ", t_commit - t_start, "Address Query: ", time.time() - t_commit)
  return records_hash

def process_file(file_name):
  t_start = time.time()
  t_process_csv = 0
  t_insert_addresses = 0
  t_process_csv2 = 0

  records_hash = {}
  with open(file_name, 'r') as f:
    csv.field_size_limit(2147483647)
    csv_f = csv.reader(f)
    set_addresses = set()
    for counter, row in enumerate(csv_f):
      if counter == 0:
        continue
      set_addresses.add(row[3])
      set_addresses.add(row[4])
    t_process_csv = time.time()
    records_hash = fetch_address_pk(set_addresses)
    t_insert_addresses = time.time()

  with open(file_name, 'r') as f:
    csv.field_size_limit(2147483647)
    csv_f = csv.reader(f)
    tran_recs = []
    for counter, row in enumerate(csv_f):
      if counter == 0:
        continue
      tran_recs.append((row[0], int(row[1] or 0), int(row[2] or 0), int(records_hash[row[3]]), int(records_hash[row[4]]),
        Decimal(row[5]) * Decimal(pow(10,-18)), Decimal(row[6]) * Decimal(pow(10,-18)), row[11], row[12],
        int(row[13] or 0),ciso8601.parse_datetime_as_naive(row[14][:-4]), int(row[15] or 0), row[16], int(row[19] or 0)
        ))
    print("  transaction rows ready in mem")
    t_process_csv2 = time.time()

    insert_query = """insert into transactions (hash,nonce,transaction_index,from_address_fk,to_address_fk,
      value,gas,receipt_contract_address,receipt_root,
      receipt_status,block_timestamp,block_number,block_hash,transaction_type)
      values %s on conflict(hash) do nothing"""
    cur = conn.cursor()
    extras.execute_values (
        cur, insert_query, tran_recs, template=None, page_size=1000
    )
    conn.commit()
    print("records: ", len(tran_recs), len(tran_recs) / (time.time()-t_process_csv2), "ReadCSV1: ", t_process_csv - t_start, "ReadCSV2: ",t_process_csv2 - t_insert_addresses, "Insert tran:", time.time()-t_process_csv2  )


conn = psycopg2.connect(host='localhost',
                       dbname='ether',
                       user='',
                       password='',
                       port='5432')

mypath = '/Volumes/JS/csv'
for i in range(2501, 3000):
  fn = "transactions" + str(i).zfill(12)
  print(fn + " process started")
  process_file(mypath+"/"+fn)
  print(fn + " processed successfully")

conn.close()

