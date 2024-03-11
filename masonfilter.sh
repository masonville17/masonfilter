#!/bin/bash
# applies filter to all images in a directory.
# usage: ./masonfilter.sh <source_dir> <dest_dir> [<resize_dimensions>] [<skip distort="0", false>]


if [ -z "$1" ]; then
    source_dir="./"
    else
    source_dir="$1"
fi

if [ -z "$2" ]; then
    dest_dir="./modified"
    else
    dest_dir="$2"
fi


if [ -z "$4" ]; then
    skipdistort="$4"
    else
    skipdistort="0"
fi


mkdir -p "$dest_dir"
for file in "$source_dir"/*.{jpg,jpeg,png,gif}; do
  if [ -f "$file" ]; then
    output="$dest_dir/$(basename "$file")"
      if [ -n "$3" ]; then
          convert "$file" -resize "$3"^ -gravity center -extent "$2" -quality 100 "$file"
      fi
    if [ "$skipdistort" != "0" ]; then
      gmic "$file" \
      -cartoon 9.36,355.6,30,0.521,2.025,6 \
      -fx_boost_chroma 90,0,0 \
      -normalize_local 10,16 rodilius 10,4,400,16 smooth 60,0,1,1,4 normalize_local 10,16 \
      -fx_boost_chroma 90,0,0 \
      -fx_dreamsmooth 10,1,1,1,0,0.8,0,24 \
      -cartoon 9.36,355.6,30,0.521,2.035,250 -o "$output"
    else
      gmic "$file" \
      -fx_morphological 1,0,5,\"1,0,1\;0,1,0\;1,0,1\",0,0,0,0,0,50,50 \
      -cubism 6.2,33.65,90,0.5862,0.05 \
      -deform[0] 10 -deform[0] 20 \
      -cartoon 9.36,355.6,30,0.521,2.025,6 \
      -fx_boost_chroma 90,0,0 \
      -normalize_local 10,16 rodilius 10,4,400,16 smooth 60,0,1,1,4 normalize_local 10,16 \
      -fx_boost_chroma 90,0,0 \
      -fx_dreamsmooth 10,1,1,1,0,0.8,0,24 \
      -cartoon 9.36,355.6,30,0.521,2.035,250 -o "$output"
    fi
  fi
done


