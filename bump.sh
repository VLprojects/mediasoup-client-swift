#!/bin/bash

read -p "Enter version number: " VERSION

sed -i '' "s/let version = \".*\"/let version = \"$VERSION\"/" Package.swift

RUN_PATH=$(pwd)
cd $RUN_PATH/bin
rm -f $RUN_PATH/build/Mediasoup.xcframework.zip
zip -r $RUN_PATH/build/Mediasoup.xcframework.zip Mediasoup.xcframework -x "*.DS_Store"
rm -f $RUN_PATH/build/WebRTC.xcframework.zip
zip -r $RUN_PATH/build/WebRTC.xcframework.zip WebRTC.xcframework -x "*.DS_Store"
cd $RUN_PATH

MEDIASOUP_CHECKSUM=$(swift package compute-checksum ./build/Mediasoup.xcframework.zip)
WEBRTC_CHECKSUM=$(swift package compute-checksum ./build/WebRTC.xcframework.zip)
sed -i '' "s/let mediasoupChecksum = \".*\"/let mediasoupChecksum = \"$MEDIASOUP_CHECKSUM\"/" Package.swift
sed -i '' "s/let webrtcChecksum = \".*\"/let webrtcChecksum = \"$WEBRTC_CHECKSUM\"/" Package.swift
sed -i '' "s/spec.version = \".*\"/spec.version = \"$VERSION\"/" Mediasoup-Client-Swift.podspec
sed -i '' "s/pod 'Mediasoup-Client-Swift', '.*'/pod 'Mediasoup-Client-Swift', '$VERSION'/" README.md

cd Example
pod install
