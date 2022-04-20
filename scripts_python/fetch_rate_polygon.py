# Command - python fetch_rate.py 100 200
import psycopg2
from decimal import Decimal
from datetime import date, datetime, time, timedelta
import time
import requests
import json
import sys
import os
from calendar import timegm
import logging

BASE_URL = "https://api.polygon.io";

def fetch_rate(block_number, block_timestamp):
  logging.info("Sending Request to fetch data for block number:%s",block_number)
  global json_data
  try:             
     utc_time = time.strptime((str(block_timestamp)[:16]), "%Y-%m-%d %H:%M")
     epoch_time_start = timegm(utc_time)
     epoch_time_end= epoch_time_start + 60
          
     epoch_time_start *= 1000000000
     epoch_time_end *= 1000000000
    
     print(epoch_time_start)
     print(epoch_time_end)
     payload = {'timestamp.gte':epoch_time_start, 'timestamp.lt': epoch_time_end, 'apiKey':'doTssV61rPBvcQuYVUQvKLNOwW6ZGc8w','sort':'timestamp','order':'desc','limit':50000}
     url = BASE_URL + "/vX/trades/X:ETH-USD"
  
     response = requests.get(url, params=payload)
     json_data = json.loads(response.text)
     
     insertToDatabase(block_number, block_timestamp)     
  except:
     logging.error("Oops! %s occurred", sys.exc_info()[0], block_number)

def insertToDatabase(block_number, block_timestamp):
  original_epoch_time = timegm(time.strptime((str(block_timestamp)), "%Y-%m-%d %H:%M:%S"))
  
  if (json_data.get("status") and (json_data.get("status") == "OK") and (len(json_data.get("results")) > 0)):
     converted_to = 'USD'
     conversion_type = ''
     conversion_rate = ''
     conversion_at = ''
     
     prev_result = {}
     for result in json_data.get("results"):
         participant_timestamp = result.get("participant_timestamp")//1000000000
         current_diff = participant_timestamp - original_epoch_time        
                  
         if(current_diff <= 0):
             prev_result = result
             break
             
         prev_result = result         
     
     logging.info("Found:::%s %s", block_number, prev_result.get("id"))     
     if ((len(prev_result.get("conditions")) > 0)):
         conversion_type = prev_result.get("conditions")[0]
     else:
         logging.error("No conversion_type found for the block number:%s", block_number)
         return
         
     if(prev_result.get("price")):
         conversion_rate = prev_result.get("price")
     else:   
         logging.error("No conversion_rate found for the block number:%s", block_number)
         return
     
     if(prev_result.get("participant_timestamp")):
         conversion_at = int(prev_result.get("participant_timestamp"))//1000000000
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
  prev_timestamp = ''
  #conn1 = psycopg2.connect(host=os.getenv('dbhost'), dbname=os.getenv('dbname'), user=os.getenv('dbuser'), password=os.getenv('dbpwd'), port=os.getenv('dbport'))
  conn1 = psycopg2.connect(host='localhost', dbname='ether', user='ether', password='ether', port=5432)
  with conn1.cursor("transactions") as cur:
      cur.itersize = 200
      cur.execute("select distinct block_number, block_timestamp from transactions where block_number >= %s and block_number <= %s order by block_number", record)
            
      for row in cur:          
         current_timestamp = str(row[1])[:16]         
         if(prev_timestamp != '' and current_timestamp == prev_timestamp):            
            insertToDatabase(row[0], row[1])
         else:
            fetch_rate(row[0], row[1])
            
         prev_timestamp = current_timestamp
         
         count += 1
         if count % 100 == 0:
            logging.info("Processed:%s records", count)
   
  logging.info("Processing of records are completed")
   
#conn = psycopg2.connect(host='localhost', dbname='ether', user='ether', password='ether', port='5432')
Log_Format = "%(levelname)s %(asctime)s - %(message)s"

logging.basicConfig(filename = 'C:/vishal/firstlog.log',
                    filemode = "w",
                    format = Log_Format,
                    level = logging.INFO)

logger = logging.getLogger()
json_data = {}
logging.info('Script is started')
conn = psycopg2.connect(host='localhost', dbname='ether', user='ether', password='ether', port=5432)
#conn = psycopg2.connect(host=os.getenv('dbhost'), dbname=os.getenv('dbname'), user=os.getenv('dbuser'), password=os.getenv('dbpwd'), port=os.getenv('dbport'))
logging.info("Database connected successfully!")
#process_transactions()
fetch_rate('12288711','2019-03-26 01:10:11')
conn.close()