create table tags (
  pk serial primary key,
  tag text NOT NULL
);
create unique index idx_tags_tag on tags(tag);

create table address_tags (
  pk serial primary key,
  tag_fk INTEGER NOT NULL,
  address_fk INTEGER NOT NULL
);
create unique index idx_address_tags_tag_address_fk on address_tags(tag_fk,address_fk);

create table addresses (
  pk serial primary key,
  address text NOT NULL,
  eth_balance numeric(30,0) NOT NULL default 0,
  received_count INTEGER,
  sent_count INTEGER,
  eth_received numeric(30,0),
  eth_sent numeric(30,0),
  oldest_block INTEGER,
  newest_block INTEGER,
  is_contract_address smallint,
  tag_fk INTEGER
);
create unique index idx_addresses_address on addresses(address);
create index idx_transactions_is_contract_address on addresses(is_contract_address);
create index idx_transactions_tags_fk on addresses(tag_fk);



--For copy command
create table transactions_temp_2 (
  nonce bigint NOT NULL,
  hash text NOT NULL,
  transaction_index	INTEGER NOT NULL,
  from_address TEXT NOT NULL,
  to_address TEXT,
  value	numeric(30,0),
  gas	numeric(30,0),
  receipt_contract_address TEXT,
  receipt_root TEXT,
  receipt_status smallint,
  block_timestamp	TIMESTAMP NOT NULL,
  block_number bigint NOT NULL,
  block_hash TEXT NOT NULL,
  transaction_type smallint,
  input TEXT,
  gas_price	numeric(30,0),
  receipt_cumulative_gas_used	numeric(30,0),
  receipt_gas_used numeric(30,0),
  receipt_effective_gas_price	numeric(30,0),
  max_fee_per_gas	numeric(30,0),
  max_priority_fee_per_gas numeric(30,0)
);
-- Import data first before creating below index. -- originally 2
SET max_parallel_maintenance_workers TO 5

--originally 64 MB
SET maintenance_work_mem TO '4 GB';

SET max_wal_size TO '10 GB';

create index idx_transactions_temp_2_block_number on transactions_temp_2(block_number);

create table transactions (
  pk serial primary key,
  nonce bigint NOT NULL,
  hash text NOT NULL,
  transaction_index	INTEGER NOT NULL,
  from_address TEXT NOT NULL,
  to_address TEXT,
  value	numeric(30,0),
  gas	numeric(30,0),
  receipt_contract_address TEXT,
  receipt_root TEXT,
  receipt_status smallint,
  block_timestamp	TIMESTAMP NOT NULL,
  block_number bigint NOT NULL,
  block_hash TEXT NOT NULL,
  transaction_type smallint
--  from_address_fk INTEGER,
--  to_address_fk INTEGER,
--  gas_price	numeric(30,18),
--  receipt_cumulative_gas_used	numeric(30,18),
--  receipt_gas_used numeric(30,18),
--  receipt_effective_gas_price	numeric(30,18)
--  max_fee_per_gas	numeric(30,18),
--  max_priority_fee_per_gas numeric(30,18),
);
create unique index idx_transactions_hash on transactions(lower(hash));
create index idx_transactions_to_address on transactions(to_address);
create index idx_transactions_from_address on transactions(from_address);
create index idx_transactions_block_number on transactions(block_number);

create table feedbacks (
  pk serial primary key,
  type text,
  email text,
  content text
);
create index idx_feedbacks_type on feedbacks(type);


insert into transactions
(from_address_fk, to_address_fk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select adf.pk, adt.pk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
join addresses adf on adf.address = t.from_address
join addresses adt on adt.address = t.to_address
where block_number >= 1000000
and block_number < 5000000;


select count(from_address_fk) sent_count, sum(value) eth_sent, min(t.block_number), max(t.block_number)
from transactions t
join addresses a on a.pk = t.from_address_fk
  and a.address = 'xxx'
  received_count INTEGER,
  sent_count INTEGER,
  eth_received numeric(30,18),
  eth_sent numeric(30,18),
  oldest_block numeric(30,18),
  newest_block numeric(30,18)
;



gsutil -m cp -z \
  "gs://vjhala_export_zone/balances000000000001" \
  .

gsutil -m cp -z \
  "gs://vjhala_export_zone/balances000000000000" \
  "gs://vjhala_export_zone/balances000000000001" \
  "gs://vjhala_export_zone/balances000000000002" \
  "gs://vjhala_export_zone/balances000000000003" \
  "gs://vjhala_export_zone/balances000000000004" \
  "gs://vjhala_export_zone/balances000000000005" \
  "gs://vjhala_export_zone/balances000000000006" \
  "gs://vjhala_export_zone/balances000000000007" \
  "gs://vjhala_export_zone/balances000000000008" \
  "gs://vjhala_export_zone/balances000000000009" \
  "gs://vjhala_export_zone/balances000000000010" \
  "gs://vjhala_export_zone/balances000000000011" \
  "gs://vjhala_export_zone/balances000000000012" \
  "gs://vjhala_export_zone/balances000000000013" \
  "gs://vjhala_export_zone/balances000000000014" \
  "gs://vjhala_export_zone/balances000000000015" \
  "gs://vjhala_export_zone/balances000000000016" \
  "gs://vjhala_export_zone/balances000000000017" \
  "gs://vjhala_export_zone/balances000000000018" \
  "gs://vjhala_export_zone/balances000000000019" \
  "gs://vjhala_export_zone/balances000000000020" \
  "gs://vjhala_export_zone/balances000000000021" \
  "gs://vjhala_export_zone/balances000000000022" \
  "gs://vjhala_export_zone/balances000000000023" \
  .
gsutil stat "gs://vjhala_export_zone/balances000000000000"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000000"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000002"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000003"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000004"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000005"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000006"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000007"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000008"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000009"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000010"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000011"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000012"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000013"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000014"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000015"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000016"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000017"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000018"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000019"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000020"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000021"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000022"
gsutil setmeta -h "Content-Encoding:gzip" "gs://vjhala_export_zone/balances000000000023"









psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000000' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000001' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000002' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000003' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000004' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000005' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000006' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000007' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000008' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000009' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000010' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000011' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000012' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000013' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000014' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000015' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000016' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000017' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000018' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000019' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000020' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000021' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000022' DELIMITER ',' CSV HEADER;"
psql ether_dev -c "\COPY addresses(address, eth_balance) FROM '/Volumes/JS/csv/balances000000000023' DELIMITER ',' CSV HEADER;"


insert into transactions
(from_address_fk, to_address_fk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select adf.pk, adt.pk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
join addresses adf on adf.address = t.from_address
join addresses adt on adt.address = t.to_address
where block_number >= 1000000
and block_number < 2000000;

select now();
insert into transactions
(from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select lower(from_address), lower(to_address), hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
where block_number >= 3000000
and block_number < 5000000;
select now();

select now();
insert into transactions
(from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
where block_number >= 5000000
and block_number < 6000000;
select now();

select now();
insert into transactions
(from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
where block_number >= 6000000
and block_number < 7000000;
select now();


select now();
insert into transactions
(from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
where block_number >= 7000000
and block_number < 8000000;
select now();

select now();
insert into transactions
(from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
where block_number >= 8000000
and block_number < 9000000;
select now();

select now();
insert into transactions
(from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
where block_number >= 9000000
and block_number < 10000000;
select now();

select now();
insert into transactions
(from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
where block_number >= 10000000
and block_number < 11000000;
select now();

select now();
insert into transactions
(from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
where block_number >= 11000000
and block_number < 12000000;
select now();

select now();
insert into transactions
(from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
where block_number >= 12000000
and block_number < 13000000;
select now();

select now();
insert into transactions
(from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
where block_number >= 13000000
and block_number < 14000000;
select now();

select now();
insert into transactions
(from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
where block_number >= 14000000
and block_number < 15000000;
select now();











insert into transactions
(from_address_fk, to_address_fk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select adf.pk, adt.pk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
join addresses adf on adf.address = t.from_address
join addresses adt on adt.address = t.to_address
where block_number >= 3000000
and block_number < 4000000;

insert into transactions
(from_address_fk, to_address_fk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select adf.pk, adt.pk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
join addresses adf on adf.address = t.from_address
join addresses adt on adt.address = t.to_address
where block_number >= 4000000
and block_number < 5000000;

insert into transactions
(from_address_fk, to_address_fk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select adf.pk, adt.pk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
join addresses adf on adf.address = t.from_address
join addresses adt on adt.address = t.to_address
where block_number >= 5000000
and block_number < 6000000;

insert into transactions
(from_address_fk, to_address_fk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select adf.pk, adt.pk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
join addresses adf on adf.address = t.from_address
join addresses adt on adt.address = t.to_address
where block_number >= 6000000
and block_number < 7000000;

insert into transactions
(from_address_fk, to_address_fk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select adf.pk, adt.pk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
join addresses adf on adf.address = t.from_address
join addresses adt on adt.address = t.to_address
where block_number >= 7000000
and block_number < 8000000;

insert into transactions
(from_address_fk, to_address_fk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select adf.pk, adt.pk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
join addresses adf on adf.address = t.from_address
join addresses adt on adt.address = t.to_address
where block_number >= 8000000
and block_number < 9000000;

insert into transactions
(from_address_fk, to_address_fk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select adf.pk, adt.pk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
join addresses adf on adf.address = t.from_address
join addresses adt on adt.address = t.to_address
where block_number >= 9000000
and block_number < 10000000;

insert into transactions
(from_address_fk, to_address_fk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select adf.pk, adt.pk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
join addresses adf on adf.address = t.from_address
join addresses adt on adt.address = t.to_address
where block_number >= 10000000
and block_number < 11000000;

insert into transactions
(from_address_fk, to_address_fk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select adf.pk, adt.pk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
join addresses adf on adf.address = t.from_address
join addresses adt on adt.address = t.to_address
where block_number >= 11000000
and block_number < 12000000;

insert into transactions
(from_address_fk, to_address_fk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select adf.pk, adt.pk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
join addresses adf on adf.address = t.from_address
join addresses adt on adt.address = t.to_address
where block_number >= 12000000
and block_number < 13000000;

insert into transactions
(from_address_fk, to_address_fk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
select adf.pk, adt.pk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
from transactions_temp_2 t
join addresses adf on adf.address = t.from_address
join addresses adt on adt.address = t.to_address
where block_number >= 13000000
and block_number < 14000000;

ether_dev=# alter table transactions add column from_address_fk integer, add column to_address_fk integer;


update addresses
          set received_count = r_count,
          eth_received = e_received
        from(
          select count(*) r_count, sum(value) e_received
          from transactions
          where lower(to_address) = lower(address)
        ) as rcv

;


psql ether_dev -f 2.sql &
psql ether_dev -f 3.sql &
psql ether_dev -f 4.sql &
psql ether_dev -f 5.sql &
psql ether_dev -f 6.sql &
psql ether_dev -f 7.sql &
psql ether_dev -f 8.sql &
psql ether_dev -f 9.sql &
psql ether_dev -f 10.sql &
psql ether_dev -f 11.sql &
psql ether_dev -f 12.sql &
psql ether_dev -f 13.sql &
psql ether_dev -f 14.sql &
psql ether_dev -f 15.sql &
psql ether_dev -f 16.sql &
pql ether_dev -f 17.sql &
psql ether_dev -f 18.sql &
psql ether_dev -f 19.sql &
psql ether_dev -f 20.sql &

select count(*),
case
  when received_count >= 100000 then '>100,000'
  when received_count >= 90000 and received_count < 100000 then '>90,000'
  when received_count >= 80000 and received_count < 90000 then '>80,000'
  when received_count >= 70000 and received_count < 80000 then '>70,000'
  when received_count >= 60000 and received_count < 70000 then '>60,000'
  when received_count >= 50000 and received_count < 60000 then '>50,000'
  when received_count >= 40000 and received_count < 50000 then '>40,000'
  when received_count >= 30000 and received_count < 40000 then '>30,000'
  when received_count >= 20000 and received_count < 30000 then '>20,000'
  when received_count >= 10000 and received_count < 20000 then '>10,000'
  when received_count >0 and received_count < 10000 then '<10,000'
end as range from addresses a
group by 2
;

select count(*),
case
  when received_count >= 10000 then '>10,000'
  when received_count >= 9000 and received_count < 10000 then '>90,00'
  when received_count >= 8000 and received_count < 9000 then '>80,00'
  when received_count >= 7000 and received_count < 8000 then '>70,00'
  when received_count >= 6000 and received_count < 7000 then '>60,00'
  when received_count >= 5000 and received_count < 6000 then '>50,00'
  when received_count >= 4000 and received_count < 5000 then '>40,00'
  when received_count >= 3000 and received_count < 4000 then '>30,00'
  when received_count >= 2000 and received_count < 3000 then '>20,00'
  when received_count >= 1000 and received_count < 2000 then '>10,00'
  when received_count >0 and received_count < 1000 then '<10,00'
end as range from addresses a
group by 2
;

select count(*),
case
  when received_count >= 1000 then '>10,00'
  when received_count >= 900 and received_count < 1000 then '>900'
  when received_count >= 800 and received_count < 900 then '>800'
  when received_count >= 700 and received_count < 800 then '>700'
  when received_count >= 600 and received_count < 700 then '>600'
  when received_count >= 500 and received_count < 600 then '>500'
  when received_count >= 400 and received_count < 500 then '>400'
  when received_count >= 300 and received_count < 400 then '>300'
  when received_count >= 200 and received_count < 300 then '>200'
  when received_count >= 100 and received_count < 200 then '>100'
  when received_count >0 and received_count < 100 then '<100'
end as range from addresses a
group by 2
;

select count(*),
case
  when sent_count >= 100000 then '>100,000'
  when sent_count >= 90000 and sent_count < 100000 then '>90,000'
  when sent_count >= 80000 and sent_count < 90000 then '>80,000'
  when sent_count >= 70000 and sent_count < 80000 then '>70,000'
  when sent_count >= 60000 and sent_count < 70000 then '>60,000'
  when sent_count >= 50000 and sent_count < 60000 then '>50,000'
  when sent_count >= 40000 and sent_count < 50000 then '>40,000'
  when sent_count >= 30000 and sent_count < 40000 then '>30,000'
  when sent_count >= 20000 and sent_count < 30000 then '>20,000'
  when sent_count >= 10000 and sent_count < 20000 then '>10,000'
  when sent_count >0 and sent_count < 10000 then '<10,000'
end as range from addresses a
group by 2
;

select to_address from transactions t
where from_address = lower('0xaA923Cd02364Bb8A4c3d6F894178d2e12231655C')
;


select distinct to_address, received_count, sent_count from transactions t
join addresses a on a.address = lower(t.to_address)
where lower(from_address) = lower('0xaA923Cd02364Bb8A4c3d6F894178d2e12231655C')
;



select to_address from transactions t
where lower(from_address) = lower('0xaA923Cd02364Bb8A4c3d6F894178d2e12231655C')


Level 1
select distinct(to_address) from transactions t
where lower(from_address) in (
lower('0x30d4bffec44037f5fe9d4336968c573cba9d018a'),
lower('0x3fbaa73a433daa0f6c43d1c732c3f97a86f3a427')
);
select received_count, sent_count from addresses a
where address in (
lower('0x30d4bffec44037f5fe9d4336968c573cba9d018a'),
lower('0x3fbaa73a433daa0f6c43d1c732c3f97a86f3a427')
);

Level 2
select distinct(to_address) from transactions t
where lower(from_address) in (
lower('0x3fbaa73a433daa0f6c43d1c732c3f97a86f3a427'),
lower('0xd96ba527be241c2c31fd66cbb0a9430702906a2a')
);
select received_count, sent_count from addresses a
where address in (
lower('0x3fbaa73a433daa0f6c43d1c732c3f97a86f3a427'),
lower('0xd96ba527be241c2c31fd66cbb0a9430702906a2a')
);

Level 3
select distinct(to_address) from transactions t
where lower(from_address) in (
lower('0x3fbaa73a433daa0f6c43d1c732c3f97a86f3a427'),
lower('0xd294ac18b524ff59ab7fffcbd459f11128220550'),
lower('0x106018ce967e52e34bf27153197c7756235d972b'),
lower('0x96afcaa806d98713cf169ad95ed8e509ebf3f4a0'),
lower('0xb7e55d89850b67ab2ffb1a54e3a9f18b916f88b2'),
lower('0xfe61ad22a847c4df702731c7d5e803d283ea1376'),
lower('0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11')
);

select received_count, sent_count from addresses a
where address in (
lower('0x3fbaa73a433daa0f6c43d1c732c3f97a86f3a427'),
lower('0xd294ac18b524ff59ab7fffcbd459f11128220550'),
lower('0x106018ce967e52e34bf27153197c7756235d972b'),
lower('0x96afcaa806d98713cf169ad95ed8e509ebf3f4a0'),
lower('0xb7e55d89850b67ab2ffb1a54e3a9f18b916f88b2'),
lower('0xfe61ad22a847c4df702731c7d5e803d283ea1376'),
lower('0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11')
);

Leve 4
select distinct(to_address) from transactions t
where lower(from_address) in (
lower('0xeec606a66edb6f497662ea31b5eb1610da87ab5f'),
lower('0xd8a83b72377476d0a66683cde20a8aad0b628713'),
lower('0xd96ba527be241c2c31fd66cbb0a9430702906a2a'),
lower('0x39d9f4640b98189540a9c0edcfa95c5e657706aa'),
lower('0x7d90b19c1022396b525c64ba70a293c3142979b7'),
lower('0xdc0b72b3ea6b41eebb4666ceaca18e3fad6bfd55'),
lower('0xc5883084a66ac9e08379256269c18345ccefe458'),
lower('0x845f93f489b524f19864db6e0ab581c532b58d36'),
lower('0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11'),
lower('0x5861b8446a2f6e19a067874c133f04c578928727'),
lower('0xf775a9a0ad44807bc15936df0ee68902af1a0eee'),
lower('0xf056f435ba0cc4fcd2f1b17e3766549ffc404b94')
);

select * from addresses a
where address in (
lower('0xeec606a66edb6f497662ea31b5eb1610da87ab5f'),
lower('0xd8a83b72377476d0a66683cde20a8aad0b628713'),
lower('0xd96ba527be241c2c31fd66cbb0a9430702906a2a'),
lower('0x39d9f4640b98189540a9c0edcfa95c5e657706aa'),
lower('0x7d90b19c1022396b525c64ba70a293c3142979b7'),
lower('0xdc0b72b3ea6b41eebb4666ceaca18e3fad6bfd55'),
lower('0xc5883084a66ac9e08379256269c18345ccefe458'),
lower('0x845f93f489b524f19864db6e0ab581c532b58d36'),
lower('0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11'),
lower('0x5861b8446a2f6e19a067874c133f04c578928727'),
lower('0xf775a9a0ad44807bc15936df0ee68902af1a0eee'),
lower('0xf056f435ba0cc4fcd2f1b17e3766549ffc404b94')
);

select distinct(to_address) from transactions t
where from_address in (
lower('0x90d78a49dfa03893d6f9caa4524b0bff6cda715f'),
lower('0x338fdf0d792f7708d97383eb476e9418b3c16ff1'),
lower('0x106018ce967e52e34bf27153197c7756235d972b'),
lower('0xd759ea4c6e8e2c77b7e04eeebc1fac32ed332dcc'),
lower('0xd8a83b72377476d0a66683cde20a8aad0b628713'),
lower('0x645565c47e2f1bba6d8941441b938724d3448c60'),
lower('0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'),
lower('0x7d90b19c1022396b525c64ba70a293c3142979b7'),
lower('0xc5883084a66ac9e08379256269c18345ccefe458'),
lower('0x845f93f489b524f19864db6e0ab581c532b58d36'),
lower('0xfe61ad22a847c4df702731c7d5e803d283ea1376'),
lower('0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11'),
lower('0xd294ac18b524ff59ab7fffcbd459f11128220550'),
lower('0xb7443e088232cd680ff20b7518eba2fc9e1b3c32'),
lower('0x96afcaa806d98713cf169ad95ed8e509ebf3f4a0'),
lower('0xb7e55d89850b67ab2ffb1a54e3a9f18b916f88b2'),
lower('0x621e2e9f1cdc03add35ab930b074f9419f294045')
);

select received_count, sent_count from addresses a
where address in (
lower('0x90d78a49dfa03893d6f9caa4524b0bff6cda715f'),
lower('0x338fdf0d792f7708d97383eb476e9418b3c16ff1'),
lower('0x106018ce967e52e34bf27153197c7756235d972b'),
lower('0xd759ea4c6e8e2c77b7e04eeebc1fac32ed332dcc'),
lower('0xd8a83b72377476d0a66683cde20a8aad0b628713'),
lower('0x645565c47e2f1bba6d8941441b938724d3448c60'),
lower('0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'),
lower('0x7d90b19c1022396b525c64ba70a293c3142979b7'),
lower('0xc5883084a66ac9e08379256269c18345ccefe458'),
lower('0x845f93f489b524f19864db6e0ab581c532b58d36'),
lower('0xfe61ad22a847c4df702731c7d5e803d283ea1376'),
lower('0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11'),
lower('0xd294ac18b524ff59ab7fffcbd459f11128220550'),
lower('0xb7443e088232cd680ff20b7518eba2fc9e1b3c32'),
lower('0x96afcaa806d98713cf169ad95ed8e509ebf3f4a0'),
lower('0xb7e55d89850b67ab2ffb1a54e3a9f18b916f88b2'),
lower('0x621e2e9f1cdc03add35ab930b074f9419f294045')
);


select distinct(to_address) from transactions t
where from_address in (
lower('0x90d78a49dfa03893d6f9caa4524b0bff6cda715f'),
lower('0xeec606a66edb6f497662ea31b5eb1610da87ab5f'),
lower('0x41dd55d4671756896b488626a9ca0a0ea1201539'),
lower('0x338fdf0d792f7708d97383eb476e9418b3c16ff1'),
lower('0xd8a83b72377476d0a66683cde20a8aad0b628713'),
lower('0xd759ea4c6e8e2c77b7e04eeebc1fac32ed332dcc'),
lower('0x645565c47e2f1bba6d8941441b938724d3448c60'),
lower('0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'),
lower('0x39d9f4640b98189540a9c0edcfa95c5e657706aa'),
lower('0x7d90b19c1022396b525c64ba70a293c3142979b7'),
lower('0x3a840d0164acca60292a6b594531dfc98af2701d'),
lower('0xdc0b72b3ea6b41eebb4666ceaca18e3fad6bfd55'),
lower('0xc5883084a66ac9e08379256269c18345ccefe458'),
lower('0x31e3b87dce4f76cb8bc6cdb6273391c29c59660b'),
lower('0x845f93f489b524f19864db6e0ab581c532b58d36'),
lower('0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11'),
lower('0xf32064321d84ce688b3cdee18dc31b5b54ce8cfb'),
lower('0xa449b6bb309c4d959539552545400f041cc4ae4c'),
lower('0x5861b8446a2f6e19a067874c133f04c578928727'),
lower('0xb7443e088232cd680ff20b7518eba2fc9e1b3c32'),
lower('0xa488827ffd2d5a69e76946955f10f1fef0fb94fb'),
lower('0x93db3aa973f7212b9baef9faf4fbcaea940311ea'),
lower('0xc3c75adc57b71fa0cba5e25cdc378101993d29a3'),
lower('0xf775a9a0ad44807bc15936df0ee68902af1a0eee'),
lower('0xf056f435ba0cc4fcd2f1b17e3766549ffc404b94'),
lower('0x552981f6e2ec9de9811e9490b7cac486c3a9dd32'),
lower('0x621e2e9f1cdc03add35ab930b074f9419f294045')
);

select received_count, sent_count from addresses a
where address in (
lower('0x90d78a49dfa03893d6f9caa4524b0bff6cda715f'),
lower('0xeec606a66edb6f497662ea31b5eb1610da87ab5f'),
lower('0x41dd55d4671756896b488626a9ca0a0ea1201539'),
lower('0x338fdf0d792f7708d97383eb476e9418b3c16ff1'),
lower('0xd8a83b72377476d0a66683cde20a8aad0b628713'),
lower('0xd759ea4c6e8e2c77b7e04eeebc1fac32ed332dcc'),
lower('0x645565c47e2f1bba6d8941441b938724d3448c60'),
lower('0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'),
lower('0x39d9f4640b98189540a9c0edcfa95c5e657706aa'),
lower('0x7d90b19c1022396b525c64ba70a293c3142979b7'),
lower('0x3a840d0164acca60292a6b594531dfc98af2701d'),
lower('0xdc0b72b3ea6b41eebb4666ceaca18e3fad6bfd55'),
lower('0xc5883084a66ac9e08379256269c18345ccefe458'),
lower('0x31e3b87dce4f76cb8bc6cdb6273391c29c59660b'),
lower('0x845f93f489b524f19864db6e0ab581c532b58d36'),
lower('0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11'),
lower('0xf32064321d84ce688b3cdee18dc31b5b54ce8cfb'),
lower('0xa449b6bb309c4d959539552545400f041cc4ae4c'),
lower('0x5861b8446a2f6e19a067874c133f04c578928727'),
lower('0xb7443e088232cd680ff20b7518eba2fc9e1b3c32'),
lower('0xa488827ffd2d5a69e76946955f10f1fef0fb94fb'),
lower('0x93db3aa973f7212b9baef9faf4fbcaea940311ea'),
lower('0xc3c75adc57b71fa0cba5e25cdc378101993d29a3'),
lower('0xf775a9a0ad44807bc15936df0ee68902af1a0eee'),
lower('0xf056f435ba0cc4fcd2f1b17e3766549ffc404b94'),
lower('0x552981f6e2ec9de9811e9490b7cac486c3a9dd32'),
lower('0x621e2e9f1cdc03add35ab930b074f9419f294045')
);



explain
select lower(to_address), sum(value) from transactions where lower(from_address) in (
'0x106018ce967e52e34bf27153197c7756235d972b', '0x96afcaa806d98713cf169ad95ed8e509ebf3f4a0', '0xb7e55d89850b67ab2ffb1a54e3a9f18b916f88b2',
'0xd294ac18b524ff59ab7fffcbd459f11128220550', '0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11', '0xd96ba527be241c2c31fd66cbb0a9430702906a2a',
'0xfe61ad22a847c4df702731c7d5e803d283ea1376') group by 1;

select lower(to_address), sum(value) from transactions where lower(from_address) in (
'0x106018ce967e52e34bf27153197c7756235d972b') group by 1;

select lower(to_address), sum(value) from transactions where lower(from_address) in (
'0x96afcaa806d98713cf169ad95ed8e509ebf3f4a0') group by 1;

select lower(to_address), sum(value) from transactions where lower(from_address) in (
'0xb7e55d89850b67ab2ffb1a54e3a9f18b916f88b2') group by 1;

select lower(to_address), sum(value) from transactions where lower(from_address) in (
'0xd294ac18b524ff59ab7fffcbd459f11128220550') group by 1;

select lower(to_address), sum(value) from transactions where lower(from_address) in (
'0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11') group by 1;

select lower(to_address), sum(value) from transactions where lower(from_address) in (
'0xd96ba527be241c2c31fd66cbb0a9430702906a2a') group by 1;

select lower(to_address), sum(value) from transactions where lower(from_address) in (
'0xfe61ad22a847c4df702731c7d5e803d283ea1376') group by 1;



update transactions set to_address = lower(to_address), from_address = lower(from_address) where pk < 1000;

select lower(to_address), sum(value) from transactions where lower(from_address) in (
'0x106018ce967e52e34bf27153197c7756235d972b', '0x96afcaa806d98713cf169ad95ed8e509ebf3f4a0', '0xb7e55d89850b67ab2ffb1a54e3a9f18b916f88b2',
'0xd294ac18b524ff59ab7fffcbd459f11128220550', '0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11', '0xd96ba527be241c2c31fd66cbb0a9430702906a2a',
'0xfe61ad22a847c4df702731c7d5e803d283ea1376') group by 1;


update transactions set from_address_fk = (select pk from addresses where address = lower('0x106018ce967e52e34bf27153197c7756235d972b'))
where lower(from_address) = lower('0x106018ce967e52e34bf27153197c7756235d972b');
update transactions set to_address_fk = (select pk from addresses where address = lower('0x106018ce967e52e34bf27153197c7756235d972b'))
where lower(to_address) = lower('0x106018ce967e52e34bf27153197c7756235d972b');


update transactions set from_address_fk = (select pk from addresses where address = lower('0x96afcaa806d98713cf169ad95ed8e509ebf3f4a0'))
where lower(from_address) = lower('0x96afcaa806d98713cf169ad95ed8e509ebf3f4a0');
update transactions set to_address_fk = (select pk from addresses where address = lower('0x96afcaa806d98713cf169ad95ed8e509ebf3f4a0'))
where lower(to_address) = lower('0x96afcaa806d98713cf169ad95ed8e509ebf3f4a0');


update transactions set from_address_fk = (select pk from addresses where address = lower('0xb7e55d89850b67ab2ffb1a54e3a9f18b916f88b2'))
where lower(from_address) = lower('0xb7e55d89850b67ab2ffb1a54e3a9f18b916f88b2');
update transactions set to_address_fk = (select pk from addresses where address = lower('0xb7e55d89850b67ab2ffb1a54e3a9f18b916f88b2'))
where lower(to_address) = lower('0xb7e55d89850b67ab2ffb1a54e3a9f18b916f88b2');


update transactions set from_address_fk = (select pk from addresses where address = lower('0xd294ac18b524ff59ab7fffcbd459f11128220550'))
where lower(from_address) = lower('0xd294ac18b524ff59ab7fffcbd459f11128220550');
update transactions set to_address_fk = (select pk from addresses where address = lower('0xd294ac18b524ff59ab7fffcbd459f11128220550'))
where lower(to_address) = lower('0xd294ac18b524ff59ab7fffcbd459f11128220550');


update transactions set from_address_fk = (select pk from addresses where address = lower('0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11'))
where lower(from_address) = lower('0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11');
update transactions set to_address_fk = (select pk from addresses where address = lower('0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11'))
where lower(to_address) = lower('0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11');


update transactions set from_address_fk = (select pk from addresses where address = lower('0xd96ba527be241c2c31fd66cbb0a9430702906a2a'))
where lower(from_address) = lower('0xd96ba527be241c2c31fd66cbb0a9430702906a2a');
update transactions set to_address_fk = (select pk from addresses where address = lower('0xd96ba527be241c2c31fd66cbb0a9430702906a2a'))
where lower(to_address) = lower('0xd96ba527be241c2c31fd66cbb0a9430702906a2a');


update transactions set from_address_fk = (select pk from addresses where address = lower('0xfe61ad22a847c4df702731c7d5e803d283ea1376'))
where lower(from_address) = lower('0xfe61ad22a847c4df702731c7d5e803d283ea1376');
update transactions set to_address_fk = (select pk from addresses where address = lower('0xfe61ad22a847c4df702731c7d5e803d283ea1376'))
where lower(to_address) = lower('0xfe61ad22a847c4df702731c7d5e803d283ea1376');









psql ether_dev -c "update transactions set to_address = lower(to_address), from_address = lower(from_address) where pk >= 0 < 50000000; "

psql ether_dev -c "create index idx_transactions_to_address on transactions(lower(to_address));" &
psql ether_dev -c "create index idx_transactions_from_address on transactions(lower(from_address));" &

select * from addresses
where address in ('0x7d90b19c1022396b525c64ba70a293c3142979b7', '0x845f93f489b524f19864db6e0ab581c532b58d36', '0xc5883084a66ac9e08379256269c18345ccefe458', '0xdc0b72b3ea6b41eebb4666ceaca18e3fad6bfd55')



{
	"rootNode": {
		"receivedETH": 30789732430775842478800,
		"balanceETH": 0,
		"spentETH": 30789732010775842478800,
		"address": "0xaa923cd02364bb8a4c3d6f894178d2e12231655c"
	},
	"pathNodes": {
		"receivedETH": 214522678638883450918944,
		"balanceETH": 8999010332070216,
		"spentETH": 216520307743543298934068,
		"maxLevel": 0,
		"addresses": ["0x30d4bffec44037f5fe9d4336968c573cba9d018a", "0x3fbaa73a433daa0f6c43d1c732c3f97a86f3a427", "0xd96ba527be241c2c31fd66cbb0a9430702906a2a", "0x106018ce967e52e34bf27153197c7756235d972b", "0x96afcaa806d98713cf169ad95ed8e509ebf3f4a0", "0xb7e55d89850b67ab2ffb1a54e3a9f18b916f88b2", "0xd294ac18b524ff59ab7fffcbd459f11128220550", "0xd4e79226f1e5a7a28abb58f4704e53cd364e8d11", "0xfe61ad22a847c4df702731c7d5e803d283ea1376", "0x7d90b19c1022396b525c64ba70a293c3142979b7", "0x845f93f489b524f19864db6e0ab581c532b58d36", "0xc5883084a66ac9e08379256269c18345ccefe458", "0xdc0b72b3ea6b41eebb4666ceaca18e3fad6bfd55", "0x338fdf0d792f7708d97383eb476e9418b3c16ff1", "0x621e2e9f1cdc03add35ab930b074f9419f294045", "0x645565c47e2f1bba6d8941441b938724d3448c60", "0x90d78a49dfa03893d6f9caa4524b0bff6cda715f", "0xb7443e088232cd680ff20b7518eba2fc9e1b3c32", "0xd759ea4c6e8e2c77b7e04eeebc1fac32ed332dcc"]
	},
	"leafNodes": {
		"0x39d9f4640b98189540a9c0edcfa95c5e657706aa": 4840206992171000000000,
		"0x8d12a197cb00d4747a1fe03395095ce2a5cc6819": 501000000000000000000,
		"0xf775a9a0ad44807bc15936df0ee68902af1a0eee": 10918147071292000000000,
		"0xf056f435ba0cc4fcd2f1b17e3766549ffc404b94": 32733436752419000000000,
		"0xd8a83b72377476d0a66683cde20a8aad0b628713": 9999645100000000000,
		"0x5861b8446a2f6e19a067874c133f04c578928727": 49999884500000000000,
		"0xeec606a66edb6f497662ea31b5eb1610da87ab5f": 9999645100000000000
	},
	"level": 6,
	"traceStatus": "Terminated"
}