#!/bin/bash
echo "What namespace do you want to use?"
read NAMESPACE
echo "What hostname to use for http check?"
read HTTPHOSTNAME
# Q beck tull
/usr/bin/kubectl create namespace $NAMESPACE

function test_pod_status () {
    PODNAME="$1"
    # is Pod running and ready?
    # Give it 5 minutes
    i=0
    while [ $i -lt 300 ]; do
        PODSTATUS=$(kubectl get pods -n $NAMESPACE | grep "$PODNAME" | awk '{print $3}')
        if [ $PODSTATUS == "Running" ]; then
            echo "${1}server pod is up and running, it took $i seconds to get to this status"
            i=300
        else
            sleep 1
            i=$(( $i + 1 ))
        fi
    done
    PODSTATUS=$(kubectl get pods -n $NAMESPACE | grep "$PODNAME" | awk '{print $3}')
    if [ $PODSTATUS != "Running" ]; then
        echo "Pod took longer than $TIMEOUT to start"
        echo "Pod status is $PODSTATUS"
    fi
}

function test_nodeport () {
    # Create Deployment
    /usr/bin/kubectl create -f ${1}/server/deployment.yaml -n $NAMESPACE

    # Create nodePort service
    /usr/bin/kubectl create -f ${1}/server/nodePort.yaml -n $NAMESPACE

    # Get port
    PORT=$(kubectl get service ${1}server -o yaml -n $NAMESPACE | awk '/nodePort/ {print $2}')

    # Get Node
    NODE=$(kubectl get nodes --no-headers | head -1 | awk '{print $1}')

    # Check pod status
    test_pod_status "${1}server"

    # Run check
    go run ${1}/client/main.go -node $NODE -port $PORT
}

function test_http () {
    # Create Deployment
    /usr/bin/kubectl create -f http/server/deployment.yaml -n $NAMESPACE

    # Create service
    /usr/bin/kubectl create -f http/server/service.yaml -n $NAMESPACE

    # Create ingress
    sed "s/REPLACEME/$HTTPHOSTNAME/g" http/server/ingress.yaml > /tmp/ingress.yaml
    /usr/bin/kubectl create -f /tmp/ingress.yaml -n $NAMESPACE

    # Check pod status
    test_pod_status "httpserver"

    # Check ingress
    go run http/client/main.go -hostname $HTTPHOSTNAME

}

test_nodeport "tcp"
test_nodeport "udp"
test_http
