#!/bin/sh -l

EXIT_CODE_OK=0
EXIT_CODE_UNKNOWN_ERROR=90
EXIT_CODE_ISSUES_FOUND_WITHIN_THRESHOLD=91
EXIT_CODE_CHECK_FAILED=92
EXIT_CODE_AUTH_FAILED=93


OUTPUT_PATH=".korbit"
paths=$1
threshold_priority=$2
threshold_confidence=$3
headless=$4
is_scan_pr=$5
scan_pr_path=$6
scan_pr_compare_branch=$7

git branch -a
cmd="korbit"

if [ "$is_scan_pr" = true ]; then
    echo "Running a PR scan for `$scan_pr_path` and against branch `$scan_pr_compare_branch`"
    cmd="$cmd scan-pr $scan_pr_path $scan_pr_compare_branch"
else
    echo 
    cmd="$cmd scan $paths"
fi

cmd="$cmd \
    --threshold-priority=$threshold_priority \
    --threshold-confidence=$threshold_confidence"

if [ "$headless" = true ]; then
    cmd="$cmd --headless"
fi

echo "Start running the scan..."
eval "$cmd --verbose"
eval_exit_code=$?

echo "Creating the report..."

# We want to make sure the report exit before showing it
if [ -f "$OUTPUT_PATH/scan.log" ]; then
    cat $OUTPUT_PATH/scan.log >> $GITHUB_STEP_SUMMARY
else
    if [ -f "$OUTPUT_PATH/*.html" ]; then
        cat $OUTPUT_PATH/*.html >> $GITHUB_STEP_SUMMARY
    else
        echo "No report found." >> $GITHUB_STEP_SUMMARY
    fi
fi


echo "Scan completed."

if [ $eval_exit_code -ne $EXIT_CODE_OK ]; then
    exit_message="korbit scan command failed with exit code: $eval_exit_code"
    echo $exit_message
    echo $exit_message >> $output_scan_log_path
else
    echo "korbit scan command completed successfuly."
fi

exit $eval_exit_code