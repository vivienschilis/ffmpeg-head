# FFMpeg bootstrap

## What it is.

  It's a tool which allows people to build a static ffmpeg binary.
  It creates a building environment for ffmpeg
  It downloads all recent codecs and tools and compile them
  It reduces the numerous steps to perfoms in a few lines
  It reduces your time spent to update your old ffmpeg when a new revision is out

## What it is not. 

  It is not a package manager
  You need to have previously installed all compiling dependencies
  They should be pointed out by the autotools of each libraries

## How it works. 

Create the root directory

    mkdir build
    cd build

Download the Makefile

    wget http://github.com/vivienschilis/ffmpeg_bootstrap/raw/master/Makefile
  
Build and download all files

    make bootstrap
  
Apply ffmpeg patches (optional)

If you to apply patches on ffmpeg, put your XX_yourfile_.patch file into the build/patches directory
Use the following syntax to ensure the good order 00_myfirstpath.patch 01_mysecondpath.patch etc...

    make patch
  
    make unpatch # if you what to unpatch in the inverse order
  
Compile codecs and ffmpeg

    make
  
Compile qt-faststart (optional)

    make qtfs
  
Compile segmenter (optional)

    make segmenter

Install all binaries

    make install

Clean all compiling directories

    make clean
  
Clean all environment

    make cleanall