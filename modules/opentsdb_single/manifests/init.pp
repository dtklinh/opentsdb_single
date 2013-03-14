class opentsdb_single(
  $lzo_compression          = false,
  $hbase_parent_dir         = "/usr/local",
  $hbase_version            = "0.94.5",
  $opentsdb_parent_dir      = "/usr/local",
  $tcollector_parent_dir    = "/usr/local",
  $myuser_name              = "gwdg",
  $myuser_id                = "1010",
  $mygroup_name             = "goettingen",
  $mygroup_id               = "1010"
  ){
    include opentsdb_single::myuser
    file{"/home/vagrant/hello.txt":
      ensure => present,
      content => 'Hello world \n',
    }
    
    
 
}