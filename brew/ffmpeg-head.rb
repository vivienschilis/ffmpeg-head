require 'formula'

class FfmpegHead < Formula
  head 'git://github.com/vivienschilis/ffmpeg-head.git', :using => :git
  
  def install
    ENV.deparallelize
    ENV['PREFIX_DIR']=prefix
    
    system 'make bootstrap'
    system "make"
    system "make install"
  end  
end
