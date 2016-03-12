#
# Hadoop frontend manifest.
#

# global parameters

$master1 = 'hador-c1.ics.muni.cz'
$master2 = 'hador-c2.ics.muni.cz'
$zookeepers = [
  $master1,
  $master2,
  'hador.ics.muni.cz',
]
$cluster_name = 'hador-cluster'
$user_group = 'hadoopusers'
$user_gid = 10070
$realm = 'ICS.MUNI.CZ'

include ::stdlib

# java installed separately here to invoke custom parameters
# (hiera would be the better way)
class { '::java_ng':
  flavor      => 'jdk',
  set_default => true,
  version     => 8,
  stage       => 'setup',
}

class { '::hadoop':
  hdfs_hostname         => $master1,
  hdfs_hostname2        => $master2,
  yarn_hostname         => $master2,
  yarn_hostname2        => $master1,
  slaves                => [],
  journalnode_hostnames => $zookeepers,
  zookeeper_hostnames   => $zookeepers,
  cluster_name          => $cluster_name,
  # needed for 'yarn logs' also on the client
  features => {
    'aggregation' => true,
  },
  properties            => {
    'dfs.replication' => 4,
    # make sense only on the server side (just cosmetics)
    'dfs.namenode.name.dir' => '::undef',
    'dfs.namenode.checkpoint.dir' => '::undef',
    'dfs.datanode.data.dir' => '::undef',
    'dfs.journalnode.edits.dir' => '::undef',
    'dfs.hosts' => '::undef',
    'dfs.ha.automatic-failover.enabled' => '::undef',
    'hadoop.http.authentication.signature.secret.file' => '::undef',
    'yarn.nodemanager.local-dirs' => '::undef',
  },
  realm                 => $realm,
}

class { '::hbase':
  hdfs_hostname       => $master1,
  zookeeper_hostnames => $zookeepers,
  # for asynchbase (required also on the client)
  properties => {
    'hbase.rpc.protection' => '::undef',
  },
  realm               => $realm,
}

class { '::hive':
  metastore_hostname  => $master1,
  server2_hostname    => $master1,
  zookeeper_hostnames => $zookeepers,
  group               => $user_group,
  realm               => $realm,
}

class { '::spark':
  hdfs_hostname          => $cluster_name,
  historyserver_hostname => $master2,
  # TODO: change it to 18088 in the cluster one day
  historyserver_port     => 18080,
  jar_enable             => true,
  realm                  => $realm,
}

class { '::site_hadoop':
  mirror              => 'scientific',
  # java installed separately
  java_enable         => false,
  # requires additional capabilities
  nfs_frontend_enable => false,
}

group { $user_group:
  gid => $user_gid,
}

include ::site_hadoop::role::frontend
