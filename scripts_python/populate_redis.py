import psycopg2
import sys
import os
import uuid
import redis

def fetch_transactions(start_block, end_block):
  count = 0
  #conn1 = psycopg2.connect(host=os.getenv('dbhost'), dbname=os.getenv('dbname'), user=os.getenv('dbuser'), password=os.getenv('dbpwd'), port=os.getenv('dbport'))
  conn1 = psycopg2.connect(host='localhost', dbname='postgres', port='5432')
  r = redis.Redis(host='localhost', port=6379, db=0)

  with conn1.cursor("transactions") as cur:
      cur.execute(f"select from_address1, from_address2, to_address1, to_address2, sum(value) as value from transactions where block_number>={start_block} and block_number <= {end_block} group by 1,2,3,4")
      i = 0
      for row in cur:
         #print(row[0], row[1], row[2], row[3], row[4])
         hex_from_address = (uuid.UUID(row[0]).hex + '{:08x}'.format(row[1] & ((1 << 32)-1)  )  ).lower()
         byte_from_address = bytes.fromhex(hex_from_address)
         hex_to_address = ""
         if row[2] is not None:
          hex_to_address = (uuid.UUID(row[2]).hex + '{:08x}'.format(row[3] & ((1 << 32)-1)  )  ).lower()
          byte_to_address = bytes.fromhex(hex_to_address)
         val = float(row[4])
         #print(row[4], val)
         #print(row[0], uuid.UUID(row[0]).hex, row[1], '{:08x}'.format(row[1] & ((1 << 32)-1)  ), row[4] )
         r.hincrbyfloat(byte_from_address, byte_to_address, val)
         #print(r.hget(byte_from_address, byte_to_address), r.memory_usage(byte_from_address))
         #print(r.hgetall(byte_from_address), r.memory_usage(byte_from_address))

         i = i + 1
         if i%100 == 0:
           break
           print(i)
         #print(hex_address)
         #print(len(byte_address))

fetch_transactions(0,100000)

# docker run -d --name localredis -p 6379:6379 redis
# docker exec -it localredis bash
