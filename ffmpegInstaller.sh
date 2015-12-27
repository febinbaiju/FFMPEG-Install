#!/bin/bash

alias mk='make && make install && make distclean && cd ~/ffmpeg_sources'
chk_root(){
    USR=`id -u`
    if [ "$USR" == 0 ]
    then
        echo "Login as Root to run the installer"
        exit
    fi
}
chk_last(){
    if [ "$?" != 0 ]
    then
        echo "$1 Installation failed"
        exit
    fi
}
config_chk(){
        if [ "$?" != 0 ]
    then
        echo "Configuration for $1 failed"
        exit
    fi
}

    chk_root
        echo "Installing dependencies........."
        #yum install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel -y
        
        export HOME=/usr #  Global Declaration
        echo "Making installation directory..."
        mkdir ~/ffmpeg_sources
        
        echo "Installing Yasm assembler..."
        cd ~/ffmpeg_sources
        git clone --depth 1 git://github.com/yasm/yasm.git
        cd yasm
        autoreconf -fiv
        ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
        config_chk Yasm
        mk
        chk_last Yasm
        