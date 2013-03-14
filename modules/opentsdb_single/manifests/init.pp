class opentsdb_single(
  $lzo_compression          = false,
  $hbase_parent_dir         = "/usr/local",
  $hbase_version            = "0.94.5",
  $opentsdb_parent_dir      = "/usr/local",
  $tcollector_parent_dir    = "/usr/local",
  $myuser_name              = "gwdg",
  $myuser_id                = "1010",
  $myuser_passwd            = '\$6\$aqzOtgCM\$OxgoMP4JoqMJ1U1F3MZPo2iBefDRnRCXSfgIM36E5cfMNcE7GcNtH1P/tTC2QY3sX3BxxJ7r/9ciScIVTa55l0',
  $mygroup_name             = "goettingen",
  $mygroup_id               = "1010"
  ){
    include opentsdb_single::myuser
    file{"/home/vagrant/hello.txt":
      ensure => present,
      content => 'Hello world \n',
    }
    
    
 
}