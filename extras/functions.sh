#!/bin/bash

# Function to combine images from source dir into mp4 file
# Usage: combine_images_to_video <input_images_name> <output_video_name> [<frame_rate>]
combine_images_to_video() {
    local input_images_name="$1"
    local output_video_name="$2"
    local frame_rate="${3:-30}"  # Default frame rate is 30 if not provided

    ffmpeg -framerate "$frame_rate" -i "$input_images_name%04d.png" -c:v libx264 -preset slow -crf 22 -pix_fmt yuv420p "$output_video_name.mp4"
}

# Function to split images from source video into png frames
# Usage: split_video_to_images <input_video_name> <output_images_name> [<frame_rate>]
split_video_to_images() {
    local input_video_name="$1"
    local output_images_name="$2"
    local frame_rate="${3:-30}"  # Default frame rate is 30 if not provided

    ffmpeg -i "$input_video_name" -vf fps="$frame_rate" "$output_images_name%04d.png"
}