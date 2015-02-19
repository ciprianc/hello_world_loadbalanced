node loadbalancer {
  include baseconfig
  include nginx

  nginx::resource::vhost { '_':
    proxy => 'http://ciprians_app',
  }

  nginx::resource::upstream { 'ciprians_app':
    members => [
     '192.168.50.2:8080',
     '192.168.50.3:8080',
    ],
  }
}

node web-1 {
  include super_simple_app
  include baseconfig
}

