#! /bin/bash


psql_host=localhost
port=5432 
db_name=host_agent
username=postgres
password=password


get_hostname(){
hostname=$(hostname -f)
}

get_cpu_no(){
cpu_no=$(lscpu | egrep "^CPU\(s\):" | awk '{print $2}' |xargs)
}

get_cpu_arch(){

cpu_arc=$(lscpu | egrep "^Architecture:" | awk '{print $2}' |xargs)

}
get_cpu_model(){
cpu_model=$(lscpu | egrep "^Model name\:" | awk '{print  $3" " $4 " " $5 " " $6" " $7}'|xargs) 


}


get_cpu_mhz(){
cpu_mhz=$(lscpu |egrep "^CPU\ MHz\:" | awk '{print $3}'|xargs) 

}


get_l2_cache(){
l2_cache=$(lscpu | egrep "^L2 cache\:" | awk '{print  substr($3,1,3)}' |xargs)
}


get_total_mem(){
total_mem=$(lscpu | egrep "^L3 cache\:" | awk '{print  substr($3,1,5)}' |xargs)
}


get_time(){
time=$(date +%x_%r)
}


get_hostname
get_cpu_no
get_cpu_model
get_cpu_mhz
get_l2_cache
get_cpu_arch

get_total_mem
 get_time
insert_stmt=$(cat <<-END

INSERT INTO  host_info ( hostname,cpu_number,cpu_architecture,
cpu_model,cpu_mhz,l2_cache,timestamp,total_mem) VALUES('${hostname}','${cpu_no}', '${cpu_arc}' , '${cpu_model}','${cpu_mhz}', '${l2_cache}', '${time}','${total_mem}');
END
)
 echo $insert_stmt

export PGPASSWORD=$password
psql -h $psql_host -p $port -U $username -d $db_name -c "$insert_stmt"


psql -h localhost -U postgres host_agent -c"select id from host_info where hostname ='${hostname}'" |tail -3 |head -1 |xargs > host_info_id








