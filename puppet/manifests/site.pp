node loadbalancer {
  include sudo
  include nginx

  sudo::conf { 'vagrant': priority => 10 , content  => "vagrant ALL=(ALL) NOPASSWD: ALL" }
  sudo::conf { 'admins': priority => 10, content  => "%admins ALL=(ALL) NOPASSWD: ALL" }

  nginx::resource::vhost { '_': proxy => 'http://ciprians_app', }
  nginx::resource::upstream { 'ciprians_app': 
    members => [ '192.168.50.2:8080', '192.168.50.3:8080', ],
  }
}

node /web-[0-9]/ {
  include super_simple_app
}


