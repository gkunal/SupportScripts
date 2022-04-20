#This python script reads address from the csv file and updates flags field of the addresses table.
#Input - Single column address csv data
#Output - Updates flags field of the addresses table if address already exist otherwise insert the address into addresses table with flags=1
#Command - docker run -d -w /opt --name python-container -e dbhost=localhost -e dbuser=test -e dbpwd=test -e dbport=5432 -e dbname=test --network host -v "/opt":/opt/ python /bin/bash /opt/python.sh
import psycopg2 
import csv
import os
from datetime import date, datetime, time
import time

def process_address_for_flags(address):
  t_start = time.time()
  cursor = conn.cursor()
  address_upsert_query = """INSERT INTO addresses (address1, address2, flags) VALUES ((lower((SUBSTRING(%s, 3, 32)))::uuid), (SELECT ('x' || (SUBSTRING(%s, 35)))::bit(32)::INT), 1) ON CONFLICT (address1,address2) DO UPDATE SET flags = coalesce(addresses.flags, 0) | EXCLUDED.flags;"""
  record_to_insert = (address, address)
  cursor.execute(address_upsert_query, record_to_insert)
  conn.commit()

def process_file(file_name):
  t_start = time.time()
  t_process_csv = 0

  with open(file_name, 'r') as f:
    csv.field_size_limit(2147483647)
    csv_f = csv.reader(f)
    set_addresses = set()
    for counter, row in enumerate(csv_f):
      if counter == 0:
        continue
      #print("Address:", row[0])
      process_address_for_flags(row[0])
      
      if ((counter + 1) % 10000 == 0):
         print("Total Records processed", (counter+1), " in ", (time.time() - t_start), " ms")
      
    t_process_csv = time.time()   
    conn.commit()
    print("\n")
    print("Processed", (counter+1), " records from csv file in : ", t_process_csv - t_start, " ms")
    print("\n")

conn = psycopg2.connect(host=os.getenv('dbhost'),
                       dbname=os.getenv('dbname'),
                       user=os.getenv('dbuser'),
                       password=os.getenv('dbpwd'),
                       port=os.getenv('dbport'))

print("Database connection is successful")
print("\n")
csvfilepath = 'contracts_addresses.csv'
process_file(csvfilepath)
if conn:
    conn.close()
    print("PostgreSQL connection is closed")

