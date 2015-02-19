# == Class: super_simple_app
#
#  Class to install the lbmanager_agent package, copy the jinja template and logging configuration
#  The deb package itself contains the jinja template, logging configuration and upstart script,
#  but they should be managed by puppet, so that's why they're here.
#
# === Parameters
#
# === Examples
#
# === Authors
#
# Ciprian Ciubotariu - ciprianc@gmail.com
#
# === Copyright
#
# Ciprian Ciubotariu - ciprianc@gmail.com
#


class super_simple_app() {

  package { 'python-flask': ensure => 'latest', }

  file { "/usr/local/bin/cipriansapp.py":
    ensure     => file,
    owner      => root,
    group      => root,
    mode       => '0755',
    require    => Package['python-flask'],
    source     => "puppet:///modules/super_simple_app/cipriansapp.py",
  }
}

