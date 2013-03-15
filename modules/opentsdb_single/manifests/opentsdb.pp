class opentsdb_single::opentsdb{
  include opentsdb_single::param
  $opentsdb_url     = "https://github.com/OpenTSDB/opentsdb"
  
  ## install packages
  package{["dh-autoreconf", "gnuplot"]:
    ensure => installed,
    require => Exec["Prepare_hbase"],
  }
  
  ## download package
  exec{"opentsdb_prepare":
    command     => "wget ${opentsdb_url}",
    cwd         => "${opentsdb_single::opentsdb_parent_dir}",
    path        => $::path,
    require     => [Package["dh-autoreconf"],Package["gnuplot"]],
    creates     => "${opentsdb_single::param::opentsdb_working_dir}",
  }
  
  ## reown
  file{"opentsdb":
    path        => "${opentsdb_single::param::opentsdb_working_dir}",
    backup      => false,
    recurse     => true,
    owner       => "${opentsdb_single::myuser_name}",
    group       => "${opentsdb_single::mygroup_name}",
    require     => Exec["opentsdb_prepare"],
  }
  
  include opentsdb_single::opentsdb::copy_conf
  
  ## locally build opentsdb
  exec{"local_build":
    command       => "./build.sh",
    cwd           => "${opentsdb_single::param::opentsdb_working_dir}",
    path          => $::path,
    require       => File["opentsdb"],
  }
  

}

class opentsdb_single::opentsdb::copy_conf{
  ## edit create_table.sh
  file{"create_table":
    path      => "${opentsdb_single::param::opentsdb_working_dir}/src/create_table.sh",
    content   => template("opentsdb_single/create_table.sh.erb"),
    mode      => 755,
    owner     => "${opentsdb_single::myuser_name}",
    group     => "${opentsdb_single::mygroup_name}",
    require   => File["opentsdb"],
  }
}