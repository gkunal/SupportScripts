for i in {000000000001..000000000300..1}
    do
       psql postgres -c "\COPY transactions_stage(hash,nonce,transaction_index,from_address,to_address,value,gas,gas_price,input,receipt_cumulative_gas_used,receipt_gas_used,receipt_contract_address,receipt_root,receipt_status,block_timestamp,block_number,block_hash,max_fee_per_gas,max_priority_fee_per_gas,transaction_type,receipt_effective_gas_price) FROM '/var/lib/postgresql/vjhala_export_zone/transactions$i' DELIMITER ',' CSV HEADER;
"
 done