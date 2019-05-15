#!/bin/bash
echo "What namespace do you want to use?"
read NAMESPACE
/usr/bin/kubectl create namespace $NAMESPACE
# Q beck tull
# Create TCP Deployment
/usr/bin/kubectl create -f tcp/server/deployment.yaml -n $NAMESPACE

# Create TCP nodePort service
/usr/bin/kubectl create -f tcp/server/nodePort.yaml -n $NAMESPACE

# Get TCP port
TCPPORT=$(kubectl get service tcpserver -o yaml -n $NAMESPACE | awk '/nodePort/ {print $2}')

# Get Node
NODE=$(kubectl get nodes --no-headers | head -1 | awk '{print $1}')

# is Pod running and ready?
# Give it 5 minutes
i=0
while [ $i -lt 300 ]; do
    PODSTATUS=$(kubectl get pods -n $NAMESPACE | awk '/tcpserver/ {print $3}')
    if [ $PODSTATUS == "Running" ]; then
        echo "tcpserver pod is up and running, it took $i seconds to get to this status"
        i=300
    else
        sleep 1
        i=$(( $i + 1 ))
    fi
done
PODSTATUS=$(kubectl get pods -n $NAMESPACE | awk '/tcpserver/ {print $3}')
if [ $PODSTATUS != "Running" ]; then
    echo "Pod took longer than $TIMEOUT to start"
    echo "Pod status is $PODSTATUS"
fi
# Run TCP check
go run tcp/client/main.go -node $NODE -port $TCPPORT
