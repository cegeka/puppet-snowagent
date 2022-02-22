# Class: snowagent::config
#
# This module manages the configuration directories
#
# PRIVATE CLASS - do not use directly (use main `snowagent` class).
class snowagent::service inherits snowagent {

  if ($snowagent::ensure_cron == 'present') and ($snowagent::ensure_systemd == 'present') {
    fail('[snowagent::service] you should choose between cron or systemd scheduling to prevent duplicate runs')
  }

  cron { 'snow-client-cronjob':
    ensure   => $snowagent::ensure_cron,
    command  => "/bin/nice -n 10 /bin/bash -l -c \"/bin/sleep $(/bin/shuf -i 1-600 -n 1) && /opt/snow/snowagent -w /opt/snow/\" >/dev/null 2>&1",
    hour     => $snowagent::cron_schedule['hour'],
    minute   => $snowagent::cron_schedule['minute'],
    monthday => $snowagent::cron_schedule['monthday'],
    weekday  => $snowagent::cron_schedule['weekday'],
    month    => $snowagent::cron_schedule['month'],
  }

  case $snowagent::ensure_systemd {
    'present': { $active = true }
    'absent': { $active = false }
    default: {}
  }
  case $::os[release][major] {
    '6': {}
    default: {
      file { "/etc/systemd/system/snowagent.service.d":
        ensure => directory
      }

      $timer = {
        'snowagent.timer' => {
          service_unit => 'snowagent.service',
          timer_content => template("snowagent/snowagent.timer.erb"),
          service_source => "puppet:///modules/snowagent/systemd/snowagent.service",
          active => $active,
          enable => $active,
          ensure => $snowagent::ensure_systemd
        }
      }
      create_resources(systemd::timer, $timer)

      file { "/etc/systemd/system/snowagent.slice":
        ensure  => $snowagent::ensure_systemd,
        content => template("snowagent/snowagent.slice.erb"),
        notify  => Exec['snowagent-systemd_reload']
      }

      exec { 'snowagent-systemd_reload':
        command => 'systemctl daemon-reload',
        path => [ '/usr/bin', '/bin', '/usr/sbin' ],
        refreshonly => true
      }
    }
  }

}
