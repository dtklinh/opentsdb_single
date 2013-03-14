class opentsdb_single::myuser{
  user{$::opentsdb_single::myuser_name:
    ensure    => present,
    uid       => $::opentsdb_single::myuser_id,
    gid       => $::opentsdb_single::mygroup_id,
    home      => "/home/${opentsdb_single::myuser_name}",
    shell     => "/bin/bash",
    managehome => true,
    password => '$6$mUBHZvRH$h2k8rJlJ3VV4Z8wdy3gTWKC0VpKqxNITP29KEs.uN7CnDyoVVJzpb4LRlMEonzrQi6syCz5rBh.8HIa/o6fpS/', ## linh
    require   => Group["${opentsdb_single::mygroup_name}"],
  }
  
  group{$::opentsdb_single::mygroup_name:
    ensure    => present,
    gid       => $::opentsdb_single::mygroup_id,
  }
  
}