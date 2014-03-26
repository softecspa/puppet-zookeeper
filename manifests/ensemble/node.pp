define zookeeper::ensemble::node(
  $id,
  $address,
  $client_port,
  $leader_port,
  $election_port,
  $nodes_hash
) {

  @concat_fragment {"zoo${id}.cfg+002.tmp":
    content => template('zookeeper/etc/ensemble_nodes.erb')
  }

}
