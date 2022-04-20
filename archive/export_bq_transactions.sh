#!/bin/bash
for i in {13567323..13570000..1000}
  do
        ii=$(($i+1000))
        bq query --format csv --max_rows 100000000 --use_legacy_sql=false "SELECT * FROM bigquery-public-data.crypto_ethereum.transactions where block_number >= $i and block_number < $ii" > ./transaction$i.csv
    gsutil mv ./transaction$i.csv 'gs://eth_ingestion'
  done