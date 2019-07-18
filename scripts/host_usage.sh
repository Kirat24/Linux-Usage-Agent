#! /bin/bash
psql_host=localhost
port=5432 
db_name=host_agent
username=postgres
password=password
get_free_mem(){
free_mem=$(vmstat -s | egrep "free memory$" | awk '{print $1}')
}
get_cpu_idel(){
cpu_idel=$(vmstat | awk '{for(i=NF;i>0;i--)if($i=="id"){x=i;break}}END {print $x}')}
get_disk_IO(){
disk_IO=$(vmstat -d | awk '{for(i=NF;i>0;i--)if($i=="cur"){x=i+1;break}}END {print $x}')
}
get_disk_available(){
disk_avail=$(df /dev/sda1 -m | awk '{for(i=NF;i>0;i--) if($i=="Available"){x=i;break}}END {print $x}')
}
get_cpu_kernel(){
cpu_kernel=$(vmstat | awk '{for(i=NF;i>0;i--)if($i=="sy"){x=i;break}}END {print $x}')
}
get_host_id(){
host_id=$(cat /home/centos/dev/jrvs/bootcamp/host_agent/scripts/host_info_id)
}
timestamp=$(vmstat -t | awk '{for(i=NF;i>0;i--)if($i=="UTC"){x=i;break}}END {print $x  " " $(x+1)}')
get_free_mem
get_host_id
get_cpu_idel
get_disk_IO
get_disk_available
get_disk_available
get_cpu_kernel
insert_stmt=$(cat <<-END
INSERT INTO  host_usage( timestamp, host_id ,free_mem,cpu_idel,cpu_kernel,disk_io,disk_avail) VALUES('${timestamp}','${host_id}','${free_mem}','${cpu_idel}','${cpu_kernel}','${disk_IO}','${disk_avail}');
END
)
echo $insert_stmt
export PGPASSWORD=$password
psql -h $psql_host -p $port -U $username -d $db_name -c "$insert_stmt"
