class opentsdb_single(
  $compression          = NONE,  ## NONE or LZO
  $hbase_parent_dir         = "/usr/local",
  $hbase_version            = "0.94.5",
  $hbase_url                = "http://www.apache.org/dist/hbase/hbase-0.94.5/hbase-0.94.5.tar.gz",
#  $hbase_rootdir             = "/tmp/tsdhbase", 
#  $hbase_bin                = "/usr/local//bin",                
  $opentsdb_parent_dir      = "/usr/local",
  $tcollector_parent_dir    = "/usr/local",
  $myuser_name              = "gwdg",
  $myuser_id                = "1010",
  $myuser_passwd            = '\$6\$aqzOtgCM\$OxgoMP4JoqMJ1U1F3MZPo2iBefDRnRCXSfgIM36E5cfMNcE7GcNtH1P/tTC2QY3sX3BxxJ7r/9ciScIVTa55l0',
  $mygroup_name             = "goettingen",
  $mygroup_id               = "1010",
  $java_home                = "/usr/lib/jvm/java-1.6.0-openjdk-amd64"
  
#  $iface                    = "lo"
  ){
    $hbase_bin = "usr/local/hbase-0.94.5/bin"
    $iface                    = "lo"
    $hbase_rootdir             = "/tmp/tsdhbase"
    $tsd_tmp                   = "/tmp/tsd"
    $opentsdb_home            = $::opentsdb_single::param::opentsdb_working_dir
    include opentsdb_single::param
    include opentsdb_single::myuser
    include opentsdb_single::hbase
    include opentsdb_single::opentsdb
    
    
 
}