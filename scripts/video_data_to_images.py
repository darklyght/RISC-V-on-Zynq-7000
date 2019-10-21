#!/usr/bin/env python3

import sys
import numpy as np
from PIL import Image
import shutil
import os

video_data_filepath = sys.argv[1]

def color_string_to_array(color_string):
    color_string = color_string.split(",")
    color_string = [x.strip() for x in color_string]
    return np.uint8((255.0/31.0) * np.uint8(color_string))

if os.path.exists('video_frames'):
    shutil.rmtree('video_frames')
os.makedirs('video_frames')

with open(video_data_filepath, 'r') as video_data_file:
    video_data = video_data_file.readlines()
    video_data = [x.strip() for x in video_data]
    frame_counter = 0
    for frame in video_data:
        frame_counter = frame_counter + 1
        pixels = frame.split("|")
        # Get rid of the trailing '|' that's tokenized
        pixels = pixels[:len(pixels)-1]
        if len(pixels) != 1024*768:
            print("WARNING: frame %d in the video data is %d pixels long, expected %d, skipping this frame" % (frame_counter, len(pixels), 1024*768)) 
            continue

        pixels = [color_string_to_array(x) for x in pixels]
        pixels = np.reshape(pixels, (768, 1024, 3))
        img = Image.fromarray(pixels, 'RGB')
        img.save('video_frames/frame%02d.png' % (frame_counter))
