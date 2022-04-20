import psycopg2
from decimal import Decimal
from datetime import date, datetime, time, timedelta, datetime
import time
import requests
import json
import sys
import os
from calendar import timegm
import logging
import statistics

BASE_URL = "https://api.exchange.coinbase.com";

def sendRequest(start_utc_time, end_utc_time, block_number):
  
  global json_data
  try:         
     logging.info("Sending Request to fetch data start:%s end:%s",str(start_utc_time),str(end_utc_time))
     payload = {'granularity':60, 'start': start_utc_time, 'end': end_utc_time}
     url = BASE_URL + "/products/ETH-USD/candles"
  
     response = requests.get(url, params=payload)
     json_data = json.loads(response.text)         
  except:
     json_data = {}
     logging.error("Failed to get data from coinbase Start:%s End:%s BlockNumber:", start_utc_time, end_utc_time, block_number)
     logging.error("Oops! %s occurred", sys.exc_info()[0])
     return False
  return True

def insertToDatabase(block_number, block_timestamp):
    
  if (json_data):
     converted_to = 'USD'
     
     block_epoch_time = timegm(time.strptime((str(block_timestamp)[:16]), "%Y-%m-%d %H:%M"))
          
     current = []
     counter = 0
     while counter < 5:
       counter += 1
       for data in json_data:
         if(block_epoch_time == int(data[0])):
             current = data
             break
       if(current)
           break
       block_epoch_time -= 60
             
  
     if(current):
        print("Low",current[1],"High",current[2])
        converted_rate = statistics.mean([current[1], current[2]])
        insert_query = 'insert into eth_rates (conversion_rate, converted_at, converted_to, block_number) values (%s, %s, %s, %s)'             
        cur = conn.cursor()  
        record = (converted_rate, block_timestamp, converted_to, block_number)
        cur.execute(insert_query, record)
        conn.commit()
     else:
        logging.info("No data found for block number: %s and time: %s", block_number, block_timestamp)      
  else:
     logging.error("Json data is blank. BlockNumber:%s BlockTime:", block_number, block_timestamp)     
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
         repeat = True
         block_timestamp = datetime.strptime((str(row[1])[:16]), "%Y-%m-%d %H:%M")      
         if(not json_data or block_timestamp < start_utc_time or block_timestamp > end_utc_time):          
           start_utc_time = datetime.strptime((str(row[1])[:16]), "%Y-%m-%d %H:%M")
           end_utc_time = start_utc_time + timedelta(hours=4)
           while repeat == True:
               if(not sendRequest(start_utc_time, end_utc_time, row[0])):
                  logging.error("Fetching data failed for Start:%s End:%s BlockNumber:", start_utc_time, end_utc_time,row[0])
                  sendRequest(start_utc_time, end_utc_time, row[0])
                  repeat = False
               else:
                  break
         insertToDatabase(row[0], row[1])        
                  
         count += 1
         if count % 5000 == 0:
            logging.info("Processed:%s records", count)
   
  logging.info("Processing of records are completed")
   
#conn = psycopg2.connect(host='localhost', dbname='ether', user='ether', password='ether', port='5432')
Log_Format = "%(levelname)s %(asctime)s - %(message)s"

logging.basicConfig(filename = "C:/vishal/firstlog.log",
                    filemode = "w",
                    format = Log_Format,
                    level = logging.INFO)

logger = logging.getLogger()
json_data = {}
logging.info('Script is started')
conn = psycopg2.connect(host='localhost', dbname='ether', user='ether', password='ether', port=5432)
#conn = psycopg2.connect(host=os.getenv('dbhost'), dbname=os.getenv('dbname'), user=os.getenv('dbuser'), password=os.getenv('dbpwd'), port=os.getenv('dbport'))
logging.info("Database connected successfully!")
process_transactions()
conn.close()