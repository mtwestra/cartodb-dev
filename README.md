This is a set of scripts to install a development environment for https://github.com/CartoDB/cartodb[CartoDB] using Vagrant.

It is based on the excellent work by Steve Bennett (https://github.com/stevage/cartodb-dev), which was based on earlier work by Shiv Shankar Menon (https://github.com/sshankar/cartodb-dev). Thanks for the great work guys!

As described in this Google Groups thread (https://groups.google.com/forum/#!msg/cartodb/12OJiLupYBk/XJqxceP4YyYJ) some modifications were necessary to make it work. This version of the scripts worked with master branch of CartoDB (commit 9901eef5e5), as downloaded on August 21st, 2014.

## Installing with Vagrant
The base OS for this configuration in Vagrant terms is "precise32", which is an Ubuntu 12.04 LTS distro. The installation procedure is split into many subscripts, so failure and reruns are easier. If a rerun is done, previous steps can be commented out.

On the host machine, this needs to be run:

```
git clone http://github.com/mtwestra/cartodb-dev

nano settings # Edit as appropriate, for example change the user name and password. In the examples below, we will use the username 'monkey'

vagrant up
```

As CartoDB is pretty heavy, the script take a lot of time to download the required dependencies.

Once the provisioning is done, the script starts the required services.


As the domain property in the configuration is set to localhost.lan, the host machine is required to have a name to address mapping. Execute this in the host machine: 

```
echo "127.0.0.1 monkey.localhost.lan" | sudo tee -a /etc/hosts
```

The vagrant configuration forwards port 3000 from the host to the guest. So monkey.localhost.lan:3000 from the host machine will take you to the CartoDB's login page. The password is the one that has been provided in the settings file. If you have chosen a different user name, please change the subdomain name accordingly

### packaging boxes
As the script takes a long time to run, it makes sense to package intermediate results that are known to be ok in a separate box. This can be done as follows:

1. with a running VM, type
```
vagrant package --output cartodb.box

vagrant box add cartodb ./cartodb.box
```

2. In your vagrantfile, you can now use:
```
config.vm.box = "cartodb"

config.vm.box_url = "/PATH/TO/cartodb-dev/cartodb.box"
```

### Mac OS
On Mavericks, port 5432 is already in use. That is why we forward guest port 5432 to port 15432 on the host.

### pgAdmin
You can use pgAdmin3 to connect to the guest, to see what is going on in the postgresql database. Settings:
```
name: whatever you like
host: localhost
port: 15432
Maintenance database: postgres
username: postgres
password: empty (no really, empty)
```