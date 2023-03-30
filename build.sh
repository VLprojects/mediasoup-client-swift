#!/bin/bash

# Stop script on errors.
set -e

# Check build time dependencies.
if ! command -v python &> /dev/null
then
	echo 'python could not be found'
	echo 'try next steps:'
	echo '  * run "brew install pyenv"'
	echo '  * run "pyenv install --list" and choose a recent 3.x version say 3.11.2'
	echo '  * run "pyenv install 3.11.2"'
	echo '  * run "pyenv global 3.11.2"'
	echo $'  * run "echo \'eval "$(pyenv init --path)"\' >> ~/.zshrc"'
	exit
fi
if ! command -v cmake &> /dev/null
then
	echo 'cmake could not be found'
	echo 'try next steps:'
	echo '  * run "brew install cmake"'
	exit
fi

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

function clearArtifacts() {
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
}

while true
do
	read -n 1 -p "Clear old build artifacts? (Y|n): " INPUT_STRING
	# echo ""
	case $INPUT_STRING in
		n|N)
			echo ""
			break
			;;
		y|Y|"")
			echo ""
			clearArtifacts
			break
			;;
		*)
			echo -ne "\r\033[0K\r"
			tput bel
			;;
	esac
done

function refetchLibmediasoupclient() {
	echo 'Cloning libmediasoupclient'
	cd $WORK_DIR
	rm -rf libmediasoupclient
	git clone -b vl-3.4.0.0 --depth 1 https://github.com/VLprojects/libmediasoupclient.git
}

if [ -d $WORK_DIR/libmediasoupclient ]
then
	echo "libmediasoupclient is already on disk"
	while true
	do
		read -n 1 -p "Refetch libmediasoupclient (y|N): " INPUT_STRING
		case $INPUT_STRING in
			n|N|"")
				echo ""
				break
				;;
			y|Y)
				echo ""
				refetchLibmediasoupclient
				break
				;;
			*)
				echo -ne "\r\033[0K\r"
				tput bel
				;;
		esac
	done
else
	refetchLibmediasoupclient
fi

function refetchDepotTools() {
	echo 'Cloning depot_tools'
	cd $WORK_DIR
	rm -rf depot_tools
	git clone --depth 1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
}

if [ -d $WORK_DIR/depot_tools ]
then
	echo "depot_tools is already on disk"
	while true
	do
		read -n 1 -p "Refetch depot_tools (y|N): " INPUT_STRING
		echo ""
		case $INPUT_STRING in
			n|N|"")
				break
				;;
			y|Y)
				refetchDepotTools
				break
				;;
			*)
				tput bel
				;;
		esac
	done
else
	refetchDepotTools
fi

export PATH=$WORK_DIR/depot_tools:$PATH

function patchWebRTC() {
	echo 'Patching WebRTC for iOS platform support'
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
	patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/BUILD_gn.patch
}

function refetchWebRTC() {
	echo 'Cloning WebRTC'
	rm -rf $WORK_DIR/webrtc
	mkdir -p $WORK_DIR/webrtc
	cd $WORK_DIR/webrtc

	export DEPOT_TOOLS_UPDATE=0
	gclient root
	gclient config --spec \
'solutions = [{
	"name": "src",
	"url": "https://webrtc.googlesource.com/src.git",
	"deps_file": "DEPS",
	"managed": False,
	"custom_deps": {},
}]
target_os = ["ios"]'

	# This command fetches only one specific WebRTC version.
	gclient sync --no-history --revision src@branch-heads/4606

	# Fetch all possible WebRTC versions so you can switch between them.
	# Takes longer time and more disk space.
	# gclient sync --nohooks --with_branch_heads --with_tags

	# Checkout a new version for the first time
	# git checkout -b m94 refs/remotes/branch-heads/4606

	# Switch to WebRTC version that already was checked out previously.
	# git checkout m94

	# Run hooks after switching between WebRTC versions.
	# cd $WORK_DIR/webrtc/src
	# gclient sync --no-history -D
}

function resetWebRTC() {
	cd $WORK_DIR/webrtc/src
	git reset --hard
	
	cd $WORK_DIR/webrtc/src/third_party
	git reset --hard
}

if [ -d $WORK_DIR/webrtc ]
then
	echo "WebRTC is already on disk"
	while true
	do
		read -n 1 -p "Refetch WebRTC? (f)ull clone | (r)eset local changes | (N)o: " INPUT_STRING
		echo ""
		case $INPUT_STRING in
			n|N|"")
				break
				;;
			f|F)
				refetchWebRTC
				patchWebRTC
				break
				;;
			r|R)
				resetWebRTC
				patchWebRTC
				break
				;;
			*)
				tput bel
				;;
		esac
	done
else
	refetchWebRTC
	patchWebRTC
fi

# This patch should be applied only after WebRTC is already built.
cd $WEBRTC_DIR
git restore rtc_base/byte_order.h

echo 'Building WebRTC'
cd $WEBRTC_DIR

gn_arguments=(
	'target_os="ios"'
	'ios_deployment_target="13.0"'
	'ios_enable_code_signing=false'
	'use_xcode_clang=true'
	'is_component_build=false'
	'rtc_include_tests=false'
	'is_debug=false'
	'rtc_libvpx_build_vp9=false'
	'enable_ios_bitcode=false'
	'use_goma=false'
	'rtc_enable_symbol_export=true'
	'rtc_include_builtin_audio_codecs=true'
	'rtc_include_builtin_video_codecs=true'
	'rtc_enable_protobuf=false'
	'use_rtti=true'
	'use_custom_libcxx=false'
	'enable_dsyms=true'
	'enable_stripping=true'
	'treat_warnings_as_errors=false'
)

for str in ${gn_arguments[@]}; do
	gn_args+=" ${str}"
done
platform_args='target_environment="device" target_cpu="arm64"'
gn gen $BUILD_DIR/WebRTC/device/arm64 --ide=xcode --args="${platform_args}${gn_args}"
platform_args='target_environment="simulator" target_cpu="x64"'
gn gen $BUILD_DIR/WebRTC/simulator/x64 --ide=xcode --args="${platform_args}${gn_args}"
platform_args='target_environment="simulator" target_cpu="arm64"'
gn gen $BUILD_DIR/WebRTC/simulator/arm64 --ide=xcode --args="${platform_args}${gn_args}"

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

lmsc_cmake_arguments=(
	"-DLIBWEBRTC_INCLUDE_PATH=$WEBRTC_DIR"
	'-DMEDIASOUP_LOG_TRACE=ON'
	'-DMEDIASOUP_LOG_DEV=ON'
	'-DCMAKE_CXX_FLAGS="-fvisibility=hidden"'
	'-DLIBSDPTRANSFORM_BUILD_TESTS=OFF'
	'-DCMAKE_OSX_DEPLOYMENT_TARGET=14'
)
for str in ${lmsc_cmake_arguments[@]}; do
	lmsc_cmake_args+=" ${str}"
done

# Build mediasoup-client-ios
cmake . -B $BUILD_DIR/libmediasoupclient/device/arm64 \
	${lmsc_cmake_args} \
	-DLIBWEBRTC_BINARY_PATH=$BUILD_DIR/WebRTC/device/arm64/WebRTC.framework/WebRTC \
	-DIOS_SDK=iphone \
	-DIOS_ARCHS="arm64" \
	-DPLATFORM=OS64 \
	-DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
make -C $BUILD_DIR/libmediasoupclient/device/arm64

cmake . -B $BUILD_DIR/libmediasoupclient/simulator/x64 \
	${lmsc_cmake_args} \
	-DLIBWEBRTC_BINARY_PATH=$BUILD_DIR/WebRTC/simulator/x64/WebRTC.framework/WebRTC \
	-DIOS_SDK=iphonesimulator \
	-DIOS_ARCHS="x86_64" \
	-DPLATFORM=SIMULATOR64 \
	-DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
make -C $BUILD_DIR/libmediasoupclient/simulator/x64

cmake . -B $BUILD_DIR/libmediasoupclient/simulator/arm64 \
	${lmsc_cmake_args} \
	-DLIBWEBRTC_BINARY_PATH=$BUILD_DIR/WebRTC/simulator/arm64/WebRTC.framework/WebRTC \
	-DIOS_SDK=iphonesimulator \
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
