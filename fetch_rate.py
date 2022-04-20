# Command - python fetch_rate.py 100 200
import psycopg2
from decimal import Decimal
from datetime import date, datetime, time
import time
import requests
import json
import sys
import os
from calendar import timegm
import logging

BASE_URL = "https://api.polygon.io";

def fetch_rate(block_number, block_timestamp):
  try:  
      
     t_start = time.time()
  
     utc_time = time.strptime((str(block_timestamp)[:16]), "%Y-%m-%d %H:%M")
     epoch_time = timegm(utc_time)
     epoch_time *= 1000000000
  
     #print(str(block_timestamp))
     #print(epoch_time)
  
     payload = {'timestamp':epoch_time, 'apiKey':os.getenv('apikey'),'sort':'timestamp','order':'desc'}
     url = BASE_URL + "/vX/trades/X:ETH-USD"
  
     response = requests.get(url, params=payload)
     json_data = json.loads(response.text)
  
     if ((json_data.get("status") == "OK") and (len(json_data.get("results")) > 0)):
        converted_to = 'USD'
        conversion_type = ''
        conversion_rate = ''
        conversion_at = ''

        if ((len(json_data.get("results")[0].get("conditions")) > 0) and (json_data.get("results")[0].get("conditions")[0])):
          conversion_type = json_data.get("results")[0].get("conditions")[0]
        else:
          logging.error("No conversion_type found for the block number:%s", block_number)
          return
        if(json_data.get("results")[0].get("price")):
          conversion_rate = json_data.get("results")[0].get("price")
        else:   
          logging.error("No conversion_rate found for the block number:%s", block_number)
          return
        if(json_data.get("results")[0].get("participant_timestamp")):
          conversion_at = int(json_data.get("results")[0].get("participant_timestamp"))//1000000000
        else:
          logging.error("No conversion_at found for the block number:%s", block_number)
          return
  
        insert_query = 'insert into eth_rates (conversion_rate, converted_at, type, converted_to, block_number) values (%s, %s, %s, %s, %s)'
        cur = conn.cursor()  
        record = (conversion_rate, datetime.utcfromtimestamp(conversion_at), conversion_type, converted_to, block_number)
        cur.execute(insert_query, record)
        conn.commit()
     else:
        logging.info("No data found for block number: %s and status: %s and results: %s", block_number,json_data.get("status"),len(json_data.get("results")))
  except:
        logging.error("Oops! %s occurred", sys.exc_info()[0], block_number)

def process_transactions():
  
  if len(sys.argv) != 4:
     logging.error("Provide start and end range of block numbers")
     exit()
     
  start_block_number = int(sys.argv[1])
  end_block_number = int(sys.argv[2])  
  
  record = (start_block_number, end_block_number)
  
  logging.info("Start Block Number: %s", start_block_number)
  logging.info("End Block Number: %s", end_block_number)

  count = 0
  with conn.cursor("transactions") as cur:
      cur.itersize = 200
      cur.execute("select distinct block_number, block_timestamp from transactions where block_number >= %s and block_number <= %s order by block_number", record)
      # get all records
      #records = cur.fetchall()
      #logging.info("Total records to process: %s", cur.rowcount)

      for row in cur:
         logging.info("Block Number: %s", row[0])
         fetch_rate(row[0], row[1])
         time.sleep(0.02)
         count += 1
         if count % 100 == 0:
            logging.info("Processed:%s records", count)
   
  logging.info("Processing of records are completed")
   
#conn = psycopg2.connect(host='localhost', dbname='ether', user='ether', password='ether', port='5432')
Log_Format = "%(levelname)s %(asctime)s - %(message)s"

logging.basicConfig(filename = sys.argv[3],
                    filemode = "w",
                    format = Log_Format,
                    level = logging.INFO)

logger = logging.getLogger()
logging.info('Script is started')
conn = psycopg2.connect(host=os.getenv('dbhost'), dbname=os.getenv('dbname'), user=os.getenv('dbuser'), password=os.getenv('dbpwd'), port=os.getenv('dbport'))
logging.info("Database connected successfully!")
process_transactions()
conn.close()