#
# Java for Hadoop frontend (Oracle - only available, version 8, sdk)
#

# java installed separately to invoke custom parameters
# (hiera would be the better way)
class { '::java_ng':
  flavor      => 'jdk',
  set_default => true,
  repo        => 'ppa:oracle',
  version     => 8,
}
