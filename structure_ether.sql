\set ON_ERROR_STOP on

drop table if exists feedbacks;
create table feedbacks (
  pk serial primary key,
  type text,
  email text,
  content text,
  read boolean
);
create index idx_feedbacks_type on feedbacks(type);
create index idx_feedbacks_read on feedbacks(read);

drop table if exists tags;
create table tags (
  pk serial primary key,
  tag text NOT NULL
);
create unique index idx_tags_tag on tags(tag);

drop table if exists addresses;
drop table if exists transactions;
drop table if exists transactions_to;

CREATE TABLESPACE transactions_ssd LOCATION '/tmp/disks/postgres_ether_ssd/data';
		
create table transactions (
	hash1 uuid NOT NULL,
	hash2 uuid NOT NULL,
	from_address1 uuid NOT NULL,
	from_address2 int NOT NULL,
	to_address1 uuid,
	to_address2 int,
	value numeric(30,0),
	block_timestamp TIMESTAMP NOT NULL,
	block_number bigint NOT NULL
) tablespace transactions_ssd;

create index transactions_block_number on transactions(block_number);
create index transactions_from_address on transactions(from_address1,from_address2);
create index transactions_to_address on transactions(to_address1,to_address2);
create unique index transactions_hash1 on transactions(hash1);

create table addresses (
	address1 uuid NOT NULL,
	address2 int NOT NULL,
	flags INTEGER,
	tags text
) tablespace transactions_ssd;

create table users (
    pk serial primary key,
    password text NOT NULL,
    email varchar(128) NOT NULL,
    is_active boolean default true,
	expiry_date DATE
) tablespace transactions_ssd;
create unique index users_email on users(email);
create unique index addresses_address on addresses(address1,address2);

create table eth_rates (
conversion_rate real not NULL, 
converted_at timestamp not NULL, 
type smallint,
converted_to char(3) not null,
block_number BIGINT
) tablespace transactions_ssd;

create index eth_rates_converted_at_to on eth_rates(converted_at, converted_to) tablespace transactions_ssd;
create index eth_rates_converted_type on eth_rates(type) tablespace transactions_ssd;
create unique index eth_rates_block_number_converted_to on eth_rates(block_number,converted_to) tablespace transactions_ssd;

create table actual_usage ( 
  pk serial primary key,
  user_id int NOT NULL, 
  address1 uuid NOT NULL,
  address2 int NOT NULL,
  updated_date DATE NOT NULL,
  pro_score_request_count int NOT NULL,
  request_month TEXT NOT NULL
) tablespace transactions_ssd;
create unique index actual_usage_userid_address1_address2_request_month on actual_usage(user_id, request_month, address1,address2) tablespace transactions_ssd;

create table licenses (
  pk serial primary key,
  user_id int NOT NULL,
  license_start_date DATE NOT NULL,
  license_end_date DATE NOT NULL,
  address_monthly_quota int NOT NULL
) tablespace transactions_ssd;

create unique index license_user_id on licenses(user_id) tablespace transactions_ssd;


INSERT INTO licenses (user_id, license_start_date, license_end_date, address_monthly_quota) VALUES (55,"2022-04-04","2022-04-30",5);

create table system_configurations (
 feedback_to_addresses TEXT NOT NULL
) tablespace transactions_ssd;
create unique index system_configurations_feedback_to_address on system_configurations(feedback_to_addresses) tablespace transactions_ssd;

INSERT INTO system_configurations (feedback_to_addresses) VALUES ('wl5404095@gmail.com');
INSERT INTO system_configurations (feedback_to_addresses) VALUES ('vishal.jhala@gmail.com');
INSERT INTO system_configurations (feedback_to_addresses) VALUES ('jay.khimani@gmail.com');


create index feedbacks_created_at on feedbacks(created_at) tablespace transactions_ssd;