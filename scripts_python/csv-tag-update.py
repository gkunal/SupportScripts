#This python script is used to update the tags value based on csv file containing original tags and new tags in it.
import csv
import psycopg2
from datetime import date, datetime, time
import time
import traceback
import os

def process_file(file_name):
  t_start = time.time()
  t_process_csv = 0
    
  with open(file_name, 'r',encoding='utf8') as f:
    csv.field_size_limit(2147483647)
    csv_f = csv.reader(f)
    set_addresses = set()
    
    for counter, row in enumerate(csv_f):
      update_tags(row[0], row[1])
      #print(row[0],row[1])
      
    t_process_csv = time.time()
    print("records: ", counter, "ReadCSV: ", t_process_csv - t_start)
    f.close()

def update_tags(original_tag, new_tag):
  tag_upsert_query = """UPDATE tags set tag=%s where tag=%s"""
  record_to_insert = (new_tag,original_tag)
  cursor = conn.cursor()
  cursor.execute(tag_upsert_query, record_to_insert)
  conn.commit()
  cursor.close()
  print(original_tag, new_tag, cursor.rowcount)
  
#conn = psycopg2.connect(host='localhost', dbname='ether', user='ether', password='ether', port=5432)
conn = psycopg2.connect(host=os.getenv('dbhost'), dbname=os.getenv('dbname'), user=os.getenv('dbuser'), password=os.getenv('dbpwd'), port=os.getenv('dbport'))
					   
csvfilepath = 'C:/vishal/csv-tag-update.csv'
process_file(csvfilepath)

if conn:
    conn.close()
    print("PostgreSQL connection is closed")