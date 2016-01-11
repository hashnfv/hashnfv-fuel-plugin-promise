#!/bin/bash

#: Fuel Plugin - OPNFV Resource Managment (Promise)
#:
#: https://wiki.opnfv.org/promise
#:
#: Version 1.1

node_install() {
    if [ ! -f "/usr/bin/curl" ]; then
        sudo apt-get -y install curl
    fi

    # This assume you have nodejs installed without checking a specific version
    if [ ! -f "/usr/bin/node" ]; then
        printf "Installing Nodejs 4.x..."
        curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
        sudo apt-get install -y nodejs
        printf "Nodejs 4.x installed\n"
    fi
}

promise_install() {
    printf "Installing YangForge...\n"
    sudo npm -g install yangforge
    printf "YangForge installed!\n"

    printf "Getting latest Promise from GitHub..."
    git clone https://github.com/opnfv/promise.git /usr/local/promise
    printf "Promise downloaded\n"
}

run_promise() {
    # For now there is no INIT script used to start promise
    # Will add that later
    cd /usr/local/promise
    nohup yfc run opnfv-promise.yaml > /var/log/promise.log &
}

if [ ! -f "/usr/bin/node" ]; then
    node_install
    promise_install
    run_promise
    exit 0
else
    printf "node is already installed! Skipping Nodejs 4.x installation...\n"
    promise_install
    run_promise
    exit 0
fi
