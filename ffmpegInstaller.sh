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
        if [ -f /etc/redhat-release ]
        then
        echo "OS DETECTED: CentOS"
        yum install autoconf automake bzip2 bzip2-devel cmake freetype-devel gcc gcc-c++ git libtool make mercurial pkgconfig zlib-devel -y
    elif [[ -f /etc/os-release ]]; then
        echo "OS DETECTED: UBUNTU"
        apt-get -y install autoconf automake build-essential cmake git-core libass-dev libfreetype6-dev libsdl2-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo wget zlib1g-dev
    else
        echo "OS NOT SUPPORTED"
        exit
    fi

        owd=$(pwd)
	    mkdir -p /usr/ffmpeg2017/
        export HOME=/usr/ffmpeg2017/ #  Global Declaration
        PATH=$PATH:/usr/ffmpeg2017/bin
        echo "Making installation directory..."
        mkdir ~/ffmpeg_sources
        
        echo "Installing ffmpeg libraries...."

	   echo "Installing Nasm assembler.."
	   cd ~/ffmpeg_sources
	   tar xjvf $owd/nasm-2.14.02.tar.bz2
	   cd nasm-2.14.02
	   ./autogen.sh
	   PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
	   make
	   make install
	   make distclean
       cd ~/ffmpeg_sources
        
        echo "Installing Yasm assembler..."
        cd ~/ffmpeg_sources
        tar -xzvf $owd/yasm-1.3.0.tar.gz
        cd yasm-1.3.0
        ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
        config_chk Yasm
        make
        make install
        make distclean
        cd ~/ffmpeg_sources

        chk_last Yasm
        
        echo "Installing libx264...."
        cd ~/ffmpeg_sources
        tar -xJf $owd/x264.tar.xz
        cd "x264-snapshot-20160220-2245-stable"
        PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --enable-pic
        config_chk libx264
        make
        make install
        make distclean
        cd ~/ffmpeg_sources
        chk_last libx264
        
        echo "Installing fdk-aac..."
        cd ~/ffmpeg_sources
        tar -xJf $owd/fdk-aac.tar.xz
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
        tar xzvf $owd/lame-3.99.5.tar.gz
        cd lame-3.99.5
        ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm
        config_chk libmp3lame
        make
        make install
        make distclean
        cd ~/ffmpeg_sources
        chk_last libmp3lame
        
        echo "Installing opencoreamr..."
        cd ~/ffmpeg_sources
        tar -xzvf $owd/opencore-amr-0.1.3.tar.gz
        cd opencore-amr-0.1.3
        ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
        config_chk opencore 
        make
        make install
        make distclean
        cd ~/ffmpeg_sources
        chk_last opencore
        
        echo "Installing xvidcore..."
        cd ~/ffmpeg_sources
        tar -xzvf $owd/xvidcore-1.3.2.tar.gz
        cd xvidcore/build/generic
        ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
        config_chk xvidcore
        make
        make install
        make distclean
        cd ~/ffmpeg_sources
        chk_last xvidcore
        
        echo "Installing aac-encoder..."
        cd ~/ffmpeg_sources
        tar -xzvf $owd/vo-aacenc-0.1.3.tar.gz
        cd vo-aacenc-0.1.3
        ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
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
        tar -xvf $owd/ffmpeg-2.8.2.tar.bz2
        cd ffmpeg-2.8.2
        PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" --bindir="$HOME/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libopencore-amrnb --enable-version3 --enable-libfdk_aac --enable-libvo-aacenc --enable-libmp3lame --enable-libx264 --enable-libxvid
        config_chk ffmpeg
        make
        make install
        make distclean
        cd ~/ffmpeg_sources
        chk_last ffmpeg
	
        
		echo "REMOVING LIBRARY FILES"
		
		rm -f $owd/lame-3.99.5.tar.xz
		rm -f $owd/opencore-amr-0.1.3.tar.xz
		rm -f $owd/xvidcore-1.3.2.tar.xz
		rm -f $owd/vo-aacenc-0.1.3.tar.xz
		rm -f $owd/ffmpeg-2.8.2.tar.bz2
        rm -f $owd/fdk-aac.tar.xz
        rm -f $owd/x264.tar.xz
        rm -f $owd/yasm-1.3.0.tar.gz
        rm -f $owd/nasm-2.14.02.tar.xz

		
		echo "REMOVING LIBRARY FOLDERS"
		
		rm -rf yasm
		rm -rf "x264-snapshot-20160220-2245-stable"
		rm -rf fdk-aac
		rm -rf lame-3.99.5
		rm -rf opencore-amr-0.1.3
		rm -rf xvidcore
		rm -rf vo-aacenc-0.1.3
		rm -rf ffmpeg-2.8.2
		rm -rf $HOME/ffmpeg_sources
		
		echo "ADDING LIBRARY PATH TO LDCONFIG"
		
		echo "/usr/ffmpeg2017/ffmpeg_build/lib/">>/etc/ld.so.conf
		ldconfig

        cd $HOME/bin
        mkdir 2017
        mv ffmpeg 2017/ffmpeg2017
        mv ffserver 2017/ffserver2017
        mv ffprobe 2017/ffprobe2017

        echo "ADDING ffmpeg2017 TO GLOBAL PATH"

        cd 2017
        export PATH=$PATH:$(pwd)

        echo 'ADD PATH=$PATH:'$(pwd) "TO ENVIRONMENT GLOBALLY TO RUN ffmpeg2017"

        echo "---------------FFMPEG INSTALLER EXITED------------------"