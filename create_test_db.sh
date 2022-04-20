docker-compose up  1>/dev/null 2>1 &
sleep 10
docker exec db_postgres mkdir -p /tmp/disks/postgres_ether_ssd/data/
docker exec db_postgres chown -R postgres /tmp/
docker cp ./structure_ether.sql db_postgres:/structure_ether.sql
docker exec db_postgres psql test test -f /structure_ether.sql

docker cp ./addresses.csv db_postgres:/addresses.csv
docker cp ./transactions.csv db_postgres:/transactions.csv

# Commented following two as the referenced csv files are not updated based on the new datamodel
#docker exec db_postgres psql test test -c "\COPY addresses(address1,address2,flags,tags) FROM '/addresses.csv' DELIMITER ',' CSV HEADER;"
#docker exec db_postgres psql test test -c "\COPY transactions(hash1,has2,from_address1,from_address2,to_address1,to_address2,value,block_timestamp,block_number) FROM '/transactions.csv' DELIMITER ',' CSV HEADER;"

docker exec db_postgres psql test test -c "insert into tags(tag) values('TestTag');"
