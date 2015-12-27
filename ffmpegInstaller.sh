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
        
        echo "Installing libx264...."
        cd ~/ffmpeg_sources
        git clone --depth 1 git://git.videolan.org/x264
        cd x264
        PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
        config_chk libx264
        mk
        chk_last libx264
        
        echo "Installing fdk-aac..."
        cd ~/ffmpeg_sources
        git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
        cd fdk-aac
        autoreconf -fiv
        ./configure --prefix="$HOME/ffmpeg_build" --disable-shared
        config_chk fdk-aac
        mk
        chk_last fdk-aac
        
        echo "Installing libmp3lame..."
        cd ~/ffmpeg_sources
        curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
        tar xzvf lame-3.99.5.tar.gz
        cd lame-3.99.5
        ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm
        config_chk libmp3lame
        mk
        chk_last libmp3lame
        
        echo "Installing libvpx..."
        cd ~/ffmpeg_sources
        git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
        cd libvpx
        ./configure --prefix="$HOME/ffmpeg_build" --disable-examples
        config_chk libvpx
        mk
        chk_last libvpx
        
        