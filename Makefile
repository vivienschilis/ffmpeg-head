#PATH VARIABLES
UNAME := $(shell uname -s)

TTY_WHITE = \\033[1\;39m
TTY_BLUE = \\033[1\;34m
TTY_GREEN = \\033[1\;32m
TTY_RESET = \\033[0m

PREFIX_DIR = ${PWD}
CONFIGURE_AND_PREFIX = ./configure --prefix=${OLIBS_DIR}
CONFIGURE_STATIC = ${CONFIGURE_AND_PREFIX} --enable-static --disable-shared
LIB_DIR = ${PREFIX_DIR}/libraries
TOOLS_DIR = ${PREFIX_DIR}/tools
OLIBS_DIR = ${PREFIX_DIR}/olibs
DIST_DIR = ${PREFIX_DIR}/dist
ARCH_DIR = ${PREFIX_DIR}/archives

# URL TO DOWNLOAD ALL CODECS ARCHIVES

# TARGZ URL
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

ifeq ($(UNAME), Darwin)
	XVID_CODEC_URL = http://downloads.xvid.org/downloads/xvidcore-1.1.3.tar.gz
	XVID_CODEC = xvidcore-1.1.3/build/generic
	XVID_CONFIGURE_ARGS = --disable-assembly --disable-mmx
else
	XVID_CODEC_URL = http://downloads.xvid.org/downloads/xvidcore-1.2.2.tar.gz
	XVID_CODEC = xvidcore/build/generic	
endif

AMR_CODEC_URL = http://downloads.sourceforge.net/project/opencore-amr/opencore-amr/0.1.2/opencore-amr-0.1.2.tar.gz
AMR_CODEC = opencore-amr-0.1.2

TARGZ_SOURCES = ${GSM_CODEC_URL} ${FAAC_CODEC_URL} ${FAAD2_CODEC_URL} ${LAME_CODEC_URL} ${OGG_CODEC_URL} ${VORBIS_CODEC_URL} ${XVID_CODEC_URL} ${AMR_CODEC_URL}

# TARBZ2 URL
THEORA_CODEC_URL = http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2
THEORA_CODEC = libtheora-1.1.1

TARBZ2_SOURCES = ${THEORA_CODEC_URL}

## GIT
VPX_CODEC_URL = git://review.webmproject.org/libvpx.git
VPX_CODEC = libvpx

X264_CODEC_URL = git://git.videolan.org/x264.git
X264_CODEC = x264

GIT_SOURCES = ${VPX_CODEC_URL} ${X264_CODEC_URL}

# TOOLS
FFMPEG_TOOL=ffmpeg
FFMPEG_TOOL_URL="svn://svn.ffmpeg.org/ffmpeg/trunk ffmpeg"

TOOLS_SVN_SOURCES = ${FFMPEG_TOOL_URL}

ENABLE_FFMPEG_CODECS += --enable-postproc
ENABLE_FFMPEG_CODECS += --enable-nonfree
ENABLE_FFMPEG_CODECS += --enable-libx264 
ENABLE_FFMPEG_CODECS += --enable-gpl
ENABLE_FFMPEG_CODECS += --enable-libfaac
ENABLE_FFMPEG_CODECS += --enable-libmp3lame
ENABLE_FFMPEG_CODECS += --enable-libtheora
ENABLE_FFMPEG_CODECS += --enable-libxvid
ENABLE_FFMPEG_CODECS += --enable-libvorbis
ENABLE_FFMPEG_CODECS += --enable-libgsm
ENABLE_FFMPEG_CODECS += --enable-libvpx
ENABLE_FFMPEG_CODECS += --enable-avfilter
ENABLE_FFMPEG_CODECS += --enable-avfilter-lavf
ENABLE_FFMPEG_CODECS += --enable-libopencore-amrnb
ENABLE_FFMPEG_CODECS += --enable-libopencore-amrwb
ENABLE_FFMPEG_CODECS += --enable-version3

DISABLE_FFMPEG_TOOLS += --disable-ffplay
DISABLE_FFMPEG_TOOLS += --disable-ffserver 
DISABLE_FFMPEG_TOOLS += --disable-ffprobe

FFMPEG_CFLAGS += -I${OLIBS_DIR}/include
FFMPEG_CFLAGS += --static 
FFMPEG_LDFLAGS += -L${OLIBS_DIR}/lib

CONFIGURE_FFMPEG = ${CONFIGURE_STATIC} ${ENABLE_FFMPEG_CODECS} ${DISABLE_FFMPEG_TOOLS} --extra-cflags="${FFMPEG_CFLAGS}"  --extra-ldflags="${FFMPEG_LDFLAGS}" --prefix=${DIST_DIR}

ALL_LIBS = ${FAAC_CODEC} ${GSM_CODEC} ${LAME_CODEC} ${OGG_CODEC} ${THEORA_CODEC} ${VORBIS_CODEC} ${VPX_CODEC} ${AMR_CODEC} ${X264_CODEC} ${XVID_CODEC}

ALL_TOOLS = ${FFMPEG_TOOL}

all: init faac gsm lame ogg theora vorbis vpx amr x264 xvid ffmpeg message

message:
	@echo
	@echo "---------------------------------------------------------------"
	@echo " FFMPEG has been successfully built."
	@echo
	@echo " * Binaries are currently located in the '$(DIST_DIR)/bin' directory"
	@echo " * To install them on your system, you can run 'make install'"
	@echo "---------------------------------------------------------------"
	@echo

# Helper methods
print_done = \
	echo && echo ${TTY_GREEN}\* ${TTY_WHITE}Done. ${TTY_RESET}

start_compiling_message= \
	echo && echo ${TTY_BLUE}==\> ${TTY_WHITE}Compiling $(1)... ${TTY_RESET}

end_compiling_message= \
	echo ${TTY_GREEN}* ${TTY_WHITE}$(1) has been compiled with success. ${TTY_RESET}

m_and_mi = make && make install

init: 
	@echo ${TTY_BLUE}==\> ${TTY_WHITE}Creating directories... ${TTY_RESET}
	mkdir -p ${TOOLS_DIR}
	mkdir -p ${OLIBS_DIR}
	mkdir -p ${DIST_DIR}
	mkdir -p ${OLIBS_DIR}/include
	mkdir -p ${OLIBS_DIR}/include/gsm
	mkdir -p ${OLIBS_DIR}/lib
	mkdir -p ${OLIBS_DIR}/man
	mkdir -p ${OLIBS_DIR}/man/man3
	@$(call print_done)

faac: 
	@$(call start_compiling_message, faac)
	@cd ${LIB_DIR}/${FAAC_CODEC} && ${CONFIGURE_STATIC} && $(call m_and_mi)
	@$(call end_compiling_message, faac)

gsm: 
	@$(call start_compiling_message, gsm)
	@cd ${LIB_DIR}/${GSM_CODEC} && make
	@cd ${LIB_DIR}/${GSM_CODEC} && cp lib/* ${OLIBS_DIR}/lib
	@cd ${LIB_DIR}/${GSM_CODEC} && cp inc/gsm.h ${OLIBS_DIR}/include/gsm/
	@$(call end_compiling_message, gsm)

lame: 
	@$(call start_compiling_message, lame)
	@cd ${LIB_DIR}/${LAME_CODEC} && ${CONFIGURE_STATIC} && $(call m_and_mi)
	@$(call end_compiling_message, lame)
	
ogg: 
	@$(call start_compiling_message, ogg)
	@cd ${LIB_DIR}/${OGG_CODEC} && ${CONFIGURE_STATIC} && $(call m_and_mi)
	@$(call end_compiling_message, ogg)

theora: 
	@$(call start_compiling_message, theora)
	@cd ${LIB_DIR}/${THEORA_CODEC} && ${CONFIGURE_STATIC} && $(call m_and_mi)
	@$(call end_compiling_message, theora)

vorbis: 
	@$(call start_compiling_message, vorbis)
	@cd ${LIB_DIR}/${VORBIS_CODEC} && ${CONFIGURE_STATIC} && $(call m_and_mi)
	@$(call end_compiling_message, vorbis)

vpx: 
	@$(call start_compiling_message, vpx)
	@cd ${LIB_DIR}/${VPX_CODEC} && ${CONFIGURE_AND_PREFIX} && $(call m_and_mi)
	@$(call end_compiling_message, vpx)
	
amr: 
	@$(call start_compiling_message, amr)
	@cd ${LIB_DIR}/${AMR_CODEC} && ${CONFIGURE_STATIC} && $(call m_and_mi)
	@$(call end_compiling_message, amr)
	

x264: 
	@$(call start_compiling_message, x264)
	@cd ${LIB_DIR}/${X264_CODEC} && ${CONFIGURE_STATIC} && $(call m_and_mi)
	@$(call end_compiling_message, x264)

xvid: 
	@$(call start_compiling_message, xvid)
	@cd ${LIB_DIR}/${XVID_CODEC} && ${CONFIGURE_STATIC} ${XVID_CONFIGURE_ARGS} && $(call m_and_mi)
	@$(call end_compiling_message, xvid)

ffmpeg: 
	@$(call start_compiling_message, ffmpeg)
	@cd ${TOOLS_DIR}/${FFMPEG_TOOL} && ${CONFIGURE_FFMPEG} && $(call m_and_mi)
	@$(call end_compiling_message, ffmpeg)


# BOOTSTRAP A NEW FFMPEG BUILD ENV FROM SCRATCH

# DOWNLOAD METHODS
download_archive = cd ${ARCH_DIR} && wget $(1)
clone_from_git = git clone $(1)
clone_from_svn = svn checkout $(1)

bootstrap: init_bootstrap cleanall download_sources

init_bootstrap:
	@mkdir -p ${ARCH_DIR}
	@mkdir -p ${LIB_DIR}

download_sources:
	@echo && echo ${TTY_BLUE}==\>${TTY_WHITE} Downloading sources... ${TTY_RESET}
	
	@for i in ${TARGZ_SOURCES}; do $(call download_archive,$$i) && $(call print_done) && echo; done
	@for i in ${TARBZ2_SOURCES}; do $(call download_archive,$$i) && $(call print_done) && echo; done	
	@for i in ${GIT_SOURCES}; do cd ${LIB_DIR} && $(call clone_from_git,$$i) && $(call print_done) && echo; done
	
	@echo  && echo ${TTY_BLUE}==\>${TTY_WHITE} Unarchiving sources... ${TTY_RESET}
	@cd ${ARCH_DIR} && for file in `ls *.tar.gz`; do  cd ${LIB_DIR} && tar -zxvf ${ARCH_DIR}/$$file && $(call print_done) && echo; done
	@cd ${ARCH_DIR} && for file in `ls *.tar.bz2`; do  cd ${LIB_DIR} && tar -xjvf ${ARCH_DIR}/$$file && $(call print_done) && echo; done	

	@echo  && echo ${TTY_BLUE}==\>${TTY_WHITE} Downloading tools... ${TTY_RESET}
	@for i in ${TOOLS_SVN_SOURCES}; do cd ${TOOLS_DIR} && $(call clone_from_svn,$$i) && $(call print_done) && echo; done
	
	@echo ${TTY_GREEN}*${TTY_WHITE} All sources are ready to be compiled.${TTY_RESET}

cleanall:
	@echo ${TTY_BLUE}==\>${TTY_WHITE} Removing all download sources ${TTY_RESET}
	rm -rf ${PREFIX_DIR}/archives/*
	rm -rf ${PREFIX_DIR}/libraries/*
	@$(call print_done)
	
clean:
	@echo && echo ${TTY_BLUE}==\>${TTY_WHITE} Cleaning compiled directories ${TTY_RESET}
	@for i in ${ALL_LIBS}; do cd ${LIB_DIR}/$$i && make clean; done
	@for i in ${ALL_TOOLS}; do cd ${TOOLS_DIR}/$$i && make clean; done
	@rm -rf ${PREFIX_DIR}/olibs/*
	@$(call print_done)
