# Define: zookeeper::instance
#
# This define creates a zookeeper instance
#
# Parameters:
#
# [*instance_id*]
#   Integer, id of the instance. If empty, <name> will be used
#
# [*client_port*]
#   client_port used by zookeeper to comunicate with solr. Default: 2180 + $instance_id
#
# [*datadir*]
#   directory where instance's data is stored. Default: /opt/zookeeper${instance_id}
#
# [*listen_address*]
#   IP or host address on which zookeeper instance is listening
#
# [*listen_interface*]
#   Interface used by zookeeper instance to listen to. ipaddress_${listen_interface} will be used as listen_address
#
# [*monitored*]
#   It true, instance will be monitored by nagios
#
# [*monitored_hostname*]
#   Hostname used by nagios to perform the checks. Default: $::hostname
#
# [*notifications_enabled*]
#   1 enable nagios notification, 0 otherwise. Default: undef
#
# [*notification_period*]
#   Notification period used in nagios service. Default: undef
#
#
define zookeeper::instance (
  $instance_id            = '',
  $client_port            = '',
  $datadir                = '',
  $listen_address         = '',
  $listen_interface       = '',
  $balancer_cluster       = '',
  $balancer_port          = '2180',
  $monitored              = true,
  $monitored_hostname     = $::hostname,
  $notifications_enabled  = undef,
  $notification_period    = undef,
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

  if $balancer_cluster != '' {
    haproxy::balanced_zookeeper {"${balancer_cluster}_${port}":
      cluster_balancer    => $balancer_cluster,
      balanced_interface  => $listen_interface,
      balanced_address    => $listen_address,
      port                => $port
    }
  }

  if $monitored {
    zookeeper::instance::monitoring {$id :
      monitored_hostname    => $monitored_hostname,
      notifications_enabled => $notifications_enabled,
      notification_period   => $notification_period,
      port                  => $port,
      listen_address        => $listen
    }
  }

  Class['zookeeper::install'] ->
  Zookeeper::Instance::Config[$name] ->
  Zookeeper::Instance::Service[$name]
}
