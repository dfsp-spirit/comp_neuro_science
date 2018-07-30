#!/bin/bash
## compute_principal_curvature.bash -- use the mris_curvature tool from FreeSurfer to compute the principal curvatures k1 and k2 for all vertices of the brains of all subjects in the subjects file.
## Written by Tim Schäfer, 2018-07-30

APPTAG='[CPC]'

if [ -z "$1" -o -z "$2" ]; then
    echo "$APPTAG USAGE: Change into your SUBJECTS_DIR and make sure you have a subjects file somewhere. Then run this script as follows:"
    echo "$APPTAG       $0 <subjectsfile> <surface>"
    echo "$APPTAG <subjectsfile>: the subjects file, must contain one subject identifier per line (each identifier must be a sub directory of SUBJECTS_DIR, like this: SUBJECTS_DIR/<subject>/)."
    echo "$APPTAG <surface>: the surface to use, e.g., 'pial'. The data for the surface must exist in SUBJECTS_DIR/<subject>/surf/."
    exit 1
fi

SUBJECTSFILE="$1"
SURFACE="$2"

BASEDIR=$(pwd)

if [ ! -f "$SUBJECTSFILE"]; then
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
        cd "$SUBJECT_SURF_DIR" && mris_curvature -min -max -a 3 rh.${SURFACE} && mris_curvature -min -max -a 3 lh.${SURFACE}

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
