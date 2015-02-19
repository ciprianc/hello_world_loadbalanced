hello_world_loadbalanced
=========

Simple vagrant setup, 1 nginx lb + 2 web workers, managed by puppet

* [What this is](#huhwhat)
* [How to use it](#how)
* [Vagrantfile and the setup of the small 3 server cluster](#vagrant)
* [dynamic web application](#theapp)
* [unit tests for the app](#thetests)
* [puppet](#thedoll)

### <a name="huhwhat"></a>What's this
This repo is a simple three cluster Vagrant setup that:
 - runs two boxes which contain a simple web app written in python + flask
   - the app itself is unit tested by puppet, which executes the unit tests
 - runs one load balancer box that balances traffic to the two app boxes
 - configures everything via puppet

** Requirements **

| Name        | Where to get it from           |
| ------------- |:-------------:|
| virtualbox      |https://www.virtualbox.org/wiki/Downloads |
| vagrant      | http://www.vagrantup.com/downloads.html | 
| Linux/Mac OS X | http://lmgtfy.com/?q=what+is+an+operating+system |

### <a name="how"></a>How to use it
It's as simple as executing the following command inside the folder which contains this repo:
```
vagrant up
```
That will bring up the boxes, configure everything, and forward localhost:65080 to the load balancer.
All you need to do afterwards is go to: http://localhost:65080/ in your local browser



### <a name="vagrant"></a>Vagrantfile
All the nodes are defined at the top of the vagrant file, then they're dinamically created.
```
nodes = [ 
  { :hostname => 'web-1',        :ip => '192.168.50.10'},
  { :hostname => 'web-2',        :ip => '192.168.50.11'},
  { :hostname => 'loadbalancer', :ip => '192.168.50.253'},
]
```

Because provisioning is done by puppet, and the ubuntu image doesn't include it, I first install puppet using a shell provisioner, then each box is provisioned by puppet
```
      inline: "apt-get update ; DEBIAN_FRONTEND=noninteractive apt-get -yq install puppet"
```

The load balancer box is a bit "special" as I want to forward its port 80 to the host's 65080.
This is so that whoever runs the Vagrantfile can point his/hers browser to localhost:65080
```
        if node[:hostname] == 'loadbalancer'
            box.vm.network "forwarded_port", guest: 80, host: 65080, auto_correct: true
        end
```

### <a name="theapp"></a>The application
Very simple app written in python + flask that:
 - echoes whatever's after the /
 - and it's ran by gunicorn
 - it is "installed" into /usr/local/bin/ by puppet
 - puppet also install an upstart script to make it a daemon, then starts the daemon
 - it's unit tested

### <a name="thetests"></a>The unit tests
Written using python's unittest framework and:
 - has two tests
   - firs test makes sure that / is returning as expected
   - second test makes sure that /something is returning as expected
 - if the tests are failing puppet will also fail to run

Note: In a production environment this is in no way, shape or form an acceptable way of running tests. The tests should be a step in the deployment pipeline, but for this exercise I'm using puppet as a poor man's deployment pipeline 

### <a name="thedoll"></a>Puppet
I'm using standalone puppet and:
 - not using hiera, roles nor profiles as the setup is pretty simple.
 - custom plugin that installs the web app and tests it
   - everything's in init.pp, which is frowned upon, but I wanted to keep things simple
 - the 3rd party modules are downloaded and included in this repo. A more ideal setup would use puppet-librarian



