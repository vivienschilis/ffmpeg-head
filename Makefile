PREFIX_DIR=/root/builds/ffmpegdev
CONFIGURE_AND_PREFIX=./configure --prefix=${OLIBS_DIR} 
CONFIGURE_STATIC = ${CONFIGURE_AND_PREFIX} --enable-static --disable-shared
LIB_DIR=${PREFIX_DIR}/libraries
TOOLS_DIR=${PREFIX_DIR}/tools
OLIBS_DIR=${PREFIX_DIR}/olibs
DIST_DIR=${PREFIX_DIR}/dist

FAAC_CODEC=faac-1.28
GSM_CODEC=gsm-1.0-pl13
LAME_CODEC=lame-3.98.4
OGG_CODEC=libogg-1.2.0
THEORA_CODEC=libtheora-1.1.1
VORBIS_CODEC=libvorbis-1.3.1
VPX_CODEC=libvpx
AMR_CODEC=opencore-amr-0.1.2
X264_CODEC=x264
XVID_CODEC=xvidcore/build/generic

FFMPEG_TOOL=ffmpeg

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

FFMPEG_CFLAGS += -I/root/builds/ffmpeg/olibs/include 
FFMPEG_CFLAGS += --static 
FFMPEG_LDFLAGS += -L ${OLIBS_DIR}/lib

CONFIGURE_FFMPEG= ${CONFIGURE_STATIC} ${ENABLE_FFMPEG_CODECS} ${DISABLE_FFMPEG_TOOLS} --extra-cflags="${FFMPEG_CFLAGS}"  --extra-ldflags="${FFMPEG_LDFLAGS}" --prefix=${DIST_DIR}

ALL_LIBS = ${FAAC_CODEC} ${GSM_CODEC} ${LAME_CODEC} ${OGG_CODEC} ${THEORA_CODEC} ${VORBIS_CODEC} ${VPX_CODEC} ${AMR_CODEC} ${X264_CODEC} ${XVID_CODEC}

ALL_TOOLS = ${FFMPEG_TOOL}

all: init faac gsm lame ogg theora vorbis vpx amr x264 xvid ffmpeg

init: 
	mkdir -p ${LIB_DIR}
	mkdir -p ${TOOLS_DIR}
	mkdir -p ${OLIBS_DIR}
	mkdir -p ${DIST_DIR}
	mkdir -p ${OLIBS_DIR}/include
	mkdir -p ${OLIBS_DIR}/include/gsm
	mkdir -p ${OLIBS_DIR}/lib
	mkdir -p ${OLIBS_DIR}/man
	mkdir -p ${OLIBS_DIR}/man/man3
faac: 
	cd ${LIB_DIR}/${FAAC_CODEC} && ${CONFIGURE_STATIC} && make && make install

gsm: 
	cd ${LIB_DIR}/${GSM_CODEC} && make
	cd ${LIB_DIR}/${GSM_CODEC} && cp lib/* ${OLIBS_DIR}/lib
	cd ${LIB_DIR}/${GSM_CODEC} && cp inc/gsm.h ${OLIBS_DIR}/include/gsm/

lame: 
	cd ${LIB_DIR}/${LAME_CODEC} && ${CONFIGURE_STATIC} && make && make install

ogg: 
	cd ${LIB_DIR}/${OGG_CODEC} && ${CONFIGURE_STATIC} && make && make install

theora: 
	cd ${LIB_DIR}/${THEORA_CODEC} && ${CONFIGURE_STATIC} && make && make install

vorbis: 
	cd ${LIB_DIR}/${VORBIS_CODEC} && ${CONFIGURE_STATIC} && make && make install

vpx: 
	cd ${LIB_DIR}/${VPX_CODEC} && ${CONFIGURE_AND_PREFIX} && make && make install

amr: 
	cd ${LIB_DIR}/${AMR_CODEC} && ${CONFIGURE_STATIC} && make && make install

x264: 
	cd ${LIB_DIR}/${X264_CODEC} && ${CONFIGURE_STATIC} && make && make install

xvid: 
	cd ${LIB_DIR}/${XVID_CODEC} && ${CONFIGURE_STATIC} && make && make install

ffmpeg: 
	cd ${TOOLS_DIR}/${FFMPEG_TOOL} && ${CONFIGURE_FFMPEG} && make && make install

clean:
	for i in ${ALL_LIBS}; do cd ${LIB_DIR}/$$i && make clean; done
	for i in ${ALL_TOOLS}; do cd ${TOOLS_DIR}/$$i && make clean; done
	rm -rf ${PREFIX_DIR}/olibs
