#!/bin/bash

set -x
set -u

if [ $# -ne 1 ]; then
    echo "$0 container-id"
    exit 1
fi

container_id=$1

function copy_tcpdump() {
    libs=("/lib64/libcap-ng.so.0" "/lib64/libcap-ng.so.0.0.0" "/lib64/libcrypto.so.10" "/lib64/libcrypto.so.1.0.2k" "/lib64/libpcap.so.1" "/lib64/libpcap.so.1.5.3")

    # copy tcpdump
    docker cp /usr/sbin/tcpdump ${container_id}:/bin

    # copy tcpdump dependency
    for lib in "${libs[@]}"; do
        docker cp ${lib} ${container_id}:/lib
    done

    # useradd tcpdump
    docker exec -it ${container_id} useradd tcpdump
}

function copy_ss() {
    docker cp /usr/sbin/ss ${container_id}:/bin
}

function copy_ping() {
    docker cp /usr/bin/ping ${container_id}:/bin
}

function copy_telnet() {
    docker cp /usr/bin/telnet ${container_id}:/bin
}

copy_tcpdump
copy_ss
copy_ping
copy_telnet
