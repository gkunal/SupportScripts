for i in {000000000000..000000002310..1}
  do
    cat ./vjhala_export_zone/contract$i | grep -Po '"address":"\K[^"]*' > ./vjhala_export_zone/contract$i.csv
    echo contract$i
  done