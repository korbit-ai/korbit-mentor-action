#!/bin/sh -l

#!/bin/bash

OUTPUT_PATH=".korbit/scan.log"
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

korbit scan --help

eval $cmd
ls -la .korbit
ls -la

echo "$(cat $OUTPUT_PATH)" >> $GITHUB_OUTPUT

