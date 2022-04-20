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
import urllib.request
import requests
from requests.structures import CaseInsensitiveDict
import re

#scrap base url
baseurl = "https://etherscan.io/accounts/label/"

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
      scrap_site(label)      

    t_process_csv = time.time()
    t_insert_addresses = time.time()

    print("records: ", counter, "ReadCSV: ", t_process_csv - t_start)
    f.close()

def scrap_site(label):
  siteurl= baseurl + label + "?subcatid=undefined&size=100&start=0&col=2&order=asc"
  headers = CaseInsensitiveDict()
    
  print(siteurl)  
  user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7'
  headers["Cookie"] = cookie
  headers["User-Agent"] = user_agent
  #headers={'User-Agent':user_agent,}
  
  try:
    request=urllib.request.Request(siteurl,None,headers) 
    page = urllib.request.urlopen(request)
  except Exception:
    print("Error opening the URL")
    traceback.print_exc()
    exit()

  # parse the html using beautiful soup and store in variable `soup`
  soup = BeautifulSoup(page, 'html.parser')

  # Take out the <div> of name and get its value
  table1 = soup.find_all('table')
  
  tbody = table1[0].tbody.find_all("tr")
  tfoot = table1[0].tfoot.find_all("th")[1].text

  found = re.search('Sum of (.+?)Account', tfoot).group(1).replace(",","")
  totalpages = int(found) // 100
  
  if int(found) % 100 != 0:
      totalpages += 1
  
  print("URL:", siteurl)
  print("Total records:", found)
  print("Total page:", totalpages)
  
  # Lets now iterate through the head HTML code and make list of clean headings
  generatedfilepath="/opt/" + label + ".csv"
  f = open(generatedfilepath, 'w', newline='')
  writer = csv.writer(f)
  
  # Declare empty list to keep Columns names
  headings = []
  for item in tbody:
    writer.writerow([item.find_all("td")[0].a.text])
  
  if totalpages > 1:
    for pagecounter in range(1, totalpages):  
       time.sleep(2)
       scrap_page(label, (pagecounter*100), writer)

def scrap_page(label, pagenumber, writer):
  siteurl= baseurl + label + "?subcatid=undefined&size=100&start=" + str(pagenumber) +"&col=2&order=asc"
  headers = CaseInsensitiveDict()
  
  print(siteurl)  
  user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7'
  headers["Cookie"] = cookie
  headers["User-Agent"] = user_agent
    
  try:
    request=urllib.request.Request(siteurl,None,headers) 
    page = urllib.request.urlopen(request)
  except Exception:
    print("Error opening the URL")
    traceback.print_exc()
    exit()

  # parse the html using beautiful soup and store in variable `soup`
  soup = BeautifulSoup(page, 'html.parser')

  # Take out the <div> of name and get its value
  table1 = soup.find_all('table')
  
  tbody = table1[0].tbody.find_all("tr")
       
  # Declare empty list to keep Columns names
  headings = []
  for item in tbody:
    writer.writerow([item.find_all("td")[0].a.text])
   

csvfilepath = 'scrap-label-data.csv'
cookie = "_ga=GA1.2.1358972824.1643079236; etherscan_cookieconsent=True; _gid=GA1.2.1216876324.1644021520; ASP.NET_SessionId=s0dh1zgc4jah0qvur3dhcwcg; __cflb=02DiuFnsSsHWYH8WqVXcJWaecAw5gpnmeXApXujxjzaXn; __cf_bm=kOfgsjDMXUEOo.0oVxbM1ogclno11MXNRkEnbFWGyoU-1644194364-0-AcMk7BkMdlVOfqc7ClfHd+l/+zvqj3dJEFYzRoknkrkI0WxIiOTMFxZhyCrWLNYbGxUk8yd2sG7sh/7WASrsCtouAfCJDBmqrRomofVXwDhJDErQQ1pZZUY8YhEMiKZknA==; _gat_gtag_UA_46998878_6=1"

process_file(csvfilepath)

