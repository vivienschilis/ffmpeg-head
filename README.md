# FFMPEG bootstrap

Build ffmpeg, qt-faststart and segmenter with its dependencies statically.

    git clone git://github.com/vivienschilis/ffmpeg_bootstrap.git
    cd ffmpeg_bootstrap
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

Clean all libraries

    make clean
  
Clean all environment

    make cleanall
    
Brew 

    brew install https://raw.github.com/vivienschilis/ffmpeg-head/master/brew/ffmpeg.rbn --HEAD