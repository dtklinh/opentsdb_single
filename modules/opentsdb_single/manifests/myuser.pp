class opentsdb_single::myuser{
  user{$::opentsdb_single::myuser_name:
    ensure    => present,
    uid       => $::opentsdb_single::myuser_id,
    gid       => $::opentsdb_single::mygroup_id,
    home      => "/home/${opentsdb_single::myuser_name}",
    shell     => "/bin/bash",
    comment   => "opentsdb setup",
    managehome => true,
    
#    password  => '$6$fPUohVXH$bYZY38RJIKKUK9fF6U/taOZfOwFdRoBnRkZOV71lGIWVMj96nOwWOAMp5EGbfJUjbrnHP/EvszbRkZgWYRkL3.',
#    password  => '$6$aqzOtgCM$OxgoMP4JoqMJ1U1F3MZPo2iBefDRnRCXSfgIM36E5cfMNcE7GcNtH1P/tTC2QY3sX3BxxJ7r/9ciScIVTa55l0', ## vagrant
   
#    password => '$6$mUBHZvRH$h2k8rJlJ3VV4Z8wdy3gTWKC0VpKqxNITP29KEs.uN7CnDyoVVJzpb4LRlMEonzrQi6syCz5rBh.8HIa/o6fpS/', ## linh
   # $6$eYS93/tX$jrZqsmlF6UlauwniUXyzs0a2NDvZUp0BRnn4r83GsYUDIdj4VVij5VqjYbKh.aeP2IDa6oJoKI0PCoy4FGqju1
    require   => Group["${opentsdb_single::mygroup_name}"],
  }
  
  # set password for user
  exec{"SetPasswd":
    command     => "usermod -p ${opentsdb_single::myuser_passwd} ${opentsdb_single::myuser_name}; adduser ${opentsdb_single::myuser_name} sudo",
    #path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/vagrant_ruby/bin",
    path        => $::path,
    creates     => "/home/tmp_dir",
    require     => User["${opentsdb_single::myuser_name}"],
#    refreshonly => true,
  }
  
  file{"/home/tmp_dir":
    ensure => directory,
    require => Exec["SetPasswd"],
  }
  
  group{$::opentsdb_single::mygroup_name:
    ensure    => present,
    gid       => $::opentsdb_single::mygroup_id,
  }
  
}