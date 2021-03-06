#!/bin/bash
## compute_principal_curvature.bash -- use the mris_curvature tool from FreeSurfer to compute the principal curvatures k1 and k2 for all vertices of the brains of all subjects in the subjects file.
## This script writes the curvature data into files in the $SUBJECTS_DIR/<subject_id>/surf/ directory, so you need write access to the $SUBJECTS_DIR to run it.
## Written by Tim Schäfer, 2018-07-30
#
#
# Updated 2019-07-01

##### Settings -- you can adapt these to your needs. #####

## path to the mris_curvature binary. It is fine like this if mris_curvature is on your PATH.
MRIS_CURVATURE_BINARY=$(which mris_curvature)

#W The command line options passed to mris_curvature. (The input surface file and the options to compute the principal curvatures get added automatically, so do not add it here.)
## Note that there is no need to edit this in this script, you can also use the <mc_opt> command line argument to change this.
MRIS_CURVATURE_OPTIONS="-a 5"

## whether to map the results to fsaverage (standard space) from subject space
DO_RUN_MRIS_CURVATURE="YES"
DO_CONVERT_RESULTS_TO_FREESURFER_FORMAT="YES"
DO_MAP_TO_FSAVERAGE="YES"
FSAVERAGE_OUTPUT_SMOOTHING="10"


##### Start of script, there should be no need to change stuff below this line. #####

MRIS_CURVATURE_REQUIRED_OPTIONS="-min -max"

APPTAG='[CPC]'
echo "$APPTAG Compute Principal Curvature -- run the mris_curvature tool to compute k1 and k2 for all subjects in a subjects file."

if [ -z "$1" -o -z "$2" ]; then
    echo "$APPTAG USAGE: Change into your SUBJECTS_DIR and make sure you have a subjects file somewhere. Then run this script as follows:"
    echo "$APPTAG       $0 <subjectsfile> <surface> [<suffix>] [<mc_opt>]"
    echo "$APPTAG <subjectsfile>: the subjects file, must contain one subject identifier per line (each identifier must be a sub directory of SUBJECTS_DIR, like this: SUBJECTS_DIR/<subject>/)."
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

SUBJECTSFILE="$1"
SURFACE="$2"
SUFFIX="$3"
MRIS_CURV_CUSTOM_OPTIONS="$4"
if [ ! -z "$MRIS_CURV_CUSTOM_OPTIONS" ]; then
    MRIS_CURVATURE_OPTIONS="$MRIS_CURV_CUSTOM_OPTIONS"
fi


echo "$APPTAG Using subjects from file '$SUBJECTSFILE' and computing curvatures for '$SURFACE' surface."
echo "$APPTAG Running mris_curvature from '$MRIS_CURVATURE_BINARY' with options '$MRIS_CURVATURE_OPTIONS'."
if [ -n "$SUFFIX" ]; then
    echo "$APPTAG Renaming principal curvature output file by appending suffix '$SUFFIX'."
fi

BASEDIR=$(pwd)

if [ ! -f "$SUBJECTSFILE" ]; then
    echo "$APPTAG ERROR: Subjects file '$SUBJECTSFILE' does not exist or cannot be read."
    exit 1
fi

ALL_SUBJECT_IDS=$(cat $SUBJECTSFILE | tr '\n' ' ')
SUBJECT_COUNT=$(echo "$ALL_SUBJECT_IDS" | wc -w)

FAILED_LIST=""
NUM_SUBJECTS=0
NUM_OK=0
NUM_FAIL=0
NUM_OUTPUT_MOVE_FAIL=0
OUTPUT_FILES_MOVE_FAILED_LIST=""

NUM_FAIL_CONVERT=0
FAILED_CONVERT_LIST=""

NUM_FAIL_MAP_TO_FSAVG=0
FAILED_MAP_TO_FSAVG_LIST=""


for SUBJECT in $ALL_SUBJECT_IDS; do
    NUM_SUBJECTS=$((NUM_SUBJECTS + 1))
    echo "$APPTAG Handling subject ${SUBJECT}, which is # ${NUM_SUBJECTS} of ${SUBJECT_COUNT}."
    SUBJECT_SURF_DIR="${SUBJECT}/surf"
    if [ -d "$SUBJECT_SURF_DIR" ]; then

        cd "$SUBJECT_SURF_DIR"

        if [ "${DO_RUN_MRIS_CURVATURE}" = "YES" ]; then

            echo "$APPTAG  - Running mris_curvature."

            $MRIS_CURVATURE_BINARY $MRIS_CURVATURE_REQUIRED_OPTIONS $MRIS_CURVATURE_OPTIONS rh.${SURFACE} && $MRIS_CURVATURE_BINARY $MRIS_CURVATURE_REQUIRED_OPTIONS $MRIS_CURVATURE_OPTIONS lh.${SURFACE}

            if [ $? -ne 0 ]; then
                NUM_FAIL=$((NUM_FAIL + 1))
                FAILED_LIST="${FAILED_LIST}:${SUBJECT}"
                echo "$APPTAG ERROR: mris_curvature command failed for subject '$SUBJECT'."
            else
                NUM_OK=$((NUM_OK + 1))
                #echo "$APPTAG Handled surface $SURFACE for subject '$SUBJECT': OK."

                # Rename principal curvature output files if a suffix was given
                if [ -n "$SUFFIX" ]; then
                    EXPECTED_OUTPUT_FILES="lh.${SURFACE}.max lh.${SURFACE}.min rh.${SURFACE}.max rh.${SURFACE}.min"
                    for OUTFILE in $EXPECTED_OUTPUT_FILES
                    do
                        #echo "$APPTAG   Moving output file ${OUTFILE} for subject ${SUBJECT} to ${OUTFILE}${SUFFIX}."
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
                echo "$APPTAG  - Converting results to FreeSurfer format using mri_convert."
                mri_convert lh.${CONVERSION_INPUT_CURVATURE_FILE_WITHOUT_HEMISPHERE_PREFIX} lh.${CONVERSION_OUTPUT_MGH_FILE_WITHOUT_HEMISPHERE_PREFIX} && mri_convert rh.${CONVERSION_INPUT_CURVATURE_FILE_WITHOUT_HEMISPHERE_PREFIX} rh.${CONVERSION_OUTPUT_MGH_FILE_WITHOUT_HEMISPHERE_PREFIX}
                if [ $? -ne 0 ]; then
                    echo "$APPTAG ERROR: Conversion to FreeSurfer format using mri_convert failed for subject '$SUBJECT'."
                    NUM_FAIL_CONVERT=$((NUM_FAIL_CONVERT + 1))
                    FAILED_CONVERT_LIST="${FAILED_CONVERT_LIST}:${SUBJECT}"
                fi
            fi

            # Map the data to fsaverage space if requested
            if [ "${DO_MAP_TO_FSAVERAGE}" = "YES" ]; then
                echo "$APPTAG  - Mapping data to fsaverage based on input files 'lh.${CONVERSION_OUTPUT_MGH_FILE_WITHOUT_HEMISPHERE_PREFIX}' and 'rh.${CONVERSION_OUTPUT_MGH_FILE_WITHOUT_HEMISPHERE_PREFIX}'."
                HEMISPHERES="lh rh"
                for HEMISPHERE in $HEMISPHERES; do

                        INPUT_CURVATURE_FILE="${CONVERSION_OUTPUT_MGH_FILE_WITHOUT_HEMISPHERE_PREFIX}"
                        OUTPUT_FSAVG_FILE="principal_curvature_${PRINCIPAL_CURVATURE}_${SURFACE}_${HEMISPHERE}.fwhm${FSAVERAGE_OUTPUT_SMOOTHING}${SUFFIX}.mgh"
                        mris_preproc --s ${SUBJECT} --target fsaverage --hemi ${HEMISPHERE} --fwhm ${FSAVERAGE_OUTPUT_SMOOTHING} --out ${OUTPUT_FSAVG_FILE} --meas ${INPUT_CURVATURE_FILE} --area ${SURFACE}
                        if [ $? -ne 0 ]; then
                            echo "$APPTAG ERROR: Mapping data of principal curvature ${PRINCIPAL_CURVATURE} for hemisphere ${HEMISPHERE} to fsaverage failed for subject '$SUBJECT'."
                            NUM_FAIL_MAP_TO_FSAVG=$((NUM_FAIL_MAP_TO_FSAVG + 1))
                            FAILED_MAP_TO_FSAVG_LIST="${FAILED_MAP_TO_FSAVG_LIST}:${SUBJECT}.${HEMISPHERE}.${PRINCIPAL_CURVATURE}"
                        fi

                done
            fi
        done

    else
        NUM_FAIL=$((NUM_FAIL + 1))
        FAILED_LIST="${FAILED_LIST}:${SUBJECT}"
        echo "$APPTAG WARNING: Cannot handle subject $SUBJECT, could not find data directory '$SUBJECT_SURF_DIR'."
    fi
    cd "$BASEDIR"
done

echo "$APPTAG All done. Found $NUM_SUBJECTS subjects listed in subjects file '$SUBJECTSFILE'. Surface computation succeeded for $NUM_OK and failed for $NUM_FAIL of them. Please check the output above for errors."
echo "$APPTAG All subjects for which it worked out should have the results in the four files: <subject>/surf/lh.${SURFACE}.max${SUFFIX} and <subject>/surf/lh.${SURFACE}.min${SUFFIX}, <subject>/surf/rh.${SURFACE}.max${SUFFIX}, and <subject>/surf/rh.${SURFACE}.min${SUFFIX}."
if [ $NUM_FAIL -gt 0 ]; then
    FAILED_LIST="${FAILED_LIST:1}"    # remove the colon before the first element.
    echo "$APPTAG [WARNING] The $NUM_FAIL subject ids for which running mris_curvature failed, separated by colons, follow. ${FAILED_LIST}"
fi
if [ $NUM_OUTPUT_MOVE_FAIL -gt 0 ]; then
    OUTPUT_FILES_MOVE_FAILED_LIST="${OUTPUT_FILES_MOVE_FAILED_LIST:1}"    # remove the colon before the first element.
    echo "$APPTAG [WARNING] The $NUM_OUTPUT_MOVE_FAIL expected output files that could not be renamed with suffix '${SUFFIX}', separated by colons, follow. ${OUTPUT_FILES_MOVE_FAILED_LIST}"
fi
if [ $NUM_FAIL_CONVERT -gt 0 ]; then
    FAILED_CONVERT_LIST="${FAILED_CONVERT_LIST:1}"    # remove the colon before the first element.
    echo "$APPTAG [WARNING] The $NUM_FAIL_CONVERT subject ids for which conversion to FreeSurfer format failed, separated by colons, follow. ${FAILED_CONVERT_LIST}"
fi
if [ $NUM_FAIL_MAP_TO_FSAVG -gt 0 ]; then
    FAILED_MAP_TO_FSAVG_LIST="${FAILED_MAP_TO_FSAVG_LIST:1}"    # remove the colon before the first element.
    echo "$APPTAG [WARNING] The $NUM_FAIL_MAP_TO_FSAVG files for which mapping to fsaverage failed, separated by colons, follow (4 files per subject). ${FAILED_MAP_TO_FSAVG_LIST}"
fi

# log the mris_curvature settings that were used during this run to a file.
FINISHED_AT=$(date +%Y-%m-%d_%H-%M-%S)
OPTIONS_USED="surface='${SURFACE}', suffix='${SUFFIX}', mris_curvature options='${MRIS_CURVATURE_REQUIRED_OPTIONS} ${MRIS_CURVATURE_OPTIONS}', finshed_date_time=${FINISHED_AT}"
OPTIONS_LOGILE_LABEL="$FINISHED_AT"
if [ -n "$SUFFIX" ]; then
    OPTIONS_LOGILE_LABEL="$SUFFIX"
fi
OPTIONS_LOGILE="cpc_options.run${OPTIONS_LOGILE_LABEL}"
echo "${OPTIONS_USED}" > "${OPTIONS_LOGILE}" && echo "$APPTAG Saved information on the settings used in this run in file '${OPTIONS_LOGILE}'."
exit 0
