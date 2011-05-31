UNAME := $(shell uname -s)
REV := $(shell git rev-list HEAD | wc -l | sed 's/ *//g')

all: init bzip2 zlib yasm faac gsm lame ogg theora vorbis vpx amr x264 xvid ffmpeg segmenter message

TTY_WHITE = \\033[1\;39m
TTY_BLUE = \\033[1\;34m
TTY_GREEN = \\033[1\;32m
TTY_RESET = \\033[0m

#PATH VARIABLES
TOP =$(shell pwd)
SRC_DIR = ${TOP}/src
RUNTIME_DIR = ${TOP}/runtime
DIST_DIR = ${TOP}/dist
PATCH_DIR = ${TOP}/patches
PREFIX_DIR ?= /usr/local

${SRC_DIR}:
	mkdir -p $@

${RUNTIME_DIR}:
	mkdir -p $@

${DIST_DIR}:
	mkdir -p $@

# EXPORT VARIABLES
export LDFLAGS=-L${RUNTIME_DIR}/lib
export CFLAGS=-I${RUNTIME_DIR}/include
export PATH:=${DIST_DIR}/bin:${RUNTIME_DIR}/bin:${PATH}

CONFIGURE_AND_PREFIX = ./configure --prefix=${RUNTIME_DIR}
CONFIGURE_STATIC = ${CONFIGURE_AND_PREFIX} --enable-static --disable-shared

# URL TO DOWNLOAD ALL CODECS ARCHIVES

# LIB SOURCES
GSM_CODEC_URL = http://www.finalmediaplayer.com/downloads/3rdparty/libgsm_1.0.13.orig.tar.gz
GSM_CODEC = gsm-1.0-pl13

FAAC_CODEC_URL = http://downloads.sourceforge.net/faac/faac-1.28.tar.gz
FAAC_CODEC = faac-1.28

FAAD2_CODEC_URL = http://downloads.sourceforge.net/faac/faad2-2.7.tar.gz
FAAD2_CODEC = faad2-2.7

LAME_CODEC_URL = http://downloads.sourceforge.net/project/lame/lame/3.98.4/lame-3.98.4.tar.gz
LAME_CODEC = lame-3.98.4

OGG_CODEC_URL = http://downloads.xiph.org/releases/ogg/libogg-1.2.0.tar.gz
OGG_CODEC = libogg-1.2.0

VORBIS_CODEC_URL = http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.1.tar.gz
VORBIS_CODEC = libvorbis-1.3.1

XVID_CODEC_URL = http://downloads.xvid.org/downloads/xvidcore-1.2.2.tar.gz
XVID_CODEC = xvidcore/build/generic	

AMR_CODEC_URL = http://downloads.sourceforge.net/project/opencore-amr/opencore-amr/0.1.2/opencore-amr-0.1.2.tar.gz
AMR_CODEC = opencore-amr-0.1.2

THEORA_CODEC_URL = http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2
THEORA_CODEC = libtheora-1.1.1

VPX_CODEC_URL = git://review.webmproject.org/libvpx.git
VPX_CODEC = libvpx

X264_CODEC_URL = git://git.videolan.org/x264.git
X264_CODEC = x264

YASM_TOOL_URL = http://www.tortall.net/projects/yasm/releases/yasm-1.1.0.tar.gz
YASM_TOOL = yasm-1.1.0

ZLIB_URL = http://zlib.net/zlib-1.2.5.tar.bz2
ZLIB = zlib-1.2.5

BZIP2_URL = http://bzip.org/1.0.6/bzip2-1.0.6.tar.gz
BZIP2 = bzip2-1.0.6

LIB_SOURCES = ${BZIP2_URL} ${ZLIB_URL} ${YASM_TOOL_URL} ${GSM_CODEC_URL} ${FAAC_CODEC_URL} ${FAAD2_CODEC_URL} ${LAME_CODEC_URL} ${OGG_CODEC_URL} ${VORBIS_CODEC_URL} ${XVID_CODEC_URL} ${AMR_CODEC_URL} ${THEORA_CODEC_URL} ${VPX_CODEC_URL} ${X264_CODEC_URL}

# TOOLS SOURCES
FFMPEG_TOOL = ffmpeg
FFMPEG_TOOL_URL = git://git.videolan.org/ffmpeg.git
SEGMENTER_TOOL_URL = git://github.com/vivienschilis/segmenter.git
SEGMENTER_TOOL = segmenter

TOOLS_SOURCES = ${FFMPEG_TOOL_URL} ${SEGMENTER_TOOL_URL}


# FFMPEG FLAGS
FFMPEG_CFLAGS=--static
FFMPEG_LDFLAGS=

FFMPEG_FEATURES += --enable-pthreads
FFMPEG_FEATURES += --enable-runtime-cpudetect

ENABLED_FFMPEG_CODECS += --enable-postproc
ENABLED_FFMPEG_CODECS += --enable-nonfree
ENABLED_FFMPEG_CODECS += --enable-libx264 
ENABLED_FFMPEG_CODECS += --enable-gpl
ENABLED_FFMPEG_CODECS += --enable-libfaac
ENABLED_FFMPEG_CODECS += --enable-libmp3lame
ENABLED_FFMPEG_CODECS += --enable-libtheora
ENABLED_FFMPEG_CODECS += --enable-libxvid
ENABLED_FFMPEG_CODECS += --enable-libvorbis
ENABLED_FFMPEG_CODECS += --enable-libgsm
ENABLED_FFMPEG_CODECS += --enable-libvpx
ENABLED_FFMPEG_CODECS += --enable-avfilter
ENABLED_FFMPEG_CODECS += --enable-libopencore-amrnb
ENABLED_FFMPEG_CODECS += --enable-libopencore-amrwb
ENABLED_FFMPEG_CODECS += --enable-version3

# ENABLED_FFMPEG_CODECS += --enable-libdirac
# ENABLED_FFMPEG_CODECS += --enable-libvo-aacenc
# ENABLED_FFMPEG_CODECS += --enable-libvo-amrwbenc

DISABLED_FFMPEG_TOOLS += --disable-ffplay
DISABLED_FFMPEG_TOOLS += --disable-ffserver
DISABLED_FFMPEG_TOOLS += --disable-ffprobe
DISABLED_FFMPEG_TOOLS += --disable-network
DISABLED_FFMPEG_TOOLS += --disable-devices
DISABLED_FFMPEG_TOOLS += --disable-doc

CONFIGURE_FFMPEG = ${CONFIGURE_STATIC} ${ENABLED_FFMPEG_CODECS} ${DISABLED_FFMPEG_TOOLS} --extra-cflags="${FFMPEG_CFLAGS}"  --extra-ldflags="${FFMPEG_LDFLAGS}" --bindir=${DIST_DIR}/bin --incdir=${DIST_DIR}/include --libdir=${DIST_DIR}/lib --prefix=${PREFIX_DIR}

ALL_LIBS = ${FAAC_CODEC} ${GSM_CODEC} ${LAME_CODEC} ${OGG_CODEC} ${THEORA_CODEC} ${VORBIS_CODEC} ${VPX_CODEC} ${AMR_CODEC} ${X264_CODEC} ${XVID_CODEC}
ALL_TOOLS = ${FFMPEG_TOOL} ${SEGMENTER_TOOL}

SEGMENTER_GCC = gcc -I${DIST_DIR}/include -o segmenter segmenter.c  -lm -lz -lbz2 -lpthread \
${DIST_DIR}/lib/libswscale.a ${DIST_DIR}/lib/libavdevice.a ${DIST_DIR}/lib/libavformat.a  ${DIST_DIR}/lib/libavcodec.a  ${DIST_DIR}/lib/libavutil.a  ${DIST_DIR}/lib/libavfilter.a  ${RUNTIME_DIR}/lib/libvorbisfile.a ${RUNTIME_DIR}/lib/libfaac.a  ${RUNTIME_DIR}/lib/libtheora.a  ${RUNTIME_DIR}/lib/libvpx.a ${RUNTIME_DIR}/lib/libgsm.a ${RUNTIME_DIR}/lib/libopencore-amrnb.a ${RUNTIME_DIR}/lib/libtheoradec.a  ${RUNTIME_DIR}/lib/libvorbisenc.a ${RUNTIME_DIR}/lib/libx264.a ${RUNTIME_DIR}/lib/libmp3lame.a  ${RUNTIME_DIR}/lib/libopencore-amrwb.a ${RUNTIME_DIR}/lib/libtheoraenc.a  ${RUNTIME_DIR}/lib/libxvidcore.a ${RUNTIME_DIR}/lib/libogg.a ${RUNTIME_DIR}/lib/libvorbis.a


# Helper methods
print_done = \
	echo && echo ${TTY_GREEN}\* ${TTY_WHITE}Done. ${TTY_RESET}

start_compiling_message= \
	echo && echo ${TTY_BLUE}==\> ${TTY_WHITE}Compiling $(1)... ${TTY_RESET}

end_compiling_message= \
	echo ${TTY_GREEN}* ${TTY_WHITE}$(1) has been compiled with success. ${TTY_RESET}

prev_configured_message= \
	echo ${TTY_GREEN}* ${TTY_WHITE}$(1) has been previously configured. ${TTY_RESET}

m_and_mi = touch 'configure.done' && if [ ! -f 'compile.done' ]; then \
	make -j 4 && make install && touch 'compile.done'; \
else \
	echo ${TTY_GREEN}* ${TTY_WHITE}$(1) previously compiled. ${TTY_RESET}; \
fi 

init:
	@echo ${TTY_BLUE}==\> ${TTY_WHITE}Creating directories... ${TTY_RESET}
	mkdir -p ${SRC_DIR}
	mkdir -p ${DIST_DIR}
	mkdir -p ${RUNTIME_DIR}
	mkdir -p ${RUNTIME_DIR}/include
	mkdir -p ${RUNTIME_DIR}/include/gsm
	mkdir -p ${RUNTIME_DIR}/lib
	mkdir -p ${RUNTIME_DIR}/man
	mkdir -p ${RUNTIME_DIR}/man/man3
	@$(call print_done)

bzip2:
	@$(call start_compiling_message, bzip2)
	cd ${SRC_DIR}/${BZIP2} && touch configure.done ; make && make install -n PREFIX=${RUNTIME_DIR};
	@$(call end_compiling_message, bzip2)


zlib:
	@$(call start_compiling_message, zlib)
	@cd ${SRC_DIR}/${ZLIB} && if [ ! -f 'configure.done'  ]; then ./configure --prefix=${RUNTIME_DIR} --static ; else $(call prev_configured_message,zlib); fi
	@cd ${SRC_DIR}/${ZLIB} && grep -v -E 'cp.*SHAREDLIBV' Makefile > Makefile.new; mv Makefile.new Makefile
	@cd ${SRC_DIR}/${ZLIB} && $(call m_and_mi,zlib);
	@$(call end_compiling_message, zlib)


yasm:
	@$(call start_compiling_message, yasm)
	@cd ${SRC_DIR}/${YASM_TOOL} && if [ ! -f 'configure.done'  ]; then ${CONFIGURE_AND_PREFIX}; else $(call prev_configured_message,yasm); fi && $(call m_and_mi,yasm);
	@$(call end_compiling_message,yasm)

faac:
	@$(call start_compiling_message, faac)
	@cd ${SRC_DIR}/${FAAC_CODEC} && if [ ! -f 'configure.done'  ]; then ${CONFIGURE_STATIC}; else $(call prev_configured_message,faac); fi
	@cd ${SRC_DIR}/${FAAC_CODEC} && sed -i -e "s|^char \*strcasestr.*|//\0|" common/mp4v2/mpeg4ip.h
	@cd ${SRC_DIR}/${FAAC_CODEC} && $(call m_and_mi,faac);
	@$(call end_compiling_message,faac)

gsm: 
	@$(call start_compiling_message,gsm)
	@cd ${SRC_DIR}/${GSM_CODEC} && make
	@cd ${SRC_DIR}/${GSM_CODEC} && cp lib/* ${RUNTIME_DIR}/lib
	@cd ${SRC_DIR}/${GSM_CODEC} && cp inc/gsm.h ${RUNTIME_DIR}/include/gsm/
	@$(call end_compiling_message,gsm)

lame: 
	@$(call start_compiling_message,lame)
	@cd ${SRC_DIR}/${LAME_CODEC} && if [ ! -f 'configure.done'  ]; then ${CONFIGURE_STATIC}; else $(call prev_configured_message,lame); fi && $(call m_and_mi,lame);
	@$(call end_compiling_message,lame)
	
ogg: 
	@$(call start_compiling_message,ogg)
	@cd ${SRC_DIR}/${OGG_CODEC} && if [ ! -f 'configure.done'  ]; then ${CONFIGURE_STATIC}; else $(call prev_configured_message,ogg); fi && $(call m_and_mi,ogg);
	@$(call end_compiling_message,ogg)

theora: 
	@$(call start_compiling_message,theora)
	@cd ${SRC_DIR}/${THEORA_CODEC} && if [ ! -f 'configure.done'  ]; then ${CONFIGURE_STATIC}; else $(call prev_configured_message,theora); fi && $(call m_and_mi,theora);
	@$(call end_compiling_message,theora)

vorbis: 
	@$(call start_compiling_message, vorbis)
	@cd ${SRC_DIR}/${VORBIS_CODEC} && if [ ! -f 'configure.done'  ]; then ${CONFIGURE_STATIC}; else $(call prev_configured_message,vorbis); fi && $(call m_and_mi,vorbis);
	@$(call end_compiling_message,vorbis)

vpx: 
	@$(call start_compiling_message,vpx)
	@cd ${SRC_DIR}/${VPX_CODEC} && if [ ! -f 'configure.done'  ]; then ${CONFIGURE_AND_PREFIX}; else $(call prev_configured_message,vpx); fi && $(call m_and_mi,vpx);
	@$(call end_compiling_message,vpx)
	
amr: 
	@$(call start_compiling_message,amr)
	@cd ${SRC_DIR}/${AMR_CODEC} && if [ ! -f 'configure.done'  ]; then ${CONFIGURE_STATIC}; else $(call prev_configured_message,amr); fi && $(call m_and_mi,amr);
	@$(call end_compiling_message,amr)
	
x264: 
	@$(call start_compiling_message,x264)
	@cd ${SRC_DIR}/${X264_CODEC} && if [ ! -f 'configure.done'  ]; then ${CONFIGURE_STATIC}; else $(call prev_configured_message,x264); fi && $(call m_and_mi,x264);
	@$(call end_compiling_message,x264)

xvid: 
	@$(call start_compiling_message,xvid)
	@cd ${SRC_DIR}/${XVID_CODEC} && if [ ! -f 'configure.done'  ]; then ${CONFIGURE_STATIC} ${XVID_CONFIGURE_ARGS}; else $(call prev_configured_message,xvid); fi && $(call m_and_mi,xvid);
	@$(call end_compiling_message,xvid)

ffmpeg: 
	@$(call start_compiling_message,ffmpeg)
	@cd ${SRC_DIR}/${FFMPEG_TOOL} && if [ ! -f 'configure.done'  ]; then ${CONFIGURE_FFMPEG}; else $(call prev_configured_message,ffmpeg); fi && $(call m_and_mi,ffmpeg);
	@$(call end_compiling_message,ffmpeg)

qtfs: 
	@$(call start_compiling_message,qt-faststart)
	@cd ${SRC_DIR}/${FFMPEG_TOOL}/tools && gcc qt-faststart.c -o qt-faststart && cp qt-faststart ${DIST_DIR}/bin/qt-faststart
	@$(call end_compiling_message,qt-faststart)

segmenter:
	@$(call start_compiling_message,segmenter)
	cd ${SRC_DIR}/segmenter && ${SEGMENTER_GCC} && cp segmenter ${DIST_DIR}/bin/segmenter
	@$(call end_compiling_message,segmenter)
	
# BOOTSTRAP A NEW FFMPEG BUILD ENV FROM SCRATCH

# DOWNLOAD METHODS
download_archive = sh ../fetch_url $1
clone_from_svn = svn checkout $1

bootstrap: distclean init_bootstrap fetch

patch:
	@echo ${TTY_BLUE}==\> ${TTY_WHITE}Patching ffmpeg $(1)... ${TTY_RESET}
	@cd ${PATCH_DIR} && for diff in `ls *.patch`; do echo \* $$diff && patch -N -d ${SRC_DIR}/ffmpeg -p0 -i ${PATCH_DIR}/$$diff; done
	
unpatch:
	@echo ${TTY_BLUE}==\> ${TTY_WHITE}Unpatching ffmpeg $(1)... ${TTY_RESET}
	@cd ${PATCH_DIR} && for diff in `ls -r *.patch`; do echo \* $$diff && patch -R -d ${SRC_DIR}/ffmpeg -p0 -i ${PATCH_DIR}/$$diff; done

init_bootstrap:
	@mkdir -p ${SRC_DIR}
	@mkdir -p ${PATCH_DIR}
	@mkdir -p ${SRC_DIR}

fetch:
	@echo && echo ${TTY_BLUE}==\>${TTY_WHITE} Downloading sources... ${TTY_RESET}
	@for i in ${LIB_SOURCES}; do cd ${SRC_DIR} && $(call download_archive, $$i) && $(call print_done) && echo; done
	@echo  && echo ${TTY_BLUE}==\>${TTY_WHITE} Downloading tools... ${TTY_RESET}
	@for i in ${TOOLS_SOURCES}; do cd ${SRC_DIR} && $(call download_archive,$$i) && $(call print_done) && echo; done
	
	@echo ${TTY_GREEN}*${TTY_WHITE} All sources are ready to be compiled.${TTY_RESET}

install:
	@echo ${TTY_BLUE}==\>${TTY_WHITE} Installing all binaries... ${TTY_RESET}
	@mkdir -p "${PREFIX_DIR}/bin"
	@cp ${DIST_DIR}/bin/* ${PREFIX_DIR}/bin
	
message:
	@echo
	@echo "---------------------------------------------------------------"
	@echo " FFMPEG has been successfully built."
	@echo " To install them on your system, you can run '(sudo) make install'"
	@echo "---------------------------------------------------------------"
	@echo

clean:
	@echo && echo ${TTY_BLUE}==\>${TTY_WHITE} Cleaning compiled directories ${TTY_RESET}
	@for i in ${ALL_LIBS}; do cd ${SRC_DIR}/$$i && make clean && rm -f 'compile.done' && rm -f 'configure.done'; done
	@for i in ${ALL_TOOLS}; do cd ${SRC_DIR}/$$i && make clean && rm -f 'compile.done' && rm -f 'configure.done'; done
	@rm -rf ${RUNTIME_DIR}
	@$(call print_done)

distclean:
	@echo ${TTY_BLUE}==\>${TTY_WHITE} Removing all download sources ${TTY_RESET}
	rm -rf ${SRC_DIR}
	rm -rf ${RUNTIME_DIR}
	rm -rf ${DIST_DIR}
	@$(call print_done)

### TODO
# System check before compiling
# Recommend home-brew for Mac OS
