for i in {13567323..13570000..1000}
  do
    echo $i
    sudo bq query --format csv --max_rows 10000000 --use_legacy_sql=false --parameter=start:INT64:$i --parameter=end:INT64:$(expr $i + 1000) 'SELECT * FROM bigquery-public-data.crypto_ethereum.transactions where block_number >= @start and block_number < @end' > /opt/transaction$i.csv
    gsutil mv /opt/transaction$i.csv 'gs://eth_ingestion'
  done
