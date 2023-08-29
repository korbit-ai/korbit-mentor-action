#!/bin/sh -l

#!/bin/bash

OUTPUT_PATH=".korbit/scan.log"
path=$1
threshold_priority=$2
threshold_confidence=$3
headless=$4
headless_show_report=$5

echo "Environment variables:"
echo "KORBIT_SECRET_ID: $KORBIT_SECRET_ID"
echo "KORBIT_SECRET_KEY: $KORBIT_SECRET_KEY"

echo "Running korbit scan with the following arguments:"
echo "Path: $path"
echo "Threshold Priority: $threshold_priority"
echo "Threshold Confidence: $threshold_confidence"
echo "Headless: $headless"
echo "Headless Show Report: $headless_show_report"

cmd="korbit scan $path \
    --threshold-priority=$threshold_priority \
    --threshold-confidence=$threshold_confidence"

if [ "$headless" = true ]; then
    cmd="$cmd --headless"
fi
if [ "$headless_show_report" = true ]; then
    cmd="$cmd --headless-show-report"
fi


echo "Executing korbit scan command..."
echo "Command: $cmd"
eval $cmd

echo "korbit scan command completed."
echo "\n\nOutput:"
echo "$(cat $OUTPUT_PATH)"
echo "$(cat $OUTPUT_PATH)" >> $GITHUB_OUTPUT

