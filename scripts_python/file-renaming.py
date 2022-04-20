#pip install beautifulsoup4 requests
#This python script is for scrapping addresses for the given labels.
#Input - scrap-label-data.csv file - Single column file containing list of labels.
#Output - /opt/<label>.csv file containing addresses of a given label
#Need to replace value of cookie before running this script by login with etherscan.io site.

import csv
from datetime import date, datetime, time
from bs4 import BeautifulSoup
import time
import traceback
import os

def process_file(file_name):
  t_start = time.time()
  t_process_csv = 0
  t_insert_addresses = 0
  
  with open(file_name, 'r',encoding='utf8') as f:
    csv.field_size_limit(2147483647)
    csv_f = csv.reader(f)
    set_addresses = set()
    
    for counter, row in enumerate(csv_f):
      if counter == 0:
        continue
      label=row[0].lower().replace(" ", "-").replace(".","-").replace("/","").replace("(","").replace(")","")
      category=row[1].lower()      
      oldfilename="C:/vishal/data/" + label+".csv"
      newfilename="C:/vishal/data/" + category + "$$$" + label + ".csv"
      os.rename(oldfilename, newfilename)
      
    t_process_csv = time.time()
    t_insert_addresses = time.time()

    print("records: ", counter, "ReadCSV: ", t_process_csv - t_start)
    f.close()

csvfilepath = 'scrap-label-category-data.csv'
process_file(csvfilepath)

