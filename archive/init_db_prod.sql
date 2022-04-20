-- STAGE 1 - Setup Database before starting
Install from here - https://www.postgresql.org/download/linux/debian/
sudo systemctl stop postgresql
sudo systemctl start postgresql
export PATH=$PATH:/usr/lib/postgresql/14/bin

vim /etc/postgresql/14/main/postgresql.conf
  change data_directory - /mnt/disks/postgres_ether/data/
SET maintenance_work_mem TO '4 GB';
SET max_wal_size TO '10 GB';
SET max_parallel_maintenance_workers TO 5
set sequence scan to off.
change listen_addresses = '*'
modified HBA using https://www.bigbinary.com/blog/configure-postgresql-to-allow-remote-connection


sudo su - postgres
/usr/lib/postgresql/14/bin/initdb -D /mnt/disks/postgres_ether/data
sudo systemctl start postgresql
sudo -u postgres psql postgres



-- create database with password
sudo -u postgres createuser ether
sudo -u ether createdb ether_prod
alter user ether with encrypted password ether;


-- STAGE 2 - Create temporary table and import
create table feedbacks (
  pk serial primary key,
  type text,
  email text,
  content text,
  read boolean
);
create index idx_feedbacks_type on feedbacks(type);
create index idx_feedbacks_read on feedbacks(read);

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

Provide GCP access to bucket
https://github.com/GoogleCloudPlatform/gcsfuse/
https://github.com/GoogleCloudPlatform/gcsfuse/blob/master/docs/installing.md
sudo su - postgres
gcsfuse vjhala_export_zone ./vjhala_export_zone
gcsfuse vjhala_export_zone /var/lib/postgresql/vjhala_export_zone

pg_dump -F t -bvxOW -U postgres -d postgres -f /var/lib/postgresql/vjhala_export_zone/crypto-trace-ether-$(date +%Y%m%d).tar
pg_dump --host localhost --port 5432 --username postgres --format plain --verbose --file "<abstract_file_path>" --table public.tablename dbnam
pg_dump -U postgres --format=custom --no-owner --no-acl postgres > /mnt/disks/postgres_ether/crypto-trace_database-12-31-2021.dmp

sudo gsutil -m cp -z \
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
sudo gsutil -m cp -z \
  "gs://vjhala_export_zone/balances000000000000" \
  .

psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000000' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000001' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000002' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000003' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000004' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000005' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000006' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000007' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000008' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000009' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000010' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000011' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000012' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000013' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000014' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000015' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000016' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000017' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000018' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000019' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000020' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000021' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000022' DELIMITER ',' CSV HEADER;" &
psql postgres -c "\COPY addresses(address, eth_balance) FROM '/mnt/disks/postgres_ether/balances/balances000000000023' DELIMITER ',' CSV HEADER;" &



psql postgres -c "update addresses set address = lower(address) where pk >= 0 and pk < 10000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 10000000 and pk < 20000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 20000000 and pk < 30000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 30000000 and pk < 40000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 40000000 and pk < 50000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 50000000 and pk < 60000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 60000000 and pk < 70000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 70000000 and pk < 80000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 80000000 and pk < 90000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 90000000 and pk < 100000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 100000000 and pk < 110000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 110000000 and pk < 120000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 120000000 and pk < 130000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 130000000 and pk < 140000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 140000000 and pk < 150000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 150000000 and pk < 160000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 160000000 and pk < 170000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 170000000 and pk < 180000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 180000000 and pk < 190000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 190000000 and pk < 200000000; " &
psql postgres -c "update addresses set address = lower(address) where pk >= 200000000 and pk < 210000000; " &

psql postgres -c "create unique index idx_addresses_address on addresses(address);" &
psql postgres -c "create index idx_transactions_is_contract_address on addresses(is_contract_address);" &
psql postgres -c "create index idx_transactions_tags_fk on addresses(tag_fk);" &

create table transactions_stage (
  nonce bigint,
  hash text,
  transaction_index INTEGER,
  from_address TEXT,
  to_address TEXT,
  value numeric(30,0),
  gas numeric(30,0),
  receipt_contract_address TEXT,
  receipt_root TEXT,
  receipt_status smallint,
  block_timestamp TIMESTAMP,
  block_number bigint,
  block_hash TEXT,
  transaction_type smallint,
  input TEXT,
  gas_price numeric(30,0),
  receipt_cumulative_gas_used numeric(30,0),
  receipt_gas_used numeric(30,0),
  receipt_effective_gas_price numeric(30,0),
  max_fee_per_gas numeric(30,0),
  max_priority_fee_per_gas numeric(30,0)
);

sudo gsutil -m cp -z \
  "gs://vjhala_export_zone/transactions000000000000" \
  .

for i in $( ls tran*); do mv $i $i.gz; done
for i in $( ls transactions000000000*.gz); do gzip -d $i; done &
for i in $( ls transactions000000001*.gz); do gzip -d $i; done &
for i in $( ls transactions000000002*.gz); do gzip -d $i; done &


psql postgres -c "\COPY transactions_stage(hash,nonce,transaction_index,from_address,to_address,value,gas,gas_price,input,receipt_cumulative_gas_used,receipt_gas_used,receipt_contract_address,receipt_root,receipt_status,block_timestamp,block_number,block_hash,max_fee_per_gas,max_priority_fee_per_gas,transaction_type,receipt_effective_gas_price) FROM '/var/lib/postgresql/vjhala_export_zone/transactions000000000000' DELIMITER ',' CSV HEADER;"
psql postgres -c "\COPY transactions_stage(hash,nonce,transaction_index,from_address,to_address,value,gas,gas_price,input,receipt_cumulative_gas_used,receipt_gas_used,receipt_contract_address,receipt_root,receipt_status,block_timestamp,block_number,block_hash,max_fee_per_gas,max_priority_fee_per_gas,transaction_type,receipt_effective_gas_price) FROM '/var/lib/postgresql/vjhala_export_zone/transactions000000000001' DELIMITER ',' CSV HEADER;" &

psql postgres -c "\COPY transactions_stage(hash,nonce,transaction_index,from_address,to_address,value,gas,gas_price,input,receipt_cumulative_gas_used,receipt_gas_used,receipt_contract_address,receipt_root,receipt_status,block_timestamp,block_number,block_hash,max_fee_per_gas,max_priority_fee_per_gas,transaction_type,receipt_effective_gas_price) FROM '/var/lib/postgresql/vjhala_export_zone/transactions000000000001' DELIMITER ',' CSV HEADER;"

psql postgres -c "create index idx_transactions_stage_block_number on transactions_stage(block_number);" &

create table transactions (
  pk serial primary key,
  nonce bigint NOT NULL,
  hash text NOT NULL,
  transaction_index INTEGER NOT NULL,
  from_address TEXT NOT NULL,
  to_address TEXT,
  value numeric(30,0),
  gas numeric(30,0),
  receipt_contract_address TEXT,
  receipt_root TEXT,
  receipt_status smallint,
  block_timestamp TIMESTAMP NOT NULL,
  block_number bigint NOT NULL,
  block_hash TEXT NOT NULL,
  transaction_type smallint,
  from_address_fk INTEGER,
  to_address_fk INTEGER
);
create or replace procedure import_transactions(start_pk integer, end_pk integer) as
$$
declare
begin
  FOR i in start_pk..end_pk-1 loop
      insert into transactions
      (from_address, to_address, from_address_fk, to_address_fk, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
      select lower(from_address), lower(to_address), adf.pk, adt.pk, lower(hash), nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
      from transactions_stage t
      join addresses adf on adf.address = t.from_address
      join addresses adt on adt.address = t.to_address
      where block_number = i;

      commit;
      if mod(i,10000) = 0 then
        raise notice 'pk %', i;
      end if;

    END LOOP;
end;
$$ language plpgsql;

create or replace procedure import_transactions(start_pk integer, end_pk integer) as
$$
declare
begin
  FOR i in start_pk..end_pk-1 loop
      insert into transactions
      (from_address, to_address, hash, nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type)
      select lower(from_address), lower(to_address), lower(hash), nonce, transaction_index, value, gas, receipt_contract_address, receipt_root, receipt_status, block_timestamp, block_number, block_hash, transaction_type
      from transactions_stage t
      where block_number = i;

      commit;
      if mod(i,10000) = 0 then
        raise notice 'pk %', i;
      end if;

    END LOOP;
end;
$$ language plpgsql;


nohup psql postgres -c "call import_transactions(0,1000000);" &
nohup psql postgres -c "call import_transactions(1000000,2000000);" &
nohup psql postgres -c "call import_transactions(2000000,3000000);" &
nohup psql postgres -c "call import_transactions(3000000,4000000);" &
nohup psql postgres -c "call import_transactions(4000000,5000000);" &
nohup psql postgres -c "call import_transactions(5000000,6000000);" &
nohup psql postgres -c "call import_transactions(6000000,7000000);" &
nohup psql postgres -c "call import_transactions(7000000,8000000);" &
nohup psql postgres -c "call import_transactions(8000000,9000000);" &
nohup psql postgres -c "call import_transactions(9000000,10000000);" &
nohup psql postgres -c "call import_transactions(10000000,11000000);" &
nohup psql postgres -c "call import_transactions(11000000,12000000);" &
nohup psql postgres -c "call import_transactions(12000000,13567323);" &

nohup psql postgres -c "create unique index idx_transactions_hash on transactions(hash);" &
nohup psql postgres -c "create index idx_transactions_to_address on transactions(to_address);" &
nohup psql postgres -c "create index idx_transactions_from_address on transactions(from_address);" &

create or replace procedure update_addresses_p(start_pk integer, end_pk integer) as
$$
declare
  add_row addresses%rowtype;
begin
  FOR add_row IN
      SELECT * FROM addresses where pk >= $1 and pk < $2 order by pk
    LOOP
        update addresses
          set received_count = r_count,
          eth_received = e_received
        from(
          select count(*) r_count, sum(value) e_received
          from transactions
          where to_address = add_row.address
        ) as rcv
        where pk = add_row.pk;

        update addresses
          set sent_count = s_count,
          eth_sent = e_sent
        from(
          select count(*) s_count, sum(value) e_sent
          from transactions
          where from_address = add_row.address
        ) as sen
        where pk = add_row.pk;

        if mod(add_row.pk,1000) = 0 then
          raise notice 'pk %', add_row.pk;
        end if;

    END LOOP;
end;
$$ language plpgsql;

nohup psql postgres -c "call update_addresses_p(0,10000000);" &
nohup psql postgres -c "call update_addresses_p(10000000,20000000);" &
nohup psql postgres -c "call update_addresses_p(20000000,30000000);" &
nohup psql postgres -c "call update_addresses_p(30000000,40000000);" &
nohup psql postgres -c "call update_addresses_p(40000000,50000000);" &

nohup psql postgres -c "call update_addresses_p(50000000,60000000);" &
nohup psql postgres -c "call update_addresses_p(60000000,70000000);" &
nohup psql postgres -c "call update_addresses_p(70000000,80000000);" &
nohup psql postgres -c "call update_addresses_p(80000000,90000000);" &
nohup psql postgres -c "call update_addresses_p(90000000,100000000);" &
nohup psql postgres -c "call update_addresses_p(100000000,110000000);" &
nohup psql postgres -c "call update_addresses_p(110000000,120000000);" &
nohup psql postgres -c "call update_addresses_p(120000000,130000000);" &
nohup psql postgres -c "call update_addresses_p(130000000,140000000);" &
nohup psql postgres -c "call update_addresses_p(140000000,150000000);" &
nohup psql postgres -c "call update_addresses_p(150000000,160000000);" &
nohup psql postgres -c "call update_addresses_p(160000000,170000000);" &
nohup psql postgres -c "call update_addresses_p(170000000,180000000);" &
nohup psql postgres -c "call update_addresses_p(180000000,190000000);" &
nohup psql postgres -c "call update_addresses_p(190000000,200000000);" &

        update addresses
          set received_count = r_count,
          eth_received = e_received
        from(
          select count(*) r_count, sum(value) e_received
          from transactions
          where to_address = '0x8435725cb4d79a8f67e1c4c99a017c7679679170'
        ) as rcv
        where pk = 6;




Update Addressses with contract flag
-------------------------------------

create table contracts_stage (
  address text NOT NULL
  );
after importing.

ALTER TABLE contracts_stage ADD COLUMN id SERIAL PRIMARY KEY;
create index idx_contracts_stage_address on contracts_stage(lower(address));



create or replace procedure update_addresses_contract_flag(start_pk integer, end_pk integer) as
$$
declare
  add_row contracts_stage%rowtype;
begin
  for i in start_pk..end_pk by 1000 loop
    UPDATE addresses AS a
    SET is_contract_address = 1
    FROM contracts_stage AS cs
    WHERE a.address = lower(cs.address)
    and cs.id >= start_pk and cs.id < start_pk+1000;

      raise notice 'pk %', i;
    end loop;
end;
$$ language plpgsql;


UPDATE addresses AS a
SET is_contract_address = 1
FROM contracts_stage AS cs
WHERE a.address = lower(cs.address)
and cs.pk < 100000
;

NOTICE:  pk 11858000
NOTICE:  pk 46832900
NOTICE:  pk 41833500
NOTICE:  pk 31852300
NOTICE:  pk 46833000
NOTICE:  pk 1855000
NOTICE:  pk 11858100
NOTICE:  pk 16846500
NOTICE:  pk 21836800
NOTICE:  pk 26849700
NOTICE:  pk 41833600
NOTICE:  pk 36838400
NOTICE:  pk 6833900
NOTICE:  pk 26849800
NOTICE:  pk 6834000
NOTICE:  pk 36838500
NOTICE:  pk 41833700
NOTICE:  pk 11858200
NOTICE:  pk 46833100
NOTICE:  pk 31852400
NOTICE:  pk 21836900
NOTICE:  pk 1855100
NOTICE:  pk 16846600
NOTICE:  pk 6834100
NOTICE:  pk 41833800
NOTICE:  pk 21837000
NOTICE:  pk 16846700
NOTICE:  pk 26849900
NOTICE:  pk 46833200
NOTICE:  pk 11858300
NOTICE:  pk 31852500
NOTICE:  pk 1855200
NOTICE:  pk 36838600
nohup psql postgres -c "call update_addresses_contract_flag(80000,5000000);" &
nohup psql postgres -c "call update_addresses_contract_flag(5000000,10000000);" &
nohup psql postgres -c "call update_addresses_contract_flag(10000000,15000000);" &
nohup psql postgres -c "call update_addresses_contract_flag(15000000,20000000);" &
nohup psql postgres -c "call update_addresses_contract_flag(21182900,25000000);" &
nohup psql postgres -c "call update_addresses_contract_flag(25000000,30000000);" &
nohup psql postgres -c "call update_addresses_contract_flag(31192100,35000000);" &
nohup psql postgres -c "call update_addresses_contract_flag(35000000,40000000);" &
nohup psql postgres -c "call update_addresses_contract_flag(40000000,45000000);" &
nohup psql postgres -c "call update_addresses_contract_flag(45000000,50000000);" &
-------------------------------------------
insert into address_tags(address_fk,tag_fk) values(select pk from addresses where lower(''), select pk from tags were tag=''))
insert  into tags (tag) values
('Wrapped Ether'),
('Binance 7'),
('Compound: cETH Token'),
('Gemini 3'),
('FTX Exchange 2'),
('Bitfinex: MultiSig 3'),
('Liquity: Active Pool'),
('Huobi 37'),
('Lido: Curve Liquidity Farming Pool Contract'),
('HECO Chain: Bridge'),
('Binance 14'),
('Polygon (Matic): Ether Bridge'),
('EthDev'),
('Arbitrum: Bridge'),
('Vb 3'),
('Polkadot: MultiSig'),
('Gemini: Contract 1'),
('OTC: 0x054...58e'),
('OKEx 3'),
('Bittrex 3'),
('Binance 8'),
('Golem: MultiSig'),
('Blockfolio'),
('BitDAO: Treasury'),
('Tornado.Cash: 100 ETH'),
('FTX Exchange'),
('Iconomi: MultiSig 1'),
('Fund: 0x115...3cD'),
('Huobi 34'),
('Golem: Foundation'),
('Coinone 2'),
('KuCoin 6'),
('WithdrawDAO'),
('Kraken 4'),
('Crypto.com'),
('OMG: Boba Gateway'),
('Multisig Exploit Hacker'),
('ExtraBalDaoWithdraw'),
('Sollet: Solana Bridge'),
('Gatecoin Hacker 2'),
('Gatecoin Hacker 1'),
('Bancor: Converter 571'),
('Gemini'),
('iEXEC: MultiSig'),
('Status: Research & Development MultiSig'),
('Bitstamp 3'),
('OKEx 4'),
('Huobi 36'),
('Gatecoin Hacker 4'),
('Binance 17'),
('Binance 15'),
('Aragon: MultiSig'),
('Bitfinex 2'),
('Orbit Chain: Bridge'),
('Optimism: Gateway'),
('Gnosis: GnosisDAO Safe'),
('Aave: Lending Pool Core V1'),
('MetaMask: DS Proxy'),
('Hegic: Development Fund'),
('Lido: Aragon Agent'),
('Loopring: Exchange v2 Deposit'),
('Plus Token Ponzi 2'),
('Kraken'),
('IDEX'),
('Binance 20'),
('EtherDelta 2'),
('Bitfinex 3'),
('Harmony: ETH Bridge'),
('Binance US 2'),
('Musiconomi: MultiSig'),
('Digix: DGD ETH Refund'),
('Binance 16'),
('Nouns DAO: Treasury'),
('Tornado.Cash: 10 ETH'),
('Binance US 3'),
('Truebit Protocol: Purchase'),
('Coinhako: Warm Wallet'),
('Binance 18'),
('CoinDash: Token Sale'),
('Black Hole: 0x000...dEaD'),
('Sparkster: Wallet'),
('Bitstamp 2'),
('DXdao'),
('Yobit.net'),
('SingularDTV: Wallet'),
('Gate.io: Contract'),
('OpenSea: Wallet'),
('Black Hole: 0x000…000'),
('Whiteheart: Deployer'),
('Juicebox: Terminal V1'),
('Crypto.com 2'),
('Kyber: MultiSig'),
('Metronome: Autonomous Converter'),
('KuCoin 5'),
('CryptoPunks: Ͼ Token'),
('zkSync'),
('Alpha Homora V2 Exploiter'),
('Anyswap: Moonriver Bridge'),
('Poloniex 4'),
('ZKSwap: V2 Bridge'),
('PXN: Cold Wallet'),
('Kraken: Eth2 Depositor'),
('Hiveon Pool'),
('Coinone'),
('Nexus Mutual: Community Fund'),
('Bloom: MultiSig'),
('Etheroll: MultiSig 1'),
('Miner: 0x2a2...050'),
('Impact Theory Founders Key: Deployer'),
('Savedroid: Wallet'),
('Bittrex'),
('imbrex: Wallet'),
('Santiment: Wallet 2'),
('Coinbase 6'),
('Foundation: Treasury'),
('Immutable X: Bridge'),
('Secret Network: Bridge'),
('Wintermute 1'),
('Coinbase 3'),
('Compound: Timelock'),
('Sorare: L2 Bridge'),
('Coinbase 4'),
('YouHodler'),
('Coinbase 5'),
('ENS: ETH Registrar Controller'),
('BlockFi 3'),
('KuCoin 4'),
('Babel Pool'),
('Nexo: WBTC Merchant Deposit Address'),
('Nanopool'),
('BiFi Finance: ETH Wallet'),
('Flexpool.io'),
('Bitstamp 5'),
('2Miners: PPLNS'),
('Cream Finance Flash Loan Exploiter 3'),
('CoinList 1'),
('Cream Finance Flash Loan Exploiter 2'),
('KeeperDAO: Treasury'),
('Tornado.Cash: 1 ETH'),
('WETH: Old Contract'),
('Synthetix: Treasury Council'),
('Metronome: Proceeds'),
('Rarible: Treasury'),
('Dopex: Multisig'),
('PowH3D'),
('Synthetix: Collateral Eth'),
('Coinex'),
('Aeternity: Wallet'),
('Blox Staking: Eth2 Depositor'),
('MiningPoolHub'),
('Celsius Network: Wallet 5'),
('Gitcoin: MultiSig'),
('GU: Capped Vault'),
('Etheroll: MultiSig 2'),
('Miner: 0x2Da...E5e'),
('Bee Token: MultiSig'),
('DXDao: DXD Token'),
('Guild of Guardians: Pre Sale'),
('Fake: Metadium Presale'),
('Peatio'),
('Miner: 0xab3...83a'),
('SuperRare: Treasury'),
('Binance Pool'),
('SwissBorg 2'),
('WePiggy: pETH Token'),
('DeversiFi 2'),
('AntPool 2'),
('LAToken 2'),
('HitBTC 3'),
('LinkerCoin: Wallet'),
('AscendEX 3'),
('LUKSO: MultiSig'),
('Metamask: Fees'),
('Storj: MultiSig 1'),
('Ethermine'),
('Miner: 0x070...287'),
('Remitano 2'),
('BTC.com Pool'),
('Alpha Finance Lab: ibETH Token'),
('SwissBorg 1'),
('Bitlo Cold Wallet 1'),
('Aztec: Private Rollup Bridge'),
('Miner: 0x8f0...be7'),
('Inverse Finance: anETH'),
('bZx PrivKey Exploiter 5'),
('CEX.IO'),
('Fake_Phishing4287'),
('Fake_Phishing4582'),
('BitGo: MultiSig'),
('DDEX: Margin'),
('Gopax: WBTC Merchant Deposit Address'),
('F2Pool Old'),
('Somnium Space Cubes: Deployer'),
('Fomo3D: Long'),
('Alkemi Network: WETH Token'),
('bZx Exploiter 1'),
('Fake_Phishing2753'),
('Binance 9'),
('Tidex 1'),
('1xBet'),
('OKEx'),
('hongcoin'),
('CryptoDragons: Deployer'),
('Numerai Founder: Rc'),
('Pranksy'),
('MEV Bot: 0x000...f56'),
('BlockFi 4'),
('BitDAO: ByBit Contribution'),
('SingularX'),
('2gether: Vault'),
('CoinList 2'),
('NEKO Official: NEKO Token'),
('KuCoin Pool'),
('Strike ETH: sETH Token'),
('Uphold.com'),
('stakefish: Eth2 Depositor'),
('SuperRare: Marketplace'),
('Switcheo Exchange V2'),
('Ribbon Finance: Multisig'),
('Miner: 0x01C...8cf'),
('Augur: Delegator'),
('BigONE'),
('EtherFlip'),
('OTCBTC'),
('AscendEX 2'),
('EverRise: Deployer 1'),
('TheDaoCurator'),
('Hotbit 3'),
('MCDEX: ETH Perpetual'),
('Token.Store'),
('Fox Game: FOX Token'),
('India Covid-Crypto Relief Fund'),
('GPUMINE Pool 1'),
('Augur: Token Sale')
;
alter table addresses
drop column tag_fk;

alter table addresses
add column tag_fks INTEGER[];

update addresses set tag_fks = array_append(tag_fks, tag_fk) from (select pk tag_fk from tags where tag ='')) as rcv where address ='';

---------------------------------------
demo isntance commands
-----------------------------------
gcloud compute instances create demo-instance \
--image-family debian-9 \
--image-project debian-cloud \
--machine-type g1-small \
--scopes "userinfo-email,cloud-platform" \
--metadata-from-file startup-script=instance-startup.sh \
--metadata BUCKET=vjhala_export_zone \
--zone us-west1-b \
--tags app-server


gcloud compute instances get-serial-port-output demo-group-841x \
    --zone us-west1-b

gcloud compute instance-templates create demo-template \
    --image-family debian-9 \
    --image-project debian-cloud \
    --machine-type g1-small \
    --scopes "userinfo-email,cloud-platform" \
    --metadata-from-file startup-script=instance-startup.sh \
    --metadata BUCKET=vjhala_export_zone \
    --tags app-server

gcloud compute instance-groups managed create demo-group \
    --base-instance-name demo-group \
    --size 1 \
    --template demo-template \
    --zone us-west1-b


 load balancer

 gcloud compute http-health-checks create demo-health-check \
     --request-path /hello \
     --port 8080

gcloud compute instance-groups managed set-named-ports demo-group \
    --named-ports http:8080 \
    --zone us-west1-b

gcloud compute backend-services create demo-service \
    --http-health-checks demo-health-check \
    --global

gcloud compute backend-services add-backend demo-service \
    --instance-group demo-group \
    --global \
    --instance-group-zone us-west1-b

gcloud compute url-maps create demo-service-map \
    --default-service demo-service

gcloud compute target-http-proxies create demo-service-proxy \
    --url-map demo-service-map

gcloud compute forwarding-rules create demo-http-rule \
    --target-http-proxy demo-service-proxy \
    --ports 80 \
    --global

curl \
--header 'Content-Type:application/json' \
--header 'abraka:dabra' \
'http://localhost:8080/cryptotrace/f9862ca6-86c8-4fef-8cfc-97e94239a6bd/feedback'

curl \
--header 'Content-Type:application/json' \
'http://localhost:8080/cryptotrace/rualv'

    ---------------

    FROM openjdk:11
    RUN addgroup  spring && adduser spring --ingroup spring
    USER spring:spring
    ARG JAR_FILE=target/*.jar
    COPY ${JAR_FILE} app.jar
    ENTRYPOINT ["java","-jar","/app.jar"]



    docker build -t demo-app .
    docker buildx build --platform linux/amd64 -t myapp .
    docker run -p 8080:8080 demo-app
    docker tag demo-app gcr.io/cryptic-acrobat-330120/demo-app
    docker push gcr.io/cryptic-acrobat-330120/demo-app


create or replace procedure update_txn_fx(start_pk integer, end_pk integer) as
$$
declare
  add_row addresses%rowtype;
begin
  FOR add_row IN
      SELECT * FROM addresses where pk >= $1 and pk < $2 order by pk
    LOOP
        update addresses
          set received_count = r_count,
          eth_received = e_received
        from(
          select count(*) r_count, sum(value) e_received
          from transactions
          where to_address = add_row.address
        ) as rcv
        where pk = add_row.pk;

        update addresses
          set sent_count = s_count,
          eth_sent = e_sent
        from(
          select count(*) s_count, sum(value) e_sent
          from transactions
          where from_address = add_row.address
        ) as sen
        where pk = add_row.pk;

        if mod(add_row.pk,1000) = 0 then
          raise notice 'pk %', add_row.pk;
        end if;

    END LOOP;
end;
$$ language plpgsql;

CREATE TABLE addresses_partitioned (
  pk serial,
  address text NOT NULL,
  eth_balance numeric(30,0) NOT NULL default 0,
  received_count INTEGER,
  sent_count INTEGER,
  eth_received numeric(30,0),
  eth_sent numeric(30,0),
  oldest_block INTEGER,
  newest_block INTEGER,
  is_contract_address smallint,
  tag_fks INTEGER[]
) PARTITION BY hash (address);

CREATE TABLE addresses_partition_1 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 0);
CREATE TABLE addresses_partition_2 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 1);
CREATE TABLE addresses_partition_3 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 2);
CREATE TABLE addresses_partition_4 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 3);
CREATE TABLE addresses_partition_5 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 4);
CREATE TABLE addresses_partition_6 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 5);
CREATE TABLE addresses_partition_7 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 6);
CREATE TABLE addresses_partition_8 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 7);
CREATE TABLE addresses_partition_9 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 8);
CREATE TABLE addresses_partition_10 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 9);
CREATE TABLE addresses_partition_11 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 10);
CREATE TABLE addresses_partition_12 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 11);
CREATE TABLE addresses_partition_13 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 12);
CREATE TABLE addresses_partition_14 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 13);
CREATE TABLE addresses_partition_15 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 14);
CREATE TABLE addresses_partition_16 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 15);
CREATE TABLE addresses_partition_17 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 16);
CREATE TABLE addresses_partition_18 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 17);
CREATE TABLE addresses_partition_19 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 18);
CREATE TABLE addresses_partition_20 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 19);
CREATE TABLE addresses_partition_21 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 20);
CREATE TABLE addresses_partition_22 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 21);
CREATE TABLE addresses_partition_23 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 22);
CREATE TABLE addresses_partition_24 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 23);
CREATE TABLE addresses_partition_25 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 24);
CREATE TABLE addresses_partition_26 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 25);
CREATE TABLE addresses_partition_27 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 26);
CREATE TABLE addresses_partition_28 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 27);
CREATE TABLE addresses_partition_29 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 28);
CREATE TABLE addresses_partition_30 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 29);
CREATE TABLE addresses_partition_31 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 30);
CREATE TABLE addresses_partition_32 PARTITION OF addresses_partitioned FOR VALUES WITH (MODULUS 32, REMAINDER 31);

ALTER TABLE addresses_partitioned SET UNLOGGED;

nohup psql postgres -c "INSERT INTO addresses_partitioned(address, eth_balance, received_count, sent_count, eth_received, eth_sent, is_contract_address, tag_fks) SELECT address, eth_balance, received_count, sent_count, eth_received, eth_sent, is_contract_address, tag_fks from addresses;" &

ALTER TABLE addresses_partitioned SET LOGGED;

nohup psql postgres -c "create unique index idx_addresses_partition_1_address on addresses_partition_1(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_2_address on addresses_partition_2(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_3_address on addresses_partition_3(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_4_address on addresses_partition_4(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_5_address on addresses_partition_5(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_6_address on addresses_partition_6(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_7_address on addresses_partition_7(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_8_address on addresses_partition_8(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_9_address on addresses_partition_9(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_10_address on addresses_partition_10(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_11_address on addresses_partition_11(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_12_address on addresses_partition_12(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_13_address on addresses_partition_13(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_14_address on addresses_partition_14(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_15_address on addresses_partition_15(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_16_address on addresses_partition_16(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_17_address on addresses_partition_17(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_18_address on addresses_partition_18(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_19_address on addresses_partition_19(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_20_address on addresses_partition_20(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_21_address on addresses_partition_21(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_22_address on addresses_partition_22(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_23_address on addresses_partition_23(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_24_address on addresses_partition_24(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_25_address on addresses_partition_25(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_26_address on addresses_partition_26(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_27_address on addresses_partition_27(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_28_address on addresses_partition_28(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_29_address on addresses_partition_29(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_30_address on addresses_partition_30(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_31_address on addresses_partition_31(address);" &
nohup psql postgres -c "create unique index idx_addresses_partition_32_address on addresses_partition_32(address);" &
nohup psql postgres -c "create unique index idx_addresses_partitioned_address on addresses_partitioned(address);" &
nohup psql postgres -c "create index idx_addresses_partitioned_is_contract_address on addresses_partitioned(is_contract_address);" &


create or replace procedure del_transaction_subs_add() as
$$
declare
  del_tran_row transactions%rowtype;
  i int;
begin
  i = 0;
  FOR del_tran_row IN
      SELECT * FROM transactions where block_number >13559702
  LOOP
      update addresses
        set sent_count = sent_count -1,
        eth_sent = eth_sent - del_tran_row.value
        where address = del_tran_row.from_address;

      if del_tran_row.to_address is not null and length(del_tran_row.to_address) > 0  then
        update addresses
          set received_count = received_count -1,
          eth_received = eth_received - del_tran_row.value
          where address = del_tran_row.to_address;
      end if;

      if mod(i,1000) = 0 then
        commit;
        raise notice 'i %', i;
      end if;
      i = i + 1;
  END LOOP;
  delete FROM transactions where block_number > 13559702;
end;
$$ language plpgsql;

nohup psql postgres -c "call del_transaction_subs_add();" &
