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

  $required_packages = [ 'python-flask', 'gunicorn', 'python-gevent' ]
  package { $required_packages: ensure => 'latest', }

  file { "/usr/local/bin/super_simple_app.py":
    ensure     => file,
    owner      => root,
    group      => root,
    mode       => '0755',
    require    => Package['python-flask'],
    source     => "puppet:///modules/super_simple_app/super_simple_app.py",
  }

  file { "/usr/local/bin/test_super_simple_app.py":
    ensure     => file,
    owner      => root,
    group      => root,
    mode       => '0755',
    require    => Package['python-flask'],
    source     => "puppet:///modules/super_simple_app/test_super_simple_app.py",
    before     => File['/usr/local/bin/super_simple_app.py']
  }

  file { "/etc/init/super_simple_app.conf":
    ensure     => file,
    owner      => root,
    group      => root,
    mode       => '0644',
    require    => Package['python-flask'],
    source     => "puppet:///modules/super_simple_app/upstart_super_simple_app.conf",
  }

  service { "super_simple_app":
    ensure     => 'running',
    enable     => true,
    provider   => 'upstart',
  }

  exec { 'test_super_simple_app.py':
    cwd        => "/usr/local/bin/",
    command    => '/usr/local/bin/test_super_simple_app.py',
    require    => File['/usr/local/bin/super_simple_app.py', '/usr/local/bin/test_super_simple_app.py'],
    returns    => 0
  }

}

