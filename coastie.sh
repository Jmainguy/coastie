#!/bin/bash
# Q beck tull
# Create TCP Deployment
/usr/bin/kubectl create -f tcp/server/deployment.yaml

# Create TCP nodePort service
/usr/bin/kubectl create -f tcp/server/nodePort.yaml

# Get TCP port
TCPPORT=$(kubectl get service tcpserver -o yaml | awk '/nodePort/ {print $2}')

# Get Node
NODE=$(kubectl get nodes --no-headers | head -1 | awk '{print $1}')

# Run TCP check
go run tcp/client/main.go -node $NODE -port $TCPPORT
