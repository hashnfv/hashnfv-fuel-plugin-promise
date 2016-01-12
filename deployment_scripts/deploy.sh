#!/bin/bash

#: Fuel Plugin - OPNFV Resource Managment (Promise)
#:
#: https://wiki.opnfv.org/promise
#:
#: Version 1.2

package_install() {
    if [ ! -f "/usr/bin/curl" ]; then
        sudo apt-get -y install curl
    fi

	if [ ! -f "/usr/bin/git" ]; then
		sudo apt-get -y install git
	fi

    # This assume you have nodejs installed without checking a specific version
    if [ ! -f "/usr/bin/node" ]; then
        printf "Installing Nodejs 4.x..."
        curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
        sudo apt-get install -y nodejs
        printf "Nodejs 4.x installed\n"
    fi

    printf "Installing YangForge...\n"
    sudo npm -g install yangforge
    printf "YangForge installed!\n"
}

promise_install() {
    if [ -d "/usr/local/promise" ]; then
        rm -rf /usr/local/promise
    fi

    printf "Getting latest Promise from GitHub..."
    git clone https://github.com/opnfv/promise.git /usr/local/promise
    printf "Promise downloaded\n"
}

run_promise() {
    # For now there is no INIT script used to start promise
    # Will add that later as a major enhancement
    cd /usr/local/promise
    nohup yfc run --express 5050 promise.yaml > /var/log/promise.log &
    printf "Running Promise!\n"
}

if [ ! -f "/usr/bin/node" ]; then
    package_install
    promise_install
    run_promise
    exit 0
else
    printf "node is already installed!\n"
    printf "Skipping Nodejs 4.x installation...\n"
    printf "Skipping YangForge installation...\n"
    promise_install
    run_promise
    exit 0
fi
