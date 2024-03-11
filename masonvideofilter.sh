#!/bin//bash
# applies filter to each frame you split from a given mp4 video, recombines them back into video.
# usage: ./masonvideofilter.sh <source_video> <output_filename.mp4> [<frame_rate>] [<resize_dimensions>]

source ./extras/functions.sh

video_source="$1"
video_output="$2"

if [ -z "$3" ]; then
    frame_rate=30
else
    frame_rate="$3"
fi

if [ -z "$4" ]; then
    resize=""
else
    resize="$4"
fi

try_rm=$(rm -rf ./tmp*)
mkdir -p ./tmp

split_video_to_images "$video_source" "./tmp/frame" "$frame_rate"
./masonfilter.sh "./tmp" "./tmp2" "$resize" "1"
combine_images_to_video "./tmp2/frame" "$video_output" "$frame_rate"
try_rm=$(rm -rf ./tmp*)
