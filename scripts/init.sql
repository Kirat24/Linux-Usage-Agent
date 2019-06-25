CREATE DATABASE host_agent;


CREATE TABLE  PUBLIC.host_usage(timestamp TIMESTAMP NOT NULL,host_id SERIAL NOT NULL, free_mem INT4 NOT NULL, cpu_idel INT2 NOT NULL, cpu_kernel INT2 NOT NULL, disk_io INT4  NOT NULL, disk_avail INT4  NOT NULL, CONSTRAINT host_usage_host_info_fk FOREIGN KEY(host_id) REFERENCES host_info(id));


create table PUBLIC.host_info(id SERIAL NOT NULL, hostname VARCHAR NOT NULL, cpu_number INT2 NOT NULL, cpu_architecture VARCHAR NOT NULL, cpu_model VARCHAR NOT NULL, cpu_mhz FLOAT8 NOT NULL, l2_cache INT4 NOT NULL, "timestamp" TIMESTAMP NULL, total_mem INT4 NULL, CONSTRAINT host_info_pk PRIMARY KEY(id), CONSTRAINT host_info_un UNIQUE(hostname));


First SQL Query:-
select cpu_number, id AS host_id, total_mem from host_info group BY cpu_number, id order BY total_mem DESC;



second SQL Query:-
select i.hostname, u.host_id, i.total_mem, AVG((i.total_mem-u.free_mem)*100) AS used_mem from host_info AS  i JOIN host_usage AS u ON i.id=u.host_id group BY 'epoch'::timestamptz + '300 seconds':: INTERVAL *( round(EXTRACT(epoch from u.timestamp)::int4 /300)*300), hostname,host_id,total_mem;

