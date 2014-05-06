define zookeeper::instance::monitoring (
  $monitored_hostname,
  $notifications_enabled  = undef,
  $notification_period    = undef,
) {

  $id=$name

  nrpe::check_procs { "zookeeper${id}":
    crit            => '1:1',
    command         => 'java',
    argument_array  => "zoo${id}.cfg"
  }

  $nrpe_check_name = $monitored_hostname? {
    $::hostname => "!check_proc_zookeeper${id}",
    default     => "!check_proc_zookeeper${id}_${::hostname}"
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
