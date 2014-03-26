define zookeeper::instance::service (
  $id,
  $listen,
  $port
) {

  exec{"start_zookeeper_${id}":
    command => "/usr/share/zookeeper/bin/zkServer.sh start zoo${id}.cfg",
    unless  => "/bin/echo ruok | nc $listen $port | grep imok",
  }

}
