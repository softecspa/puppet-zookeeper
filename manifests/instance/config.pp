define zookeeper::instance::config (
  $id,
  $client_port,
  $datadir,
) {

  file {"/etc/zookeeper/conf/myid${id}":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $id
  }

  file {$datadir:
    ensure  => directory,
    owner   => 'zookeeper',
    group   => 'zookeeper',
    mode    => '0775'
  }

  file {"${datadir}/myid":
    ensure  => link,
    target  => "/etc/zookeeper/conf/myid${id}",
    require => File[$datadir]
  }

  file {"/etc/zookeeper/conf/zoo${id}.cfg":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Concat_build["zoo${id}.cfg"]
  }

  concat_build{"zoo${id}.cfg":
    order   => ['*.tmp'],
    target  => "/etc/zookeeper/conf/zoo${id}.cfg"
  }

  concat_fragment{"zoo${id}.cfg+001.tmp":
    content => template('zookeeper/etc/zoo.cfg.erb')
  }

  Concat_fragment <| title == "zoo${id}.cfg+002.tmp" |>

}
