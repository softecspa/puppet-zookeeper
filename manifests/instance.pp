define zookeeper::instance (
  $instance_id      = '',
  $client_port      = '',
  $listen_address   = '',
  $listen_interface = '',
  $root_dir         = '/var/lib'
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

  if $root_dir != '/var/lib' {
    if !defined(File[$root_dir]) {
      file {$root_dir :
        ensure  => present,
        owner   => 'zookeeper',
        group   => 'zookeeper',
        mode    => '0755'
      }
    }
  }

  $datadir = "${root_dir}/zookeeper{$id}"

  if ($listen_interface == '') and ($listen_address == '') {
    fail('please specify listen_address or listen_interface')
  }

  include zookeeper::install
  zookeeper::instance::config {$name:
    id            => $id,
    client_port   => $port,
    datadir       => $datadir,
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
