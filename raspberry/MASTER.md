# Setting up the SentientHome Master

By now you should have brought up one Raspberry PI on Hypriot OS following the
HYPRIOT.md steps and have validated that you are able to log in.

Assuming the the host name is `master` we ssh into the host:

```bash
ssh root@master
```

The next steps need to be performed on the `master`.

## Generating a new key pair

In order to establish secure password less ssh connectivity between the master
and all the cluster nodes in the house we generate a new rsa_id:

```bash
ssh-keygen -t rsa -b 4096 -q -P "" -f /root/.ssh/id_rsa
```

This key pair will be the default for all secure ssh communications

## Adding the public key to your github account (optional)

With the keys setup, lets add them to your [github](https://github.com) account.
Follow the instruction: [Adding a new SSH key to your GitHub account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)

This step is optional but allows you to commit changes in your configuration to
your personal configuration repo.

## Enabling password less ssh to our various hosts

Now that we have a key pair, lets install the public key on all hosts we have
created and that are already running after the initial boot.

We suggest you follow the naming convention:

```shell
master # SentientHome master (current host)
dns1 # Main DNS and DHCP server for the home
dns2 # Optional redundant DNS and DHCP server

pi-01-01 # Hosts for Docker Swarm cluster without external storage
pi-01-02
...
pi-01-nn

pi-50-01 # Hosts for Docker Swarm cluster WITH external storage (e.g. SSD)
pi-50-02
...
pi-50-nn
```

In order to copy the public keys onto all the hosts we have to run the following
for every host in our setup:

```shell
function getip() { (traceroute $1 2>&1 | head -n 1 | cut -d\( -f 2 | cut -d\) -f 1) }
PI_IP=$(getip dns1.local)
echo $PI_IP
ssh-keygen -R $PI_IP
ssh-copy-id -oStrictHostKeyChecking=no -oCheckHostIP=no root@$PI_IP
ssh -t root@$PI_IP passwd
```

Note: The very last statement changes the root password of the node. Don't skip
that step. Default passwords are not an option in any setup.
