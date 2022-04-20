#pip install beautifulsoup4 requests
#This python script is for scrapping description for the given labels.
#Input - /opt/tags.csv file - Single column file containing list of labels.
#Output - /opt/labels_with_description.csv file containing labels with it's description in csv format.
import csv
from datetime import date, datetime, time
from bs4 import BeautifulSoup
import time
import traceback
import urllib.request

#scrap base url
baseurl = "https://etherscan.io/accounts/label/"

def process_file(file_name):
  t_start = time.time()
  t_process_csv = 0
  t_insert_addresses = 0
  
  f = open('/opt/labels_with_description.csv', 'w', newline='')
  writer = csv.writer(f)
  
  with open(file_name, 'r',encoding='utf8') as f:
    csv.field_size_limit(2147483647)
    csv_f = csv.reader(f)
    set_addresses = set()
    
    for counter, row in enumerate(csv_f):
      if counter == 0:
        continue
      label=row[0].lower().replace(" ", "-").replace(".","-").replace("/","").replace("(","").replace(")","")
      description=scrap_tag(label)
      description=description.strip()
      description=description.rstrip('"')
      description=description.lstrip('"')
      
      if description.startswith("AddressName") == True:
          description="IT IS A BLANK DESCRIPTION SO, CHECK IT"
          print("It's a blank Description for ", label)
          
      if (not description):
          description="Found BLANK DESCRIPTION SO, CHECK IT"
          print("It's a blank Description for ", label)
          
      print("Description",description)
      
      writer.writerow([label,description])
      time.sleep(2)

    t_process_csv = time.time()
    t_insert_addresses = time.time()

    print("records: ", counter, "ReadCSV1: ", t_process_csv - t_start)
    f.close()

def scrap_tag(label):
  siteurl= baseurl + label
  print("Site", siteurl)
  
  user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7'
  headers={'User-Agent':user_agent,}

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
  description = soup.find('div', {"class": "card-body"})
  
  if description is not None:
     description=description.text
  if description is None:
     description = ''
    
  #totaltext = soup.find('div', {"class": "card-body"}).text
  
  return description
  #print("Total", totaltext)
 
  
csvfilepath = '/opt/tags.csv'
process_file(csvfilepath)

