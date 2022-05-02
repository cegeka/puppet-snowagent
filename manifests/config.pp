# Class: snowagent::config
#
# This module manages the configuration directories
#
# PRIVATE CLASS - do not use directly (use main `snowagent` class).
class snowagent::config inherits snowagent {

  file { $snowagent::install_dir:
    ensure => directory,
    mode   => '0750',
  }

  file { "${snowagent::install_dir}/${snowagent::config_name}":
    ensure  => file,
    content => template('snowagent/snowagent.conf.erb'),
    mode    => '0640',
    replace => $snowagent::replace_config
  }

  file_line { 'snow-client-default-cronjob':
    ensure => $snowagent::ensure_default_cron,
    path   => $snowagent::cron_root,
    line   => '0 21 * * * nice -n 10 /opt/snow/snowagent -w /opt/snow/ >/dev/null 2>&1',
  }

}
