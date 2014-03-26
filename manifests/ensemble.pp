class zookeeper::ensemble (
  $chroot = true,
  $nodes,
  $tags,
) {

  create_resources ('zookeeper::ensemble::node',$nodes,{'nodes_hash' => $nodes})
  if $chroot {
    create_resources ('zookeeper::paths',$nodes,{'tags' => $tags})
  }
  #esportare il necessario per recuperare gli zookeeper

}
