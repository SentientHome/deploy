# SentientHome-Deploy

Installation and Deployment of SentientHome DevOps Style

The SentientHome project can be deployed on a series of Raspberry PI images.

Take a look at a recommended [Sample Configuration](https:./SAMPLECONFIG.md)

Follow the description to [Install a master based on the Hypriot distribution](https:./HYPRIOT.md)

Once you have installed you master host simple run the following command as
`root` on the master:

```
curl -fsSL https://raw.githubusercontent.com/SentientHome/shDeploy/master/install | bash
```

This will install the main SentientHome deployment package. It will allow you to
perform various tasks required to setup SentientHome in a cluster setup
utilizing Docker and Docker-Swarm.
