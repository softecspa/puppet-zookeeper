define zookeeper::instance::monitoring (
  $monitored_hostname,
  $notifications_enabled  = undef,
  $notification_period    = undef,
  $listen_address,
  $port,
) {

  $id=$name

  nrpe::check { "zookeeper${id}":
    binaryname  => 'check_generic',
    contrib     => true,
    params      => "-e \"/bin/echo ruok | nc ${listen_address} ${port}\" -o \"=~/imok/\""
  }

  $nrpe_check_name = $monitored_hostname? {
    $::hostname => "!check_zookeeper${id}",
    default     => "!check_zookeeper${id}_${::hostname}"
  }

  $service_description = $monitored_hostname? {
    $::hostname => "zookeeper${id}",
    default     => "${::hostname} zookeeper${id}",
  }

  @@nagios::check { "zookeeper-${id}-${::hostname}":
    host                  => $monitored_hostname,
    checkname             => 'check_nrpe_1arg',
    service_description   => $service_description,
    notifications_enabled => $notifications_enabled,
    notification_period   => $notification_period,
    target                => "zookeeper_${::hostname}.cfg",
    params                => $nrpe_check_name,
    tag                   => "nagios_check_zookeeper_${nagios_hostname}",
  }

}
