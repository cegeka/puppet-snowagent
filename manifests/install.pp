# Class: snowagent::install
#
# This module manages installation tasks.
#
# PRIVATE CLASS - do not use directly (use main `snowagent` class).
class snowagent::install inherits snowagent {
  anchor { 'snowagent::install::begin': }

  package { $snowagent::package_name :
    ensure => $snowagent::package_ensure
  }

}
