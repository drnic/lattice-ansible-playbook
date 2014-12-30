Lattice Ansible playbook
========================

Deploy Lattice using this Ansible playbook

NOTE: this is my first Ansible playbook.

Current status
--------------

There are 3 roles in this playbook:

-	lattice-coordinator
-	lattice-diego-cell
-	lattice-cli (requires golang and git; [joshualund.golang](https://github.com/jlund/ansible-go) is the dependency role that is used in Test Kitchen preparation)

The latter is primarily useful for the tests (which haven't been written) or for a bastian/worker machine.

All three roles can be run on the same machine.

I have not tested running the roles on different machines; my guess is it won't work due to static configuration files for consul. I'll work on that next.

I have not tested this playbook outside of Test Kitchen.

Tests
-----

Right now there are no "tests" but there is a Test Kitchen harness to bring up an Ubuntu box and install the 3 roles.

```
vagrant box add lattice/ubuntu-trusty-64
bundle
kitchen converge
```

License
-------

[MIT](http://opensource.org/licenses/MIT)

Author Information
------------------

Author:: [Dr Nic Williams](https://github.com/drnic) \<[drnicwilliams@gmail.com](drnicwilliams@gmail.com)\>
