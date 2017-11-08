CREATE KEYSPACE customer_domain WITH REPLICATION = { 'class' : 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '1' } AND DURABLE_WRITES = true;

CREATE TYPE customer_domain.addressudt (
    adr_line_1 text,
    adr_line_2 text,
    adr_line_3 text,
    city text,
    state text,
    zip_code text,
    country text
);


CREATE TABLE customer_domain.customer_new (
    customer_id bigint,
    faid bigint,
    last_name text,
    account_status text,
    address frozen<customer_domain.addressudt>,
    approved_lines int,
    credit_class text,
    first_name text,
    plan text,
    primary_contact_number text,
    PRIMARY KEY (customer_id, faid, last_name)
) WITH read_repair_chance = 0.0
   AND dclocal_read_repair_chance = 0.1
   AND gc_grace_seconds = 864000
   AND bloom_filter_fp_chance = 0.01
   AND caching = { 'keys' : 'ALL', 'rows_per_partition' : 'NONE' }
   AND comment = ''
   AND compaction = { 'class' : 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold' : 32, 'min_threshold' : 4 }
   AND compression = { 'chunk_length_in_kb' : 64, 'class' : 'org.apache.cassandra.io.compress.LZ4Compressor' }
   AND default_time_to_live = 0
   AND speculative_retry = '99PERCENTILE'
   AND min_index_interval = 128
   AND max_index_interval = 2048
   AND crc_check_chance = 1.0;


   CREATE CUSTOM INDEX customer_idx2 ON customer_domain.customer_new ()
   USING 'com.stratio.cassandra.lucene.Index'
   WITH OPTIONS = {
      'refresh_seconds': '1',
      'schema': '{
         fields: {
            customer_id: {type: "integer"},
            last_name: {type: "string",case_sensitive: false},
    		 first_name: {type: "string"},
            primary_contact_number : {type: "text",analyzer: "english"}
         }
      }'
   };
