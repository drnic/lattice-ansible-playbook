Lattice Ansible playbook
========================

Deploy Lattice using this Ansible playbook

NOTE: this is my first Ansible playbook.

Current status
--------------

This playbook was authored/updated last for v35 of lattice

```
$ curl http://lattice.s3.amazonaws.com/Version
35
```

There are 3 roles in this playbook:

-	lattice-coordinator
-	lattice-diego-cell
-	lattice-cli (requires golang and git; [joshualund.golang](https://github.com/jlund/ansible-go) is the dependency role that is used in Test Kitchen preparation)

The latter is primarily useful for the tests (which haven't been written) or for a bastian/worker machine.

All three roles can be run on the same machine.

I have not tested running the roles on different machines; my guess is it won't work due to static configuration files for consul. I'll work on that next.

I have not tested this playbook outside of Test Kitchen.

Issues/PRs created during development of this playbook:

-	[![pivotal-cf-experimental/lattice/pull/4](https://github-shields.com/github/pivotal-cf-experimental/lattice/pull/4.svg)](https://github-shields.com/github/pivotal-cf-experimental/lattice/pull/4)
-	[![pivotal-cf-experimental/lattice/issues/5](https://github-shields.com/github/pivotal-cf-experimental/lattice/issues/5.svg)](https://github-shields.com/github/pivotal-cf-experimental/lattice/issues/5)
-	[![pivotal-cf-experimental/lattice/issues/6](https://github-shields.com/github/pivotal-cf-experimental/lattice/issues/6.svg)](https://github-shields.com/github/pivotal-cf-experimental/lattice/issues/6)
-	[![pivotal-cf-experimental/lattice/pull/7](https://github-shields.com/github/pivotal-cf-experimental/lattice/pull/7.svg)](https://github-shields.com/github/pivotal-cf-experimental/lattice/pull/7)
-	[![pivotal-cf-experimental/lattice/pull/8](https://github-shields.com/github/pivotal-cf-experimental/lattice/pull/8.svg)](https://github-shields.com/github/pivotal-cf-experimental/lattice/pull/8)
-	[![pivotal-cf-experimental/lattice/pull/9](https://github-shields.com/github/pivotal-cf-experimental/lattice/pull/9.svg)](https://github-shields.com/github/pivotal-cf-experimental/lattice/pull/9)

Configuration
-------------

By default, the `lattice-coordinator` and `lattice-diego-cell` modules will do a one-time install of the latest lattice. Repeatedly running the modules will not perform an upgrade.

Alternately, explicitly specify a lattice version to install with a variable:

```yaml
vars:
  lattice_version: 35
```

To determine the latest version number:

```
$ curl http://lattice.s3.amazonaws.com/Version
35
```

Tests
-----

Right now there are no "tests" but there is a Test Kitchen harness to bring up an Ubuntu box and install the 3 roles.

```
vagrant box add lattice/ubuntu-trusty-64
bundle
kitchen converge
```

You can then SSH into the Test Kitchen vagrant VM:

```
kitchen login
```

And see the processes running:

```
$ ps auxww
root  9229... file-server -port=8080 -staticDirectory=/var/lattice/static-files -skipCertVerify=true -ccAddress=IGNORED -ccUsername=IGNORED -ccPassword=IGNORED
root  9239... gnatsd -c /var/lattice/config/gnatsd.conf
root  9250... doppler --config /var/lattice/config/doppler.json --debug
root  9253... route-emitter -debugAddr=0.0.0.0:17009
root  9260... receptor -address=0.0.0.0:8888 -registerWithRouter=true -username= -password= -domainNames=receptor..xip.io -natsAddresses=127.0.0.1:4222 -natsUsername=nats -natsPassword=nats
root  9264... gorouter -c /var/lattice/config/gorouter.yml
root  9299... trafficcontroller --config /var/lattice/config/trafficcontroller.json --disableAccessControl --debug
root  9309... consul agent -server -bootstrap-expect 1 -data-dir /tmp/consul-server -config-dir /var/lattice/config/consul-services -config-file /var/lattice/config/consul.json
root 15826... garden-linux -disableQuotas=true -listenNetwork=tcp -listenAddr=0.0.0.0:7777 -denyNetworks= -allowNetworks= -bin=/var/lattice/garden/garden-bin -depot=/var/lattice/garden/depot -rootfs=/var/lattice/garden/rootfs -overlays=/var/lattice/garden/overlays -graph=/var/lattice/garden/graph -containerGraceTime=1h
root 15834... executor -listenAddr=0.0.0.0:1700 -gardenNetwork=tcp -gardenAddr=127.0.0.1:7777 -memoryMB=auto -diskMB=auto -containerInodeLimit=200000 -containerMaxCpuShares=1024 -loggregatorSecret=loggregator-secret -loggregatorServer=127.0.0.1:4456 -allowPrivileged -skipCertVerify -exportNetworkEnvVars
root 15887... auctioneer -etcdCluster http://etcd.service.dc1.consul:4001
root 15898... converger -etcdCluster http://etcd.service.dc1.consul:4001
root 15913... rep -stack=lucid64 -executorURL=http://127.0.0.1:1700 -lrpHost=10.0.2.15 -cellID=cell-01_z -etcdCluster http://etcd.service.dc1.consul:4001
root 16516... metron --configFile /var/lattice/config/metron.json --debug
```

Due to a bug in the Lattice CLI, you currently cannot target the Lattice API. The CLI expects to pass a username/password but the `receptor` API process wasn't configured to accept one.

```
$ ltc target $(hostname -I).xip.io
Username:
Password:
Could not verify target.
```

Also, the built-in startup scripts for lattice aren't correctly detecting the `hostname -I` IP of the Test Kitchen VM; so you can see `receptor ... -domainNames=receptor..xip.io` is not valid.

License
-------

[MIT](http://opensource.org/licenses/MIT)

Author Information
------------------

Author:: [Dr Nic Williams](https://github.com/drnic) \<[drnicwilliams@gmail.com](drnicwilliams@gmail.com)\>
