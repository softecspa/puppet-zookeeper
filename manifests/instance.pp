define zookeeper::instance (
  $instance_id      = '',
  $client_port      = '',
  $datadir          = '',
  $listen_address   = '',
  $listen_interface = '',
) {

  $start_port='2180'

  $id = $instance_id?{
    ''      => $name,
    default => $instance_id
  }

  if !is_numeric($id) {
    fail('please specify a numeric value for instance id')
  }

  $port = $client_port?{
    ''      => inline_template("<%= start_port.to_i + $id %>"),
    default => $client_port
  }

  $real_datadir = $datadir?{
    ''      => "/opt/zookeeper${id}",
    default => $datadir
  }

  if ($listen_interface == '') and ($listen_address == '') {
    fail('please specify listen_address or listen_interface')
  }

  include zookeeper::install
  zookeeper::instance::config {$name:
    id            => $id,
    client_port   => $port,
    datadir       => $real_datadir,
  }

  $listen = $listen_address? {
    ''      => inline_template("<%= ipaddress_${listen_interface} %>"),
    default => $listen_address
  }

  zookeeper::instance::service {$name:
    id      => $id,
    listen  => $listen,
    port    => $port
  }

  Class['zookeeper::install'] ->
  Zookeeper::Instance::Config[$name] ->
  Zookeeper::Instance::Service[$name]
}
