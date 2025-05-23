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
    replace => $snowagent::replace_config,
  }

  #  Temporary, will be completely removed in 1 month
  #  We manage 2 cronjobs for SNOW. After testing with Dirk Scheepers
  #  we found out that this cronjob is not working as expected.
  #  No system variables were being sent over to SNOW using this cronjob.
  file { '/etc/cron.d/snowagent' :
    ensure => absent,
  }
}
