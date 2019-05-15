# Coastie

## Purpose
Coastie is a tool to help you check the health of your kubernetes cluster.

It checks a number of k8 resources you likely care about, like tcp, udp, http etc etc.

## Requirements
Coastie expects that you can create a new namespace, and deploy containers and services to it.

Coastie expects you are already logged into the cluster you want to test.

Coastie expects you have kubectl, and go installed.

## Alpha
This base is currently in alpha status, and will likely move from bash to a dedicated app at a later point.

## How to use
```/bin/bash
./coastie.sh
```
