#!/bin/bash

chk_root(){
    USR=`id -u`
    if [ "$USR" != 0 ]
    then
        echo "Login as Root to run the installer"
        exit
    fi
}
chk_url(){
    if [ "$?" != 0 ]
    then
        echo "Library downloading failed.."
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
echo "---------------------Beginning FFMPEG Installation--------------------------"

    chk_root
        echo "Installing dependencies........."
        yum install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel -y
        
        export HOME=/usr #  Global Declaration
        echo "Making installation directory..."
        mkdir ~/ffmpeg_sources
        
        echo "Installing ffmpeg libraries...."
        
        echo "Installing Yasm assembler..."
        cd ~/ffmpeg_sources
        git clone --depth 1 git://github.com/yasm/yasm.git
        cd yasm
        autoreconf -fiv
        ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
        config_chk Yasm
        make
        make install
        make distclean
        cd ~/ffmpeg_sources

        chk_last Yasm
        
        echo "Installing libx264...."
        cd ~/ffmpeg_sources
        git clone --depth 1 git://git.videolan.org/x264
        cd x264
        PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
        config_chk libx264
        make
        make install
        make distclean
        cd ~/ffmpeg_sources
        chk_last libx264
        
        echo "Installing fdk-aac..."
        cd ~/ffmpeg_sources
        git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
        cd fdk-aac
        autoreconf -fiv
        ./configure --prefix="$HOME/ffmpeg_build" --disable-shared
        config_chk fdk-aac
        make
        make install
        make distclean
        cd ~/ffmpeg_sources
        chk_last fdk-aac
        
        echo "Installing libmp3lame..."
        cd ~/ffmpeg_sources
        curl -L -O "http://f23.wapka-files.com/download/e/7/d/1550859_e7dcab1276e8c43f7ece5cd2.gz/b81bfdde353d17551292/lame-3.99.5.tar.gz"
        chk_url
        tar xzvf lame-3.99.5.tar.gz
        vo-aacenc-0.1.3.tar.gz
        cd lame-3.99.5
        ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm
        config_chk libmp3lame
        make
        make install
        make distclean
        cd ~/ffmpeg_sources
        chk_last libmp3lame
        
        echo "Installing libvpx..."
        cd ~/ffmpeg_sources
        git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
        cd libvpx
        ./configure --prefix="$HOME/ffmpeg_build" --disable-examples
        config_chk libvpx
        make
        make install
        make distclean
        cd ~/ffmpeg_sources
        chk_last libvpx
        
        echo "Installing opencoreamr..."
        cd ~/ffmpeg_sources
        wget "http://f23.wapka-files.com/download/4/3/4/1550859_434372229364ae4147fc5995.gz/fc2cdda109f080601418/opencore-amr-0.1.3.tar.gz"
        chk_url
        tar -xzvf opencore-amr-0.1.3.tar.gz
        vo-aacenc-0.1.3.tar.gz
        cd opencore-amr-0.1.3
        ./configure
        config_chk opencore
        make
        make install
        make distclean
        cd ~/ffmpeg_sources
        chk_last opencore
        
        echo "Installing xvidcore..."
        cd ~/ffmpeg_sources
        wget "http://f23.wapka-files.com/download/6/f/4/1550859_6f42b1af81ce16a272a99453.gz/3cfa40773f619fac8a67/xvidcore-1.3.2.tar.gz"
        chk_url
        tar -xzvf xvidcore-1.3.2.tar.gz
        vo-aacenc-0.1.3.tar.gz
        cd xvidcore/build/generic
        ./configure
        config_chk xvidcore
        make
        make install
        make distclean
        cd ~/ffmpeg_sources
        chk_last xvidcore
        
        echo "Installing aac-encoder..."
        cd ~/ffmpeg_sources
        wget "http://f23.wapka-files.com/download/8/3/b/1550859_83b67db5e380014adc2e5b5b.gz/24ef70261e5492bee5e6/vo-aacenc-0.1.3.tar.gz"
        chk_url
        tar -xzvf vo-aacenc-0.1.3.tar.gz
        rm -rf vo-aacenc-0.1.3.tar.gz
        cd vo-aacenc-0.1.3
        ./configure
        config_chk aac-encoder
        make
        make install
        make distclean
        cd ~/ffmpeg_sources
        chk_last aac-encoder
        
        echo "Finished Installing Libraries..."
        
        ## Installing ffmpeg
        echo "Installing FFMPEG...."
        
        cd ~/ffmpeg_sources
       wget "http://ffmpeg.org/releases/ffmpeg-2.8.2.tar.bz2"
       tar -zjvf ffmpeg-2.8.2.tar.bz2
        cd ffmpeg-2.8.2
        PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" --bindir="$HOME/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libopencore-amrnb --enable-version3 --enable-libfdk_aac --enable-libvo-aacenc --enable-libmp3lame --enable-libx264 --enable-libxvid
        config_chk ffmpeg
        make
        make install
        make distclean
        cd ~/ffmpeg_sources
        chk_last ffmpeg
        
        echo "---------------FFMPEG INSTALLATION SUCCESS------------------"