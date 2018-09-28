#!/usr/bin/env python
## Minimal example code to read freesurfer `curv' data (i.e., one value for each vertex on a brain surface) using nibabel
## Written by Tim, 2018-09-28
##
## Prerequisites: You need nibabel installed, e.g., `pip install nibabel`
##
## Usage: Change into a directory that contains FreeSurfer output for a single subject (e.g., $SUBJECTS_DIR/subject1/) and run `python <path/to/this_script.py>`

import os
import nibabel.freesurfer.io as fsio

## Read the surface file (geometry data, a mesh)
vert_coords, faces = fsio.read_geometry(os.path.join('surf', 'lh.white'))
print "Received %d vertex coords, %d faces." % (len(vert_coords), len(faces))

## Read the morphometry data (called 'curv' file by FreeSurfer) file for the surfaces
per_vertex_data = fsio.read_morph_data(os.path.join('surf', 'lh.area'))
print "Received data for %d vertices." % len(per_vertex_data)
