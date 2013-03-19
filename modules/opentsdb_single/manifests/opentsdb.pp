class opentsdb_single::opentsdb{
  include opentsdb_single::param
  $opentsdb_url     = "https://github.com/OpenTSDB/opentsdb"
  
  ## install packages
  package{["dh-autoreconf", "gnuplot", "git"]:
    ensure => installed,
    require => Exec["Prepare_hbase"],
  }
  
  
  ## download package
  exec{"opentsdb_prepare":
    command     => "git clone ${opentsdb_url}",
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
    command       => "su - ${opentsdb_single::myuser_name} -c 'cd /usr/local/opentsdb; ./build.sh'",
    cwd           => "${opentsdb_single::param::opentsdb_working_dir}",
    path          => $::path,
    require       => [File["opentsdb"], Service["hbase"]],
    creates       => "${opentsdb_single::param::opentsdb_working_dir}/build",
  }
  
  ## create table at the beginning
  exec{"create_table":
    command       => "su - ${opentsdb_single::myuser_name} -c 'cd ${opentsdb_single::param::opentsdb_working_dir}; env COMPRESSION=${opentsdb_single::compression} HBASE_HOME=${opentsdb_single::param::hbase_working_dir} ./src/create_table.sh'",
    cwd           => $::opentsdb_single::param::opentsdb_working_dir,
    path          => $::path,
    creates       => "${opentsdb_single::param::hbase_working_dir}/create_table_dir",
    require       => [Exec["local_build"], File["create_table"]],
  }
  
  file{"${opentsdb_single::param::hbase_working_dir}/create_table_dir":
    ensure        => directory,
    require       => Exec["create_table"],
  }
  
  file{"tsdtmp":
    path      => $opentsdb_single::tsd_tmp,
    ensure    => directory,
  }
  
  service{"opentsdb":
    ensure      => running,
    require     => [File["tsdtmp"],File["opentsdb_service"]],
  }

}

class opentsdb_single::opentsdb::copy_conf{
  include opentsdb_single::param
  
  ## edit create_table.sh
  file{"create_table":
    path      => "${opentsdb_single::param::opentsdb_working_dir}/src/create_table.sh",
    ensure    => file,
    content   => template("opentsdb_single/create_table.sh.erb"),
    mode      => 755,
#    owner     => "${opentsdb_single::myuser_name}",
#    group     => "${opentsdb_single::mygroup_name}",
    require   => File["opentsdb"],
  }
  
  file{"opentsdb_service":
    path        => "${opentsdb_single::param::service_path}/opentsdb",
    content     => template("opentsdb_single/opentsdb.erb"),
  }
}