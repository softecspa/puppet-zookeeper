define zookeeper::instance::service (
  $id,
  $listen,
  $port
) {

  exec{"start_zookeeper_${id}":
    command => "/usr/share/zookeeper/bin/zkServer.sh start zoo${id}.cfg",
    unless  => "/bin/echo ruok | nc $listen $port | grep imok",
  }

  exec {"restart_zookeeper_${id}":
    command     => "/usr/share/zookeeper/bin/zkServer.sh restart zoo${id}.cfg",
    refreshonly => true,
    subscribe   => File["/etc/zookeeper/conf/zoo${id}.cfg"],
  }

}
