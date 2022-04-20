#This python script reads address from the multiple csv files kept in directory (directory_in_str) and updates flags field of the addresses table based on category.
# File name should be in format of category$$$label.csv
#Input - Single column address csv data
#Output - Updates flags field of the addresses table if address already exist otherwise insert the address into addresses table with flags based on category
#Command - docker run -d -w /opt --name python-container -e dbhost=localhost -e dbuser=test -e dbpwd=test -e dbport=5432 -e dbname=test --network host -v "/opt":/opt/ python /bin/bash /opt/python.sh
import psycopg2 
import csv
import os
from datetime import date, datetime, time
import time


def process_address_for_flags(address,bitnumber):
  if bitnumber == 'None':
     print("Error regarding bitnumber")
     exit()
   
  cursor = conn.cursor()
  address_upsert_query = """INSERT INTO addresses (address1, address2, flags) VALUES ((lower((SUBSTRING(%s, 3, 32)))::uuid), (SELECT ('x' || (SUBSTRING(%s, 35)))::bit(32)::INT), (1 << %s)) ON CONFLICT (address1,address2) DO UPDATE SET flags = coalesce(addresses.flags, 0) | EXCLUDED.flags;"""
  record_to_insert = (address, address, bitnumber)
  cursor.execute(address_upsert_query, record_to_insert)
  conn.commit()

def process_file(csvfilename):
  t_start = time.time()
  t_process_csv = 0
  
  category=csvfilename[0:csvfilename.index('$$$')]  
  file_name=directory_in_str + csvfilename
  
  with open(file_name, 'r') as f:
    csv.field_size_limit(2147483647)
    csv_f = csv.reader(f)
    set_addresses = set()
    for counter, row in enumerate(csv_f):   
      process_address_for_flags(row[0],category_bits.get(category))
      if ((counter + 1) % 1000 == 0):
         print("Total Records processed", (counter+1), " in ", (time.time() - t_start), " ms")
      
    t_process_csv = time.time()   
    conn.commit()
    print("Processed", (counter+1), " records from " + csvfilename + " file in:", t_process_csv - t_start, " ms")

conn = psycopg2.connect(host='localhost',
                       dbname='ether',
                       user='ether',
                       password='ether',
                       port=5432)

print("Database connection is successful")
print("\n")

category_bits = {'adult': 31, 'blockedexploiter': 30, 'hacker':29, 'mixer':28, 'exploiter':27, 'gambling':26, 'lottery':25, 'p2pexchange':23, 'flashbot':22, 'layer2':21,'crosschain':20, 'victim':19, 'miner':5,'staker':4, 'wallet':3,'exchange':2,'deployer':1,'contract':0}
directory_in_str = 'C:/vishal/data/'
directory = os.fsencode(directory_in_str)
numberoffiles=0;

for file in os.listdir(directory):
     csvfilename = os.fsdecode(file)
     process_file(csvfilename)
     numberoffiles += 1
 
print("\n")
print("Total Files:",numberoffiles)

if conn:
    conn.close()
    print("PostgreSQL connection is closed")

