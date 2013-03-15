class opentsdb_single::hbase{
  
  include opentsdb_single::param
  include opentsdb_single::hbase::prepare
  
#  package{"openjdk-6-jdk":
#    ensure => installed,
#    require => Exec["Prepare_hbase"],
#  }
  
  ## download and extract hbase
  exec{"Prepare_hbase":
    command     => "apt-get update; apt-get upgrade; wget ${opentsdb_single::hbase_url}; tar xfz hbase-${opentsdb_single::hbase_version}.tar.gz",
    cwd         => "${opentsdb_single::hbase_parent_dir}",
    path        => $::path,
    creates     => "${opentsdb_single::param::hbase_working_dir}",
 #   require     => Package["openjdk-6-jdk"],
  }
  
  ## reown
  file{"reown-hbase":
    path      => "${opentsdb_single::param::hbase_working_dir}",
    backup    => false,
    recurse   => true,
    owner     => "${opentsdb_single::myuser_name}",
    group     => "${opentsdb_single::mygroup_name}",
    require   => [Exec["Prepare_hbase"],Package["openjdk-6-jdk"]],
  }
  include opentsdb_single::hbase::copy_conf
  include opentsdb_single::hbase::copy_service
  
  service{"hbase":
    ensure    => running,
    require   => [File["hbase"], Exec["source /etc/environment"]],
  }
}

class opentsdb_single::hbase::copy_conf{
  include opentsdb_single::param
  file{"hbase-site.xml":
    path    => "${opentsdb_single::param::hbase_working_dir}/conf/hbase-site.xml",
    content => template("opentsdb_single/hbase-site.xml.erb"),
    owner     => "${opentsdb_single::myuser_name}",
    group     => "${opentsdb_single::mygroup_name}",
    ensure    => file,
    require   => File["reown-hbase"],
    mode      => 644,
  }
}

class opentsdb_single::hbase::copy_service{
  include opentsdb_single::param
  file{"hbase":
    path    => "${opentsdb_single::param::service_path}/hbase",
    content => template("opentsdb_single/hbase.erb"),
    owner     => "${opentsdb_single::myuser_name}",
    group     => "${opentsdb_single::mygroup_name}",
    ensure    => file,
    mode      => 755,
    require   => File["reown-hbase"],
    notify    => Service["hbase"],
  }
  
  
}

class opentsdb_single::hbase::prepare{
  package{"openjdk-6-jdk":
    ensure => installed,
    require => Exec["Prepare_hbase"],
  }
  file{"envir":
    path      => "/etc/environment",
    content   => template("opentsdb_single/environment.erb"),
    require   => Package["openjdk-6-jdk"],
  }
  exec{"source /etc/environment":
    command     => "su - ${opentsdb_single::myuser_name} -c 'source /etc/environment'",
#    command     => "PATH=${path}; JAVA_HOME=${opentsdb_single::java_home}",
    require     => File["envir"],
    path => $::path,
  }
}



