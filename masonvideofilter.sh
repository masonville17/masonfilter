#!/bin//bash
# applies filter to each frame you split from a given mp4 video, recombines them back into video.
# usage: ./masonvideofilter.sh <source_video> <output_filename.mp4> [<frame_rate>] [<resize_dimensions>] [<filter opacity=.5>]

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
if [ -z "$5" ]; then
    overlay_opacity="0.5"
else
    overlay_opacity="$5"
fi


try_rm=$(rm -rf ./tmp*)
mkdir -p ./tmp
echo "Splitting $video_source into frames at $frame_rate fps."

split_video_to_images "$video_source" "./tmp/frame" "$frame_rate"

frame_count=$(find ./tmp -type f | wc -l)
echo "applying filter to $frame_count frames with resize: $resize"
./masonfilter.sh "./tmp" "./tmp2" "$resize" "1"

echo "overlaying filtered images for each of $frame_count frames."
mkdir -p ./tmp3
overlay_images "./tmp2" "./tmp" $overlay_opacity "./tmp3"

echo "rendering base video @$frame_rate fps from $frame_count frames"
combine_images_to_video "./tmp3/frame" "$video_output" "$frame_rate"
try_rm=$(rm -rf ./tmp*)
echo "splicing in audio from $video_source to $video_output as AAC"
strip_and_splice_audio "$video_source" "$video_output"

echo "Completed video filter for $video_source. Output is $video_output."