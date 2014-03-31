define zookeeper::path (
  $id,
  $address,
  $client_port,
  $path_name    = '',
) {

  $path = $path_name?{
    ''      => regsubst($name, '--.*--$',''),
    default => $path_name
  }

  exec {"create_path_${path}_${id}":
    command => "/usr/share/zookeeper/bin/zkCli.sh -server ${address}:${client_port} -cmd create /${path} $path",
    unless  => "/usr/share/zookeeper/bin/zkCli.sh -server ${address}:${client_port} -cmd ls2 / 2>&1 | grep ${path}",
    require => Exec["start_zookeeper_${id}"],
  }
}
