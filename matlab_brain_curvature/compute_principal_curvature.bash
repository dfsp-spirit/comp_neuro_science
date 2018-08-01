#!/bin/bash
## compute_principal_curvature.bash -- use the mris_curvature tool from FreeSurfer to compute the principal curvatures k1 and k2 for all vertices of the brains of all subjects in the subjects file.
## This script writes the curvature data into files in the $SUBJECTS_DIR/<subject_id>/surf/ directory, so you need write access to the $SUBJECTS_DIR to run it.
## Written by Tim Schäfer, 2018-07-30

## Settings ##

# path to the mris_curvature binary. It is fine like this if mris_curvature is on your PATH.
MRIS_CURVATURE_BINARY=$(which mris_curvature)

# The command line options passed to mris_curvature. (The input surface file gets added automatically, so do not add it here.)
MRIS_CURVATURE_OPTIONS="-min -max -a 10"


## Start of script ##

APPTAG='[CPC]'
echo "$APPTAG Compute Principal Curvature -- run the mris_curvature tool to compute k1 and k2 for all subjects in a subjects file."

if [ -z "$1" -o -z "$2" ]; then
    echo "$APPTAG USAGE: Change into your SUBJECTS_DIR and make sure you have a subjects file somewhere. Then run this script as follows:"
    echo "$APPTAG       $0 <subjectsfile> <surface>"
    echo "$APPTAG <subjectsfile>: the subjects file, must contain one subject identifier per line (each identifier must be a sub directory of SUBJECTS_DIR, like this: SUBJECTS_DIR/<subject>/)."
    echo "$APPTAG <surface>: the surface to use, e.g., 'pial'. The data for the surface must exist in SUBJECTS_DIR/<subject>/surf/."
    exit 1
fi

if [ -z "$MRIS_CURVATURE_BINARY" ]; then
    echo "$APPTAG ERROR: Could not find mris_curvature binary on the PATH. Please add its location to your PATH or set the path in this script."
    exit 1
fi

if [ ! -x "$MRIS_CURVATURE_BINARY" ]; then
    echo "$APPTAG ERROR: Could not find executable mris_curvature binary in path '$MRIS_CURVATURE_BINARY'. Please check the path and/or make sure it is executable."
    exit 1
fi

SUBJECTSFILE="$1"
SURFACE="$2"

echo "$APPTAG Using subjects from file '$SUBJECTSFILE' and computing curvatures for '$SURFACE' surface."
echo "$APPTAG Running mris_curvature from '$MRIS_CURVATURE_BINARY' with options '$MRIS_CURVATURE_OPTIONS'."

BASEDIR=$(pwd)

if [ ! -f "$SUBJECTSFILE" ]; then
    echo "$APPTAG ERROR: Subjects file '$SUBJECTSFILE' does not exist or cannot be read."
    exit 1
fi

ALL_SUBJECT_IDS=$(cat $SUBJECTSFILE | tr '\n' ' ')

FAILED_LIST=""
NUM_SUBJECTS=0
NUM_OK=0
NUM_FAIL=0

for SUBJECT in $ALL_SUBJECT_IDS; do
    NUM_SUBJECTS=$((NUM_SUBJECTS + 1))
    SUBJECT_SURF_DIR="${SUBJECT}/surf"
    if [ -d "$SUBJECT_SURF_DIR" ]; then
        cd "$SUBJECT_SURF_DIR" && $MRIS_CURVATURE_BINARY $MRIS_CURVATURE_OPTIONS rh.${SURFACE} && $MRIS_CURVATURE_BINARY $MRIS_CURVATURE_OPTIONS lh.${SURFACE}

        retVal=$?
        if [ $retVal -ne 0 ]; then
            NUM_FAIL=$((NUM_FAIL + 1))
            FAILED_LIST="${FAILED_LIST}:${SUBJECT}"
            echo "$APPTAG Error: mris_curvature command failed for subject '$SUBJECT'."
        else
            NUM_OK=$((NUM_OK + 1))
            echo "$APPTAG Handled surface $SURFACE for subject '$SUBJECT': OK."
        fi
        cd "$BASEDIR"
    else
        NUM_FAIL=$((NUM_FAIL + 1))
        FAILED_LIST="${FAILED_LIST}:${SUBJECT}"
        echo "$APPTAG WARNING: Cannot handle subject $SUBJECT, could not find data directory '$SUBJECT_SURF_DIR'."
    fi
done

echo "$APPTAG All done. Found $NUM_SUBJECTS listed in subjects file $SUBJECTSFILE. Surface computation succeeded for $NUM_OK and failed for $NUM_FAIL. Please check the output above for errors."
echo "$APPTAG All subjects for which it worked out should have the results in the four files: <subject>/surf/lh.<surface>.max and <subject>/surf/lh.<surface>.min, <subject>/surf/rh.<surface>.max, and <subject>/surf/rh.<surface>.min."
if [ $NUM_FAIL -gt 0 ]; then
    FAILED_LIST="${FAILED_LIST:1}"    # remove the colon before the first element.
    echo "$APPTAG The $NUM_FAIL failed subject ids, separated by colons follow. ${FAILED_LIST}"
fi
exit 0
