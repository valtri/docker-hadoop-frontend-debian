#
# Cloudera repository
#

class { '::site_hadoop':
  mirror              => 'scientific',
  # java installed separately
  java_enable         => false,
  # requires special permissions
  nfs_frontend_enable => false,
}

include ::site_hadoop::cloudera
