# == Class: oauth2_proxy::params
#
# This class should be considered private.
#
class oauth2_proxy::params {
  $manage_user      = true
  $user             = 'oauth2'
  $manage_group     = true
  $group            = $user
  $install_root     = '/opt/oauth2_proxy'
  $service_template = 'oauth2_proxy@.service.erb'
  $manage_service   = true
  $provider         = 'systemd'

  $version  = '2.2.0'
  $tarball  = "oauth2_proxy-${version}.linux-amd64.go1.8.1.tar.gz"
  $source   = "https://github.com/bitly/oauth2_proxy/releases/download/v2.2/${tarball}"
  $checksum = '1c73bc38141e079441875e5ea5e1a1d6054b4f3b'

  # in theory, this module should work on any linux distro that uses systemd
  # but it has only been tested on el7
  case $::osfamily {
    'RedHat': {
#      $provider = 'systemd'
      $shell = '/sbin/nologin'
      $systemd_path = '/usr/lib/systemd/system'
    }
    'Debian': {
#      $provider = 'debian'
      $shell = '/usr/sbin/nologin'
      $systemd_path = '/etc/systemd/system'
    }
    default: {
      fail("Module ${module_name} is not supported on operatingsystem ${::operatingsystem}")
    }
  }

  # bit.ly does not provide x86 builds
  case $::architecture {
    'x86_64': {}
    'amd64': {}
    default: {
      fail("Module ${module_name} is not supported on architecture ${::architecture}")
    }
  }
}
