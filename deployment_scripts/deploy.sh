#!/bin/bash

#: Fuel Plugin - OPNFV Resource Managment (Promise)
#:
#: https://wiki.opnfv.org/promise
#:
#: Version 1.3

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

    if [ ! -f "/etc/init.d/promise" ]; then
        cat <<PROMISEINIT > /tmp/promiseinit
IyEvYmluL2Jhc2gKIyBXcml0dGVuIGJ5IEhpcm9ub2J1IE1hZWRhCiMKIyBwcm9taXNlIGRhZW1v
bgojIGNoa2NvbmZpZzogMzQ1IDIwIDgwCiMgZGVzY3JpcHRpb246IHByb21pc2UgZGFlbW9uCiMg
cHJvY2Vzc25hbWU6IHByb21pc2VfZGFlbW9uCgojIHNvdXJjZSBmdW5jdGlvbiBsaWJyYXJ5Ci4g
L2xpYi9sc2IvaW5pdC1mdW5jdGlvbnMKCnNldCAtZQoKTkFNRT0icHJvbWlzZSIKUE9SVD0iNTA1
MCIKCmV4cG9ydCBOT0RFX1BBVEg9L3Vzci9sb2NhbC9saWIvbm9kZV9tb2R1bGVzLyR7TkFNRX0v
bm9kZV9tb2R1bGVzOi91c3IvbG9jYWwvbGliL25vZGVfbW9kdWxlcy8ke05BTUV9L2xpYgpQQVRI
PS9iaW46L3NiaW46L3Vzci9iaW46L3Vzci9zYmluOi91c3IvbG9jYWwvYmluCkRBRU1PTl9QQVRI
PSIvdXNyL2xvY2FsLyR7TkFNRX0iCkxPR0RJUj0iL3Zhci9sb2cvJHtOQU1FfSIKTE9HRklMRT0i
JHtMT0dESVJ9LyR7TkFNRX0ubG9nIgppZiBbIC1mIC91c3IvbG9jYWwvYmluL3lmYyBdOyB0aGVu
CiAgICBEQUVNT049Ii91c3IvbG9jYWwvYmluL3lmYyIKZWxzZQogICAgREFFTU9OPSIvdXNyL2Jp
bi95ZmMiCmZpCkRBRU1PTk9QVFM9InJ1biAtLWV4cHJlc3MgJFBPUlQgcHJvbWlzZS55YW1sIgoK
UElERklMRT0vdmFyL3J1bi8kTkFNRS5waWQKU0NSSVBUTkFNRT0vZXRjL2luaXQuZC8kTkFNRQoK
Y2FzZSAiJDEiIGluCnN0YXJ0KQogICAgICAgIHByaW50ZiAiJS01MHMiICJTdGFydGluZyAkTkFN
RS4uLiIKICAgICAgICBpZiBbIC16ICJgL3Vzci9iaW4vcGdyZXAgLXhmICJub2RlICR7REFFTU9O
fSAke0RBRU1PTk9QVFN9ImAiIF07IHRoZW4KICAgICAgICAgICAgWyAtZCAiJExPR0RJUiIgXSB8
fCBta2RpciAtcCAkTE9HRElSCiAgICAgICAgICAgIGNkICREQUVNT05fUEFUSAogICAgICAgICAg
ICBQSUQ9YCREQUVNT04gJERBRU1PTk9QVFMgPj4gJHtMT0dGSUxFfSAyPiYxICYgZWNobyAkIWAK
ICAgICAgICAgICAgc2xlZXAgMgogICAgICAgICAgICBpZiBbIC16ICRQSUQgXSB8fCBbIC16ICJg
cHMgYXhmIHwgZ3JlcCAke1BJRH0gfCBncmVwIC12IGdyZXBgIiBdOyB0aGVuCiAgICAgICAgICAg
ICAgICBwcmludGYgIiVzXG4iICJGYWlsIgogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgICAg
ICBlY2hvICRQSUQgPiAkUElERklMRQogICAgICAgICAgICAgICAgcHJpbnRmICIlc1xuIiAiT2si
CiAgICAgICAgICAgIGZpCiAgICAgICAgIGVsc2UKICAgICAgICAgICAgcHJpbnRmICIlc1xuIiAi
RmFpbGVkIHRvIHN0YXJ0LiBPdGhlciBQcm9jZXNzIHN0aWxsIHJ1bm5pbmciCiAgICAgICAgIGZp
Cjs7CnN0YXR1cykKICAgICAgICBwcmludGYgIiUtNTBzIiAiQ2hlY2tpbmcgJE5BTUUuLi4iCiAg
ICAgICAgaWYgWyAtZiAkUElERklMRSBdOyB0aGVuCiAgICAgICAgICAgIFBJRD1gY2F0ICRQSURG
SUxFYAogICAgICAgICAgICBpZiBbIC16ICJgcHMgYXhmIHwgZ3JlcCAke1BJRH0gfCBncmVwIC12
IGdyZXBgIiBdOyB0aGVuCiAgICAgICAgICAgICAgICBwcmludGYgIiVzXG4iICJQcm9jZXNzIGRl
YWQgYnV0IHBpZGZpbGUgZXhpc3RzIgogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgICAgICBl
Y2hvICJSdW5uaW5nIgogICAgICAgICAgICBmaQogICAgICAgIGVsc2UKICAgICAgICAgICAgcHJp
bnRmICIlc1xuIiAiU2VydmljZSBub3QgcnVubmluZyIKICAgICAgICBmaQo7OwpzdG9wKQogICAg
ICAgIHByaW50ZiAiJS01MHMiICJTdG9wcGluZyAkTkFNRSIKICAgICAgICBjZCAkREFFTU9OX1BB
VEgKICAgICAgICBpZiBbIC1mICRQSURGSUxFIF07IHRoZW4KICAgICAgICAgICAgUElEPWBjYXQg
JFBJREZJTEVgCiAgICAgICAgICAgIGlmIFsgLXogImAvdXNyL2Jpbi9wZ3JlcCAtUCAkUElEYCIg
XTsgdGhlbgogICAgICAgICAgICAgICAgaWYgWyAteiAiYC91c3IvYmluL3BncmVwIC14ZiAibm9k
ZSAke0RBRU1PTn0gJHtEQUVNT05PUFRTfSJgIiBdOyB0aGVuCiAgICAgICAgICAgICAgICAgICAg
cHJpbnRmICIlc1xuIiAiT2siCiAgICAgICAgICAgICAgICAgICAgcm0gLWYgJFBJREZJTEUKICAg
ICAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgICAgICAgICBraWxsIC05IGAvdXNyL2Jpbi9w
Z3JlcCAteGYgIm5vZGUgJHtEQUVNT059ICR7REFFTU9OT1BUU30iYAogICAgICAgICAgICAgICAg
ICAgIHNsZWVwIDMKICAgICAgICAgICAgICAgICAgICBpZiBbIC16ICJgL3Vzci9iaW4vcGdyZXAg
LXhmICJub2RlICR7REFFTU9OfSAke0RBRU1PTk9QVFN9ImAiIF07IHRoZW4KICAgICAgICAgICAg
ICAgICAgICAgICAgcHJpbnRmICIlc1xuIiAiT2siCiAgICAgICAgICAgICAgICAgICAgICAgIHJt
IC1mICRQSURGSUxFCiAgICAgICAgICAgICAgICAgICAgZWxzZQogICAgICAgICAgICAgICAgICAg
ICAgICBwcmludGYgIiVzXG4iICJGYWlsZWQgdG8ga2lsbC4gUHJvY2VzcyBzdGlsbCBydW5uaW5n
IGFuZCBwaWRmaWxlIGV4aXN0cyIKICAgICAgICAgICAgICAgICAgICBmaQogICAgICAgICAgICAg
ICAgZmkKICAgICAgICAgICAgZWxzZQogICAgICAgICAgICAgICAgaWYgWyAteiAiYC91c3IvYmlu
L3BncmVwIC14ZiAibm9kZSAke0RBRU1PTn0gJHtEQUVNT05PUFRTfSJgIiBdOyB0aGVuCiAgICAg
ICAgICAgICAgICAgICAgcHJpbnRmICIlc1xuIiAiT2siCiAgICAgICAgICAgICAgICAgICAgcm0g
LWYgJFBJREZJTEUKICAgICAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgICAgICAgICBraWxs
IC05IGAvdXNyL2Jpbi9wZ3JlcCAteGYgIm5vZGUgJHtEQUVNT059ICR7REFFTU9OT1BUU30iYAog
ICAgICAgICAgICAgICAgICAgIHByaW50ZiAiJXNcbiIgIk9rIgogICAgICAgICAgICAgICAgICAg
IHJtIC1mICRQSURGSUxFCiAgICAgICAgICAgICAgICBmaQogICAgICAgICAgICBmaQogICAgICAg
IGVsc2UKICAgICAgICAgICAgaWYgWyAteiAiYC91c3IvYmluL3BncmVwIC14ZiAibm9kZSAke0RB
RU1PTn0gJHtEQUVNT05PUFRTfSJgIiBdOyB0aGVuCiAgICAgICAgICAgICAgICBwcmludGYgIiVz
XG4iICJPayIKICAgICAgICAgICAgZWxzZQogICAgICAgICAgICAgICAga2lsbCAtOSBgL3Vzci9i
aW4vcGdyZXAgLXhmICJub2RlICR7REFFTU9OfSAke0RBRU1PTk9QVFN9ImAKICAgICAgICAgICAg
ICAgIHNsZWVwIDMKICAgICAgICAgICAgICAgIGlmIFsgLXogImAvdXNyL2Jpbi9wZ3JlcCAteGYg
Im5vZGUgJHtEQUVNT059ICR7REFFTU9OT1BUU30iYCIgXTsgdGhlbgogICAgICAgICAgICAgICAg
ICAgIHByaW50ZiAiJXNcbiIgIk9rIgogICAgICAgICAgICAgICAgZWxzZQogICAgICAgICAgICAg
ICAgICAgIHByaW50ZiAiJXNcbiIgIkZhaWxlZCB0byBraWxsLiBQcm9jZXNzIHN0aWxsIHJ1bm5p
bmciCiAgICAgICAgICAgICAgICBmaQogICAgICAgICAgICBmaQogICAgICAgIGZpCjs7CgpyZXN0
YXJ0KQogICAgICAgICQwIHN0b3AKICAgICAgICAkMCBzdGFydAo7OwoKKikKICAgICAgICBlY2hv
ICJVc2FnZTogJDAge3N0YXR1c3xzdGFydHxzdG9wfHJlc3RhcnR9IgogICAgICAgIGV4aXQgMQpl
c2FjCg==
PROMISEINIT
        base64 -d /tmp/promiseinit > /etc/init.d/promise
        chmod 755 /etc/init.d/promise
    else
        printf "Promise INIT script already installed! Skipping...\n"
fi

    if [ ! -f "/etc/logrotate.d/promise" ]; then
        printf "Installing logrotate...\n"
        cat << LOGROTATE > /etc/logrotate.d/promise
/var/log/promise/promise.log {
   size 200M
   copytruncate
   rotate 7
   compress
}
LOGROTATE
        printf "Promise logrotate installed!\n"
    else
        printf "Promise logrotate already installed! Skipping...\n"
    fi
}

run_promise() {
    ## DEPRECATED
    ## For now there is no INIT script used to start promise
    ## Will add that later as a major enhancement
    ## cd /usr/local/promise
    ## nohup yfc run --express 5050 promise.yaml > /var/log/promise.log &
    ## printf "Running Promise!\n"

    # Start promise via INIT script
    /etc/init.d/promise start
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
