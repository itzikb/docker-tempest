# docker-tempest
It meant to make it easy to configure and run tempest against an existing cloud.

To use it run the following:
```
$ sudo docker run -it --name mytempest --env-file=keystonerc_admin itzikb/tempest /bin/bash
```

Inside the container run
```
$ ~/run_tempest.sh
$ source ../bin/activate
$ testr list-tests
```
**keystonerc_admin** is a file consists of OpenStack authentication environment files.
```
OS_USERNAME=admin
OS_PASSWORD=mypassword
OS_AUTH_URL=http://192.168.100.1:5000/v2.0
PS1=[\u@\h \W(keystone_admin)]\$
OS_TENANT_NAME=admin
OS_REGION_NAME=RegionOne
```
