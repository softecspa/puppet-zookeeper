class zookeeper {
  include zookeeper::install
  include zookeeper::config

  Class['zookeeper::install'] ->
  Class['zookeeper::config']
}
