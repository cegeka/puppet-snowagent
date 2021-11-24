# OS specific configuration should be defined here
#
# PRIVATE CLASS - do not use directly (use main `snowagent` class).
class snowagent::params {

  $os_family = $facts['os']['family']
  $os_name = $facts['os']['name']
  $os_release = $facts['os']['release']['major']

  case $os_family {
    'RedHat': {
      # meta options
      $ensure_cron = present
      $ensure_default_cron = absent
      $cron_schedule = {
        'weekday' => undef,
        'monthday' => undef,
        'month' => undef,
        'hour' => 21,
        'minute' => 0,
      }
      $cron_root = '/var/spool/cron/root'
      $cron_nice = 10
      $ensure_systemd = absent
      $systemd_schedule = '*-*-* 21:00:00'
      $systemd_slice_cpu = '25%'
      $systemd_slice_memory = '25%'
      $user = 'root'
      $package_ensure = present
      $package_name = 'snowagent'
      $package_release = 6
      $install_dir = '/opt/snow'
      $config_name = 'snowagent.config'
      $oraclescanner = false
      $ssl_certificate_verify = true
      $custom_ca_bundle_path = '/etc/ssl/certs/ca-bundle.crt'
      $log_level = 'info'
      $java_home_path = '/usr/bin/java'
    }
    default: {
      fail("Module '${module_name}' is not supported on OS: '${os_name}', family: '${os_family}'")
    }
  }

}
