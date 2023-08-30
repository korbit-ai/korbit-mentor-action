#!/bin/sh -l

OUTPUT_PATH=".korbit"
path=$1
threshold_priority=$2
threshold_confidence=$3
headless=$4
headless_show_report=$5

cmd="korbit scan $path \
    --threshold-priority=$threshold_priority \
    --threshold-confidence=$threshold_confidence"

if [ "$headless" = true ]; then
    cmd="$cmd --headless"
fi
if [ "$headless_show_report" = true ]; then
    cmd="$cmd --headless-show-report"
fi

eval $cmd

eval_exit_code=$?

if [ -f $OUTPUT_PATH ]; then
    cat $OUTPUT_PATH/scan.log >> $GITHUB_STEP_SUMMARY
else
    cat $OUTPUT_PATH/*.html >> $GITHUB_STEP_SUMMARY
fi

exit $eval_exit_code