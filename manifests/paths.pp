define zookeeper::paths (
  $id,
  $address,
  $client_port,
  $leader_port,
  $election_port,
  $tags
) {

  $tags_suffix = regsubst($tags,'$',"--$id--")

  zookeeper::path{$tags_suffix:
    id           => $id,
    address      => $address,
    client_port  => $client_port,
  }
}
