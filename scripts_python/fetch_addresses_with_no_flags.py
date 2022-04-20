import psycopg2
from decimal import Decimal
from datetime import date, datetime, time
import time
import sys
import os
from calendar import timegm
import logging

def fetch_transactions(address1, address2):
  record = (address1, address2)
  
  cur = conn.cursor()
  cur.execute("select 1 from transactions where from_address1=%s and from_address2=%s limit 1001", record)
  totalRows = cur.rowcount
  if(totalRows < 1000):
    cur.execute("select 1 from transactions where to_address1=%s and to_address2=%s limit 1001", record)
    totalRows += cur.rowcount
    
  if(totalRows) >= 1000:
     logging.info("%s,%s,%s", address1, address2, totalRows)
     
  cur.close()
    
def fetch_addresses():
  count = 0
  conn1 = psycopg2.connect(host=os.getenv('dbhost'), dbname=os.getenv('dbname'), user=os.getenv('dbuser'), password=os.getenv('dbpwd'), port=os.getenv('dbport'))
  #conn1 = psycopg2.connect(host='localhost', dbname='ether', user='ether', password='ether', port='5432')
  with conn1.cursor("addresses") as cur:
      cur.itersize = 500
      cur.execute("select address1, address2 from addresses where flags is null")
     
      for row in cur:
         fetch_transactions(row[0], row[1]);
         count += 1
         if count % 10000 == 0:
            logging.info("Processed:%s records", count)
   
  logging.info("Processing of records are completed")
   
Log_Format = "%(levelname)s %(asctime)s - %(message)s"

logging.basicConfig(filename = sys.argv[3],
                    filemode = "w",
                    format = Log_Format,
                    level = logging.INFO)

logger = logging.getLogger()
logging.info('Script is started')
conn = psycopg2.connect(host=os.getenv('dbhost'), dbname=os.getenv('dbname'), user=os.getenv('dbuser'), password=os.getenv('dbpwd'), port=os.getenv('dbport'))
#conn = psycopg2.connect(host='localhost', dbname='ether', user='ether', password='ether', port='5432')
logging.info("Database connected successfully!")
fetch_addresses()
conn.close()	