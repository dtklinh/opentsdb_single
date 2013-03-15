class opentsdb_single::param{
  $hbase_working_dir    = "${opentsdb_single::hbase_parent_dir}/hbase-${opentsdb_single::hbase_version}"
  $opentsdb_working_dir = "${opentsdb_single::opentsdb_parent_dir}/opentsdb"
  $tcollector_working_dir = "${opentsdb_single::tcollector_parent_dir}/tcollector"
  $service_path         = '/etc/init.d'
 # $hbase_bin                = "${hbase_working_dir}/bin"
  $log_path = $::operatingsystem ? {
        Darwin   => "/Users/${opentsdb_single::myuser_name}/Library/Logs/hbase/",
        default => "/var/log/hbase/",
        }
        
}