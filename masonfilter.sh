#!/bin/bash

mkdir -p ./modified

# This assumes that 'fx_cartoon' is the correct filter name; replace as necessary
for file in *.{jpg,jpeg,png,gif}; do
  if [ -f "$file" ]; then
    output="./modified/mason${file}"
    convert "$file" -resize 1920x1080^ -gravity center -extent 1920x1080 -quality 100 "$file"

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
done
