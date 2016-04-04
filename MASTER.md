# Setting up the SentientHome Master

By now you should have brought up one Raspberry PI on Hypriot OS following the
HYPRIOT.md steps and have validated that you are able to log in.

Assuming the the host name is `master` we ssh into the host:

```bash
ssh root@master
```

The next steps need to be performed on the `master`.

## Install SentientHome Deployment framework

This will install the deployment framework from github directly onto the master:

```shell
cd
git clone https://github.com/SentientHome/shDeploy.git
cd shDeploy
git git checkout -b master
```

Alternatively you can fork and clone the repo via ssh - assuming you have the
proper keys setup - so you can commit edits:

```shell
cd
git clone git@github.com:SentientHome/shDeploy.git #replace with your fork
cd shDeploy
git git checkout -b mybranch
```

Once installed simply run:

```shell
~/shDeploy/setup
```

Note: Run `setup --help` to see available options. Defaults should work fine on
a new cluster.

## Adding the public key to your github account (optional)

With the keys setup, lets add them to your [github](https://github.com) account.
Follow the instruction: [Adding a new SSH key to your GitHub account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)

This step is optional but allows you to commit changes in your configuration to
your personal configuration repo.
