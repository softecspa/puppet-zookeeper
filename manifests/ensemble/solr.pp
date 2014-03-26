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

