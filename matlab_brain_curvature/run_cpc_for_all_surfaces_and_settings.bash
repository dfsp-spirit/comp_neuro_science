#!/bin/bash
CPC_SCRIPT="$HOME/develop/comp_neuro_science/matlab_brain_curvature/compute_principal_curvature.bash"

SUBJECS_FILE="subjects_analysis.txt"
APPTAG="[RCPC]"

# run the script for all settings
SURFACES="pial white"
AVERAGINGS="0 5 10 15 20"

for SURFACE in $SURFACES; do
    for AVG in $AVERAGINGS; do
        LABEL=".a${AVG}"
        LOGFILE="run_cpc_${SURFACE}_${AVG}.log"
        echo "$APPTAG Running cpc script for surface $SURFACE with averaging set to $AVG..."
        $CPC_SCRIPT $SUBJECS_FILE $SURFACE $LABEL "-a ${AVG}" | tee $LOGFILE
    done
done
