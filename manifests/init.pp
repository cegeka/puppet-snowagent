# Class: snowagent
#
# This module manages SNOW Software asset management agent
#
#
# Parameters:
# * [ensure_cron] Run the SNOW agent using a cron schedule
#
# * [ensure_systemd] Run the SNOW agent using a systemd timer
#
# * [cron_schedule] Hash with values supported by the puppet cron resource
#
# * [systemd_schedule] String value. The basic format for systemd timers using OnCalendar= is DOW YYYY-MM-DD HH:MM:SS. DOW (day of week) is optional, and other fields can use an asterisk (*) to match any value for that position.
#
class snowagent(
  String $endpoint_address,
  String $site_id,
  String $configuration_name,
  String $ensure_cron             = $snowagent::params::ensure_cron,
  String $ensure_default_cron     = $snowagent::params::ensure_default_cron,
  String $ensure_systemd          = $snowagent::params::ensure_systemd,
  Hash $cron_schedule             = $snowagent::params::cron_schedule,
  String $cron_root               = $snowagent::params::cron_root,
  Integer $cron_nice              = $snowagent::params::cron_nice,
  String $systemd_schedule        = $snowagent::params::systemd_schedule,
  String $systemd_slice_cpu       = $snowagent::params::systemd_slice_cpu,
  String $systemd_slice_memory    = $snowagent::params::systemd_slice_memory,
  String $user                    = $snowagent::params::user,
  String $package_name            = $snowagent::params::package_name,
  String $package_ensure          = $snowagent::params::package_ensure,
  String $install_dir             = $snowagent::params::install_dir,
  String $config_name             = $snowagent::params::config_name,
  String $log_level               = $snowagent::params::log_level,
  Boolean $oraclescanner          = $snowagent::params::oraclescanner,
  String $custom_ca_bundle_path   = $snowagent::params::custom_ca_bundle_path,
  Boolean $ssl_certificate_verify = $snowagent::params::ssl_certificate_verify,
  String $java_home_path          = $snowagent::params::java_home_path,
  Array $excludes                 = $snowagent::params::excludes,
) inherits snowagent::params {

  include snowagent::install
  include snowagent::config
  include snowagent::service

  anchor { 'snowagent::start': }
  -> Class['snowagent::install']
  -> Class['snowagent::config']
  -> Class['snowagent::service']

}
