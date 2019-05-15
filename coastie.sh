#!/bin/bash
echo "What namespace do you want to use?"
read NAMESPACE
# Q beck tull
/usr/bin/kubectl create namespace $NAMESPACE

function test_nodeport () {
    # Create Deployment
    /usr/bin/kubectl create -f ${1}/server/deployment.yaml -n $NAMESPACE

    # Create nodePort service
    /usr/bin/kubectl create -f ${1}/server/nodePort.yaml -n $NAMESPACE

    # Get port
    PORT=$(kubectl get service ${1}server -o yaml -n $NAMESPACE | awk '/nodePort/ {print $2}')

    # Get Node
    NODE=$(kubectl get nodes --no-headers | head -1 | awk '{print $1}')

    # is Pod running and ready?
    # Give it 5 minutes
    i=0
    while [ $i -lt 300 ]; do
        PODSTATUS=$(kubectl get pods -n $NAMESPACE | grep "${1}server" | awk '{print $3}')
        if [ $PODSTATUS == "Running" ]; then
            echo "${1}server pod is up and running, it took $i seconds to get to this status"
            i=300
        else
            sleep 1
            i=$(( $i + 1 ))
        fi
    done
    PODSTATUS=$(kubectl get pods -n $NAMESPACE | grep "${1}server" | awk '{print $3}')
    if [ $PODSTATUS != "Running" ]; then
        echo "Pod took longer than $TIMEOUT to start"
        echo "Pod status is $PODSTATUS"
    fi
    # Run check
    go run ${1}/client/main.go -node $NODE -port $PORT
}

test_nodeport "tcp"
test_nodeport "udp"
