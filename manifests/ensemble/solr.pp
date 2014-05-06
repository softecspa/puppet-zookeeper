# Class: zookeeper::ensemble::solr
#
# This class install shared component in a zookeeper ensemble. It also store on puppetDB information about ensemble's node. This information will be used by solr::instance define
#
# Parameters:
#
# [*chroot*]
#   True if the zookeeper esemble is shared between more clusters. It true, after installation, this class creates a path for each cluster specified in tag
#
# [*nodes*]
#   Hash with information about ensemble's nodes. Hash must hava form:
#   { 'address:port' => { id =>'$id', address => '$address', client_port => '$port', leader_port =>'$l_port', election_port => '$e_port'}, ...}
#
# [*tags*]
#   Array of cluster's name that can share this zookeeper ensemble
#
class zookeeper::ensemble::solr (
  $chroot = true,
  $nodes,
  $tags,
) {

  create_resources('zookeeper::ensemble::component',$nodes,{'tags' => $tags, 'chroot' => $chroot})

  class {'zookeeper::ensemble':
    chroot  => $chroot,
    nodes   => $nodes,
    tags    => $tags,
  }

}

