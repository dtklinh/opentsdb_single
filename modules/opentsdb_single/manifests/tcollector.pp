class opentsdb_single::tcollector{
  ## download tcollector
  $tcollector_url   = "https://github.com/dtklinh/tcollector"
  
  exec{"download_tcollector":
    command       => "git clone ${tcollector_url}",
    cwd           => $opentsdb_single::tcollector_parent_dir,
    creates       => "${opentsdb_single::tcollector_parent_dir}/tcollector",
  }
  
  ## reown
  file{"reown_tcollector":
    path        => "${opentsdb_single::tcollector_parent_dir}/tcollector",
    backup      => false,
    recurse     => true,
    owner       => "${opentsdb_single::myuser_name}",
    group       => "${opentsdb_single::mygroup_name}",
    require     => Exec["download_tcollector"],
  }
  include opentsdb_single::tcollector::copy_conf
  include opentsdb_single::tcollector::copy_service
  service{"tcollector":
    ensure          => running,
    require         => [Service["opentsdb"],File["startstop"], File["tcollector_service"]],
  }
  
  
}

class opentsdb_single::tcollector::copy_conf{
  file{"startstop":
    path          => "${opentsdb_single::param::tcollector_working_dir}/startstop",
    content       => template("opentsdb_single/startstop.erb"),
    owner         => "${opentsdb_single::myuser_name}",
    group         => "${opentsdb_single::mygroup_name}",
    require       => File["reown_tcollector"],
  }
  
}

class opentsdb_single::tcollector::copy_service{
  file{"tcollector_service":
    path          => "${opentsdb_single::param::service_path}/tcollector",
    content       => template("opentsdb_single/tcollector.erb"),
    owner         => "${opentsdb_single::myuser_name}",
    group         => "${opentsdb_single::mygroup_name}",
    require       => File["reown_tcollector"],
  }
}
