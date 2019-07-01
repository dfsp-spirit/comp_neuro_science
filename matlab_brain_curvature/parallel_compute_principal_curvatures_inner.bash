#!/bin/bash
## parallel_compute_principal_curvatures_inner.bash -- use the mris_curvature tool from FreeSurfer to compute the principal curvatures k1 and k2 for all vertices of a subject.
##
## This script is designed to be run in parallel on all cpu cores of your machine using a GNU Parallel wrapper scripts. The wrapper should call this script once for each subject using GNU parallel.
##
## This script writes the curvature data into files in the $SUBJECTS_DIR/<subject_id>/surf/ directory, so you need write access to the $SUBJECTS_DIR to run it.
## This GNU Parallel version was written by Tim Schäfer, 2019-07-01
## Based on the sequential (loop over all subjects) version, which was written by Tim Schäfer, 2018-07-30
#

##### Settings -- you can adapt these to your needs. #####

## path to the mris_curvature binary. It is fine like this if mris_curvature is on your PATH.
MRIS_CURVATURE_BINARY=$(which mris_curvature)

#W The command line options passed to mris_curvature. (The input surface file and the options to compute the principal curvatures get added automatically, so do not add it here.)
## Note that there is no need to edit this in this script, you can also use the <mc_opt> command line argument to change this.
MRIS_CURVATURE_OPTIONS="-a 5"

## whether to map the results to fsaverage (standard space) from subject space
DO_RUN_MRIS_CURVATURE="YES"
DO_CONVERT_RESULTS_TO_FREESURFER_FORMAT="YES"    # will convert from curv to MGH.
DO_MAP_TO_FSAVERAGE="NO"    # whether to map principal curvature to fsaverage. usually zyou do NOT want this: you first want to compute stuff like shape index or mean curvature in native space, then map those to fsaverage.
FSAVERAGE_OUTPUT_SMOOTHING="10"    # output smoothing on fsaverage surface, only applies if DO_MAP_TO_FSAVERAGE="YES"


##### Start of script, there should be no need to change stuff below this line. #####

MRIS_CURVATURE_REQUIRED_OPTIONS="-min -max"

APPTAG='[CPCS]'
echo "$APPTAG Compute Principal Curvature single -- run the mris_curvature tool to compute k1 and k2 for a single subject."

if [ -z "$1" -o -z "$2" ]; then
    echo "$APPTAG USAGE: Change into your SUBJECTS_DIR and make sure you have a subjects file somewhere. Then run this script as follows:"
    echo "$APPTAG       $0 <subject_id> <surface> [<suffix>] [<mc_opt>]"
    echo "$APPTAG <subject_id>: the subject id (must be a sub directory of SUBJECTS_DIR, like this: SUBJECTS_DIR/<subject_id>/)."
    echo "$APPTAG <surface>: the surface to use, e.g., 'pial'. The data for the surface must exist in SUBJECTS_DIR/<subject>/surf/."
    echo "$APPTAG <suffix>: optional unless you use <mc_opt>. If given, the principal curvature output files are renamed by appending <suffix> to the file names. Hint: use a suffix describing the mris_curvature options. Example: '.a15'"
    echo "$APPTAG <mc_opt>: optional. Custom options to pass to mris_curvature. Must NOT include -min, -max, and the output file. You MUST quote this, e.g. '-a 15'. If omitted, defaults to '-a 5'."
    echo "$APPTAG Some example calls:"
    echo "$APPTAG  1) run for file subjects.txt, use pial surface, default averaging: '$0 subjects.txt pial'"
    echo "$APPTAG  2) run for file subs.txt, use white surface, average 15 times using custom options, label output files with suffix .a15: '$0 subs.txt white .a15 \"-a 15\"'"
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

SUBJECT="$1"
SURFACE="$2"
SUFFIX="$3"
MRIS_CURV_CUSTOM_OPTIONS="$4"
if [ ! -z "$MRIS_CURV_CUSTOM_OPTIONS" ]; then
    MRIS_CURVATURE_OPTIONS="$MRIS_CURV_CUSTOM_OPTIONS"
fi


echo "$APPTAG Computing curvatures for '$SURFACE' surface of subject '$SUBJECT'."
echo "$APPTAG Running mris_curvature from '$MRIS_CURVATURE_BINARY' with options '$MRIS_CURVATURE_OPTIONS'."
if [ -n "$SUFFIX" ]; then
    echo "$APPTAG Renaming principal curvature output file by appending suffix '$SUFFIX'."
fi

BASEDIR=$(pwd)


SUBJECT_SURF_DIR="${SUBJECT_ID}/surf"
if [ -d "$SUBJECT_SURF_DIR" ]; then

    cd "$SUBJECT_SURF_DIR"

    if [ "${DO_RUN_MRIS_CURVATURE}" = "YES" ]; then

        $MRIS_CURVATURE_BINARY $MRIS_CURVATURE_REQUIRED_OPTIONS $MRIS_CURVATURE_OPTIONS rh.${SURFACE} && $MRIS_CURVATURE_BINARY $MRIS_CURVATURE_REQUIRED_OPTIONS $MRIS_CURVATURE_OPTIONS lh.${SURFACE}

        if [ $? -ne 0 ]; then
            echo "$APPTAG ERROR: mris_curvature command failed for subject '$SUBJECT'. Exiting."
            exit 1
        else

            # Rename principal curvature output files if a suffix was given
            if [ -n "$SUFFIX" ]; then
                EXPECTED_OUTPUT_FILES="lh.${SURFACE}.max lh.${SURFACE}.min rh.${SURFACE}.max rh.${SURFACE}.min"
                for OUTFILE in $EXPECTED_OUTPUT_FILES
                do
                    mv "$OUTFILE" "${OUTFILE}${SUFFIX}"
                    retVal=$?
                    if [ $retVal -ne 0 ]; then
                        NUM_OUTPUT_MOVE_FAIL=$((NUM_OUTPUT_MOVE_FAIL + 1))
                        OUTPUT_FILES_MOVE_FAILED_LIST="${OUTPUT_FILES_MOVE_FAILED_LIST}:${SUBJECT}/surf/${OUTFILE}"
                   fi
                done
            fi
        fi
    fi

    PRINCIPAL_CURVATURES="min max"
    for PRINCIPAL_CURVATURE in $PRINCIPAL_CURVATURES; do
        CONVERSION_INPUT_CURVATURE_FILE_WITHOUT_HEMISPHERE_PREFIX="${SURFACE}.${PRINCIPAL_CURVATURE}${SUFFIX}"
        CONVERSION_OUTPUT_MGH_FILE_WITHOUT_HEMISPHERE_PREFIX="${SURFACE}.${PRINCIPAL_CURVATURE}${SUFFIX}.mgh"
        if [ "${DO_CONVERT_RESULTS_TO_FREESURFER_FORMAT}" = "YES" ]; then
            mri_convert lh.${CONVERSION_INPUT_CURVATURE_FILE_WITHOUT_HEMISPHERE_PREFIX} lh.${CONVERSION_OUTPUT_MGH_FILE_WITHOUT_HEMISPHERE_PREFIX} && mri_convert rh.${CONVERSION_INPUT_CURVATURE_FILE_WITHOUT_HEMISPHERE_PREFIX} rh.${CONVERSION_OUTPUT_MGH_FILE_WITHOUT_HEMISPHERE_PREFIX}
            if [ $? -ne 0 ]; then
                echo "$APPTAG ERROR: Conversion to FreeSurfer format using mri_convert failed for subject '$SUBJECT'. Exiting."
                exit 1
            fi
        fi

        # Map the data to fsaverage space if requested. Note that it may be better to compute other measures derived from k1 and k2 (like shape index, mean curvature, or others) in native space first, and then map those to fsaverage.
        # To compute these measures, you need the matlab script.
        if [ "${DO_MAP_TO_FSAVERAGE}" = "YES" ]; then
            HEMISPHERES="lh rh"
            for HEMISPHERE in $HEMISPHERES; do

                    INPUT_CURVATURE_FILE="${CONVERSION_OUTPUT_MGH_FILE_WITHOUT_HEMISPHERE_PREFIX}"
                    OUTPUT_FSAVG_FILE="principal_curvature_${PRINCIPAL_CURVATURE}_${SURFACE}_${HEMISPHERE}.fwhm${FSAVERAGE_OUTPUT_SMOOTHING}${SUFFIX}.mgh"
                    mris_preproc --s ${SUBJECT} --target fsaverage --hemi ${HEMISPHERE} --fwhm ${FSAVERAGE_OUTPUT_SMOOTHING} --out ${OUTPUT_FSAVG_FILE} --meas ${INPUT_CURVATURE_FILE} --area ${SURFACE}
                    if [ $? -ne 0 ]; then
                        echo "$APPTAG ERROR: Mapping data of principal curvature ${PRINCIPAL_CURVATURE} for hemisphere ${HEMISPHERE} to fsaverage failed for subject '$SUBJECT'. Exiting."
                        exit 1
                    fi

            done
        fi
    done

else
    echo "$APPTAG ERROR: Cannot handle subject $SUBJECT, could not find data directory '$SUBJECT_SURF_DIR'. Exiting."
    exit 1
fi

exit 0
