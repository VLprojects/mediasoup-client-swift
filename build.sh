#!/bin/bash

# Stop script on errors.
set -e

# Define working directories.
export PROJECT_DIR=$(pwd)
echo "PROJECT_DIR = $PROJECT_DIR"
export WORK_DIR=$PROJECT_DIR/Mediasoup/dependencies
echo "WORK_DIR = $WORK_DIR"
export BUILD_DIR=$(pwd)/build
echo "BUILD_DIR = $BUILD_DIR"
export OUTPUT_DIR=$(pwd)/bin
echo "OUTPUT_DIR = $OUTPUT_DIR"
export PATCHES_DIR=$(pwd)/patches
echo "PATCHES_DIR = $PATCHES_DIR"
export WEBRTC_DIR=$PROJECT_DIR/Mediasoup/dependencies/webrtc/src
echo "WEBRTC_DIR = $WEBRTC_DIR"

echo -e "Clear old build artifacts? (Y|n): \c"
read -n 1 INPUT_STRING
echo ""
case $INPUT_STRING in
	n|N)
		;;
	*)
		declare -a COMPONENTS=(
			"$OUTPUT_DIR"
			"$BUILD_DIR"
		)
		for COMPONENT in "${COMPONENTS[@]}"
		do
			if [ -d $COMPONENT ]
			then
				echo "Removing dir $COMPONENT"
				rm -rf $COMPONENT
			fi
		done

		mkdir -p $OUTPUT_DIR
		echo 'OUTPUT_DIR created'

		mkdir -p $BUILD_DIR
		echo 'BUILD_DIR created'
		;;
esac

echo -e "Refetch dependencies? (y|N): \c"
read -n 1 INPUT_STRING
echo ""
case $INPUT_STRING in
	y|Y)
		echo 'Cloning libmediasoupclient'
		cd $WORK_DIR
		rm -rf libmediasoupclient
		git clone https://github.com/VLprojects/libmediasoupclient.git

		echo 'Cloning depot_tools'
		cd $WORK_DIR
		git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
		export PATH=$WORK_DIR/depot_tools:$PATH

		echo 'Cloning WebRTC'
		mkdir -p $WORK_DIR/webrtc
		cd $WORK_DIR/webrtc
		fetch --nohooks webrtc_ios
		gclient sync
		cd $WORK_DIR/webrtc/src
		git checkout -b m93 refs/remotes/branch-heads/4577
		gclient sync

		# Apply patches to make it buildable with Xcode.
		patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/builtin_audio_decoder_factory.patch
		patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/builtin_audio_encoder_factory.patch
		patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/sdp_video_format_utils.patch
		patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/sdk_BUILD.patch
		patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/abseil_optional.patch
		patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/RTCPeerConnectionFactoryBuilder.patch
		patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/audio_device_module_h.patch
		patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/audio_device_module_mm.patch
		patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/objc_video_decoder_factory_h.patch
		patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/objc_video_encoder_factory_h.patch
		patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/video_decoder_factory_h.patch
		patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/video_encoder_factory_h.patch
		;;
	*)
		export PATH=$WORK_DIR/depot_tools:$PATH
		cd $WEBRTC_DIR
		git restore rtc_base/byte_order.h
		;;
esac

echo 'Building WebRTC'
cd $WEBRTC_DIR

gn gen $BUILD_DIR/WebRTC/device/arm64 --ide=xcode --args='target_os="ios" target_environment="device" target_cpu="arm64" ios_deployment_target="13.0" ios_enable_code_signing=false use_xcode_clang=true is_component_build=false rtc_include_tests=false is_debug=false rtc_libvpx_build_vp9=false enable_ios_bitcode=false use_goma=false rtc_enable_symbol_export=true rtc_include_builtin_audio_codecs=true rtc_include_builtin_video_codecs=true rtc_enable_protobuf=false use_rtti=true use_custom_libcxx=false enable_dsyms=true enable_stripping=true treat_warnings_as_errors=false'
gn gen $BUILD_DIR/WebRTC/simulator/x64 --ide=xcode --args='target_os="ios" target_environment="simulator" target_cpu="x64" ios_deployment_target="13.0" ios_enable_code_signing=false use_xcode_clang=true is_component_build=false rtc_include_tests=false is_debug=false rtc_libvpx_build_vp9=false enable_ios_bitcode=false use_goma=false rtc_enable_symbol_export=true rtc_include_builtin_audio_codecs=true rtc_include_builtin_video_codecs=true rtc_enable_protobuf=false use_rtti=true use_custom_libcxx=false enable_dsyms=true enable_stripping=true treat_warnings_as_errors=false'
gn gen $BUILD_DIR/WebRTC/simulator/arm64 --ide=xcode --args='target_os="ios" target_environment="simulator" target_cpu="arm64" ios_deployment_target="13.0" ios_enable_code_signing=false use_xcode_clang=true is_component_build=false rtc_include_tests=false is_debug=false rtc_libvpx_build_vp9=false enable_ios_bitcode=false use_goma=false rtc_enable_symbol_export=true rtc_include_builtin_audio_codecs=true rtc_include_builtin_video_codecs=true rtc_enable_protobuf=false use_rtti=true use_custom_libcxx=false enable_dsyms=true enable_stripping=true treat_warnings_as_errors=false'

cd $BUILD_DIR/WebRTC
ninja -C device/arm64 sdk
ninja -C simulator/x64 sdk
ninja -C simulator/arm64 sdk

cd $BUILD_DIR/WebRTC
rm -rf simulator/WebRTC.framework
cp -R simulator/arm64/WebRTC.framework simulator/WebRTC.framework
rm simulator/WebRTC.framework/WebRTC
lipo -create \
	simulator/arm64/WebRTC.framework/WebRTC \
	simulator/x64/WebRTC.framework/WebRTC \
	-output simulator/WebRTC.framework/WebRTC

cd $BUILD_DIR/WebRTC
rm -rf $OUTPUT_DIR/WebRTC.xcframework
xcodebuild -create-xcframework \
	-framework device/arm64/WebRTC.framework \
	-framework simulator/WebRTC.framework \
	-output $OUTPUT_DIR/WebRTC.xcframework

cd $WORK_DIR

# Build mediasoup-client-ios
cmake . -B$BUILD_DIR/libmediasoupclient/device/arm64 \
	-DLIBWEBRTC_INCLUDE_PATH=$WEBRTC_DIR \
	-DLIBWEBRTC_BINARY_PATH=$BUILD_DIR/WebRTC/device/arm64/WebRTC.framework/WebRTC \
	-DMEDIASOUP_LOG_TRACE=ON \
	-DMEDIASOUP_LOG_DEV=ON \
	-DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
	-DLIBSDPTRANSFORM_BUILD_TESTS=OFF \
	-DIOS_SDK=iphone \
	-DCMAKE_OSX_DEPLOYMENT_TARGET=14 \
	-DIOS_ARCHS="arm64" \
	-DPLATFORM=OS64 \
	-DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
make -C $BUILD_DIR/libmediasoupclient/device/arm64

cmake . -B$BUILD_DIR/libmediasoupclient/simulator/x64 \
	-DLIBWEBRTC_INCLUDE_PATH=$WEBRTC_DIR \
	-DLIBWEBRTC_BINARY_PATH=$BUILD_DIR/WebRTC/simulator/x64/WebRTC.framework/WebRTC \
	-DMEDIASOUP_LOG_TRACE=ON \
	-DMEDIASOUP_LOG_DEV=ON \
	-DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
	-DLIBSDPTRANSFORM_BUILD_TESTS=OFF \
	-DIOS_SDK=iphonesimulator \
	-DCMAKE_OSX_DEPLOYMENT_TARGET=14 \
	-DIOS_ARCHS="x86_64" \
	-DPLATFORM=SIMULATOR64 \
	-DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
make -C $BUILD_DIR/libmediasoupclient/simulator/x64

cmake . -B$BUILD_DIR/libmediasoupclient/simulator/arm64 \
	-DLIBWEBRTC_INCLUDE_PATH=$WEBRTC_DIR \
	-DLIBWEBRTC_BINARY_PATH=$BUILD_DIR/WebRTC/simulator/arm64/WebRTC.framework/WebRTC \
	-DMEDIASOUP_LOG_TRACE=ON \
	-DMEDIASOUP_LOG_DEV=ON \
	-DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
	-DLIBSDPTRANSFORM_BUILD_TESTS=OFF \
	-DIOS_SDK=iphonesimulator \
	-DCMAKE_OSX_DEPLOYMENT_TARGET=14 \
	-DIOS_ARCHS="arm64"\
	-DPLATFORM=SIMULATORARM64 \
	-DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
make -C $BUILD_DIR/libmediasoupclient/simulator/arm64

# Create a FAT libmediasoup / libsdptransform library
mkdir -p $BUILD_DIR/libmediasoupclient/simulator/fat
lipo -create \
	$BUILD_DIR/libmediasoupclient/simulator/x64/libmediasoupclient/libmediasoupclient.a \
	$BUILD_DIR/libmediasoupclient/simulator/arm64/libmediasoupclient/libmediasoupclient.a \
	-output $BUILD_DIR/libmediasoupclient/simulator/fat/libmediasoupclient.a
lipo -create \
	$BUILD_DIR/libmediasoupclient/simulator/x64/libmediasoupclient/libsdptransform/libsdptransform.a \
	$BUILD_DIR/libmediasoupclient/simulator/arm64/libmediasoupclient/libsdptransform/libsdptransform.a \
	-output $BUILD_DIR/libmediasoupclient/simulator/fat/libsdptransform.a
xcodebuild -create-xcframework \
	-library $BUILD_DIR/libmediasoupclient/device/arm64/libmediasoupclient/libmediasoupclient.a \
	-library $BUILD_DIR/libmediasoupclient/simulator/fat/libmediasoupclient.a \
	-output $OUTPUT_DIR/mediasoupclient.xcframework
xcodebuild -create-xcframework \
	-library $BUILD_DIR/libmediasoupclient/device/arm64/libmediasoupclient/libsdptransform/libsdptransform.a \
	-library $BUILD_DIR/libmediasoupclient/simulator/fat/libsdptransform.a \
	-output $OUTPUT_DIR/sdptransform.xcframework

cp $PATCHES_DIR/byte_order.h $WORK_DIR/webrtc/src/rtc_base/
open $PROJECT_DIR/Mediasoup.xcodeproj
