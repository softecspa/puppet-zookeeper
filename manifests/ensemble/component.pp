define zookeeper::ensemble::component (
  $id,
  $address,
  $client_port,
  $leader_port,
  $election_port,
  $tags,
  $chroot
) {

  $tags_suffix = regsubst($tags,'$',"--$name--")

  zookeeper::ensemble::component::node {$tags_suffix :
    address     => $address,
    client_port => $client_port,
    chroot      => $chroot
  }
}
