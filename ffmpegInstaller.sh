#!/bin/bash

chk_root(){
    USR=`id -u`
    if [ "$USR" != 0 ]
    then
        echo "Login as Root to run the installer"
        exit
    fi
}

    chk_root
        echo "Installing dependencies........."
        #yum install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel -y
        