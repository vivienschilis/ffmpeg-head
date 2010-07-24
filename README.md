# FFMpeg bootstrap

## What it is.
  It's a tools which allow you to build a static ffmpeg binary.
  It creates a building environment for ffmpeg
  It Dowloads all recent codecs and tools and compile them
  It reduces 

## What it is not. 
It is not a package manager
You need to have installed all compiling dependencies
They should be pointed out by the autotools of each libraries

## How it works. 

* Create the root directory

    mkdir build
    cd build

* Download the Makefile

    wget http://github.com/vivienschilis/ffmpeg_bootstrap/raw/master/Makefile
    
* Build and download all files

    make bootstrap
    
* Apply ffmpeg patches (optional)

  If you to apply patches on ffmpeg, put your XX_yourfile_.patch file into the build/patches directory
  Use the following syntax to ensure the good order 00_myfirstpath.patch 01_mysecondpath.patch etc...

    make patch
    
    make unpatch # if you what to unpatch in the inverse order
    
* Compile codecs and ffmpeg

    make
    
* Compile qt-faststart (optional)

    make qtfs
    
* Compile segmenter (optional)

    make segmenter

* Clean all compiling directories

    make clean
    
* Clean all environment

    make cleanall