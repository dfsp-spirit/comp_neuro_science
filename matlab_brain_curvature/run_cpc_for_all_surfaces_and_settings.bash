#!/bin/bash
## Run this script, it will execute the 'compute_principal_curvature.bash' script with different settings. (There is no need to manually run the 'compute_principal_curvature.bash' script.) To use this:
# 1) Put this script and the other one somewhere, e.g., into ~/scripts/, and make them executable (chmod +x <file>)
# 2) Adapt the path to the  'compute_principal_curvature.bash' script in the setting CPC_SCRIPT below.
# 3) Change into your SUBJECTS_DIR that contains the data and the subjects file (subject_analysis.txt, or change setting SUBJECTS_FILE below) and run this script from there, without any options. For example, if you copied the 2 scripts into ~/scripts/ and your subjects dir is ~/data/my_study, do:
#      cd ~/data/my_study
#      ~/scripts/run_cpc_for_all_surfaces_and_settings.bash
# That's it. This should take some time if you have many subjects. Optionally, you can supply a subjects file as first command line argument.

## You will need to adapt the next two lines to your system:

CPC_SCRIPT="$HOME/develop/comp_neuro_science/matlab_brain_curvature/compute_principal_curvature.bash"
#CPC_SCRIPT="$HOME/scripts/compute_principal_curvature.bash"
SUBJECTS_FILE="subjects_analysis.txt"


##### OK, no need to change stuff below this line, I guess.

APPTAG="[RCPC]"

if [ ! -z "$1" ]; then
    SUBJECTS_FILE="$1"
fi

# check whether the user got this right
if [ ! -f "$SUBJECTS_FILE" ]; then
    echo "$APPTAG ERROR: Subjects file '$SUBJECTS_FILE' not found. Did you start this script from within the SUBJECTS_DIR that contains your data? Do you have that file in here as well?"
    exit 1
fi

if [ ! -x "$CPC_SCRIPT" ]; then
    echo "$APPTAG ERROR: No executable CPC script was not found at location '$CPC_SCRIPT'. Please make sure that the path is correct and that the file is executable."
    exit 1
fi

echo "$APPTAG ===[ Wrapper to run the curvature computation script with different settings ]==="


# run the script for all settings
SURFACES="pial white"
AVERAGINGS="1 2 3 4"
#AVERAGINGS="0 5 10 15 20"

NUM_SURF=$(echo "$SURFACES" | wc -w)
NUM_AVG=$(echo "$AVERAGINGS" | wc -w)

echo "$APPTAG Running for $NUM_SURF surfaces: $SURFACES"
echo "$APPTAG Running for $NUM_AVG averagings: $AVERAGINGS"
echo "$APPTAG Running with subjects data from file $SUBJECTS_FILE"

CURRENT_SURF=0

for SURFACE in $SURFACES; do
    CURRENT_SURF=$((CURRENT_SURF + 1))
    CURRENT_AVG=0
    for AVG in $AVERAGINGS; do
        CURRENT_AVG=$((CURRENT_AVG + 1))
        LABEL=".a${AVG}"
        LOGFILE="run_cpc_${SURFACE}_${AVG}.log"
        echo "$APPTAG Running cpc script for surface $SURFACE (S# $CURRENT_SURF of ${NUM_SURF}) with averaging set to $AVG (A# $CURRENT_AVG of ${NUM_AVG}). Outfile label: '$LABEL'."
        $CPC_SCRIPT $SUBJECTS_FILE $SURFACE $LABEL "-a ${AVG}" | tee $LOGFILE
    done
done

echo "$APPTAG All done. Check the log files run_cpc_... and cpc_options_... in this directory. The output data is in the surf/ directory of the respective subject."
exit 0
