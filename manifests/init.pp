# Class: zookeeper
#
# This module install zookeeper and creates instances.
#
# Examples: We suppose to create a zookeeper ensemble.
# Please, refer to zookeeper::instance and zookeeper::ensemble::solr for more information about used parameters.
#
# 1) all instances on the same node. We'll use:
#   * 2181-2183 as client port
#   * 2888-2890 as leader port
#   * 3888-3890 as election port
#   * zoo.example.com as fqdn of our node
#
# NOTE: client_port, leader_port and election_port must be different for more instances on the same node. If you have a single instance on a single node, you can use the same
#       port on each instance
#
# node clusterzoo {
#   class {'zookeeper::ensemble::solr':
#     chroot  => true,
#     nodes   => {'zoo.example.com:2181' => {id =>1, address => 'zoo.example.com', client_port => '2181', leader_port =>'2888', election_port => '3888'},
#                 'zoo.example.com:2182' => {id =>2, address => 'zoo.example.com', client_port => '2182', leader_port =>'2889', election_port => '3889'},
#                 'zoo.example.com:2183' => {id =>3, address => 'zoo.example.com', client_port => '2183', leader_port =>'2890', election_port => '3890'}},
#     tags    => ['cluster-liliana']
#   }
# }
#
# node zoo.example.com inherits clusterzoo {
#   Zookeeper::Instance {
#     listen_address  => 'zoo.example.com',
#   }
#
#   zookeeper::instance {'1':}
#   zookeeper::instance {'2':}
#   zookeeper::instance {'3':}
# }
#
# 2) single instance per node. We'll use:
#    * 2181 as client port
#    * 2888 as leader port
#    * 3888 as election port
#    * zoo1.example.com as fqdn of our first node
#    * zoo2.example.com as fqdn of our second node
#    * zoo3.example.com as fqdn of our third node
#
# node clusterzoo {
#   class {'zookeeper::ensemble::solr':
#     chroot  => true,
#     nodes   => {'zoo1.example.com:2181' => {id =>1, address => 'zoo1.example.com', client_port => '2181', leader_port =>'2888', election_port => '3888'},
#                 'zoo2.example.com:2181' => {id =>1, address => 'zoo2.example.com', client_port => '2181', leader_port =>'2888', election_port => '3888'},
#                 'zoo3.example.com:2181' => {id =>1, address => 'zoo3.example.com', client_port => '2181', leader_port =>'2888', election_port => '3888'}},
#     tags    => ['cluster-liliana']
#   }
# }
#
# node zoo1.example.com inherits clusterzoo {
#   zookeeper::instance {'1':
#     listen_address  => 'zoo1.example.com',
#   }
# }
#
# node zoo2.example.com inherits clusterzoo {
#   zookeeper::instance {'1':
#     listen_address  => 'zoo2.example.com',
#   }
# }
#
# node zoo3.example.com inherits clusterzoo {
#   zookeeper::instance {'1':
#     listen_address  => 'zoo3.example.com',
#   }
# }
#
class zookeeper {
  include zookeeper::install
  include zookeeper::config

  Class['zookeeper::install'] ->
  Class['zookeeper::config']
}
