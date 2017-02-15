# docker-tempest
It meant to make it easy to configure and run tempest against an existing cloud.

Docker should be installed and running.
To install it run(Fedora):
```
$ sudo dnf -y install docker && sudo systemctl start docker && sudo systemctl enable docker
```
or For other RHEL based distros:
```
$ sudo yum -y install docker && sudo systemctl start docker && sudo systemctl enable docker
```

Before running you need to have a directory with overcloudrc file and set the SELinux file context. 

For example:
```
$ sudo chcon -Rt svirt_sandbox_file_t /home/stack
```

To use it run the following (Here overcloudrc file is under /home/stack):
```
$ sudo docker run -it --name mytempest -v /home/stack:/env itzikb/docker-tempest /bin/bash
```

If you need to run the other_tempest_config.sh script (for now just adding lbaasv2 extenstion) run as follows:

```
$ sudo docker run -it --name mytempest -e OTHER_CONFIG=/home/centos/scripts/other_tempest_config.sh -v /home/stack:/env itzikb/docker-tempest  /bin/bash
```

Inside the container run
```
$ ~/run_tempest.sh
$ source ../bin/activate
$ testr list-tests
```
**itzikb/docker-tempest** is the docker image to use (don't change)  
**keystonerc_admin** is a file consists of OpenStack authentication environment files.

**Note: Use the following as an example. Don't use the word export in your file as used by the shell**
```
OS_USERNAME=admin
OS_PASSWORD=mypassword
OS_AUTH_URL=http://192.168.100.1:5000/v2.0
PS1=[\u@\h \W(keystone_admin)]\$
OS_TENANT_NAME=admin
OS_REGION_NAME=RegionOne
```

You can access the container by running
```
$ sudo docker exec -it <container-name> /bin/bash
```
You can see all the containers by running
```
$ sudo docker ps -a 
```
