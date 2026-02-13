PROJECT_ROOT=$(pwd)
PATCHES_DIR=$PROJECT_ROOT/patches

function generatePatches() {
	local prefix="${1:-}"

	# Iterate over modified files
	git diff --name-only | while IFS= read -r file; do
		# Skip deleted files
		[[ -f "$file" ]] || continue

		echo "Generating patch for $file"

		# Normalize filename: media/base/codec.h → media_base_codec_h.patch
		patch_name="$(echo "$file" | tr '/.' '__').patch"
		patch_path="$PATCHES_DIR/$prefix$patch_name"
		mkdir -p "$(dirname "$patch_path")"
		git diff --no-prefix -- "$file" > "$patch_path"
	done
}

rm -rf "$PATCHES_DIR"

cd $PROJECT_ROOT/Mediasoup/dependencies/webrtc/src
generatePatches

cd $PROJECT_ROOT/Mediasoup/dependencies/webrtc/src/build
generatePatches "build/"

cd $PROJECT_ROOT/Mediasoup/dependencies/webrtc/src/third_party
generatePatches "third_party/"
