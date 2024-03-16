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

overlay_images() {
    local overlayfolder=$1
    local basefolder=$2
    local opacity=$3
    local outputdir=$4
    for file1 in "$overlayfolder"/*.{jpg,jpeg,png,gif}; do
        filename=$(basename "$file1")
        file2="$basefolder/$filename"
        if [ -f "$file2" ]; then
            convert "$file1" "$file2" -gravity SouthWest -compose over -alpha "$opacity" -composite \
                    -pointsize 36 -fill white -annotate +20+20 "$filename" \
                    "$outputdir/$filename"
        else
            echo "Corresponding file not found for $filename"
        fi
    done
}

strip_and_splice_audio() {
    local input_file=$1
    local output_file=$2
    local audio_file="temp_audio.aac"
    ffmpeg -i "$input_file" -vn -acodec copy "$audio_file"
    ffmpeg -i "$output_file" -i "$audio_file" -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest "output_with_audio.mp4"
    rm "$audio_file"
}
