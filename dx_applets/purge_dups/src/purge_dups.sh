#!/bin/bash
# purge_dups 0.0.1
# Generated by dx-app-wizard.
#
# Basic execution pattern: Your app will run on a single machine from
# beginning to end.
#
# Your job's input variables (if any) will be loaded as environment
# variables before this script runs.  Any array inputs will be loaded
# as bash arrays.
#
# Any code outside of main() (or any entry point you may add) is
# ALWAYS executed, followed by running the entry point itself.
#
# See https://wiki.dnanexus.com/Developer-Portal for tutorials on how
# to modify this file.

main() {

    echo "Value of ref_fastagz: '$ref_fastagz'"
    echo "Value of raw_reads_pacbio_fastagz: '${raw_reads_pacbio_fastagz[@]}'"

    # The following line(s) use the dx command-line tool to download your file
    # inputs to the local file system using variable names for the filenames. To
    # recover the original filenames, you can use the output of "dx describe
    # "$variable" --name".

    dx download "$ref_fastagz" -o ref_fastagz
    for i in ${!raw_reads_pacbio_fastagz[@]}
    do
        dx download "${raw_reads_pacbio_fastagz[$i]}" -o raw_reads_pacbio_fastagz-$i
    done

    # Fill in your application code here.
    #
    # To report any recognized errors in the correct format in
    # $HOME/job_error.json and exit this script, you can use the
    # dx-jobutil-report-error utility as follows:
    #
    #   dx-jobutil-report-error "My error message"
    #
    # Note however that this entire bash script is executed with -e
    # when running in the cloud, so any line which returns a nonzero
    # exit code will prematurely exit the script; if no error was
    # reported in the job_error.json file, then the failure reason
    # will be AppInternalError with a generic error message.

    # The following line(s) use the dx command-line tool to upload your file
    # outputs after you have created them on the local file system.  It assumes
    # that you have used the output field name for the filename for each output,
    # but you can change that behavior to suit your needs.  Run "dx upload -h"
    # to see more options to set metadata.

    primary_fastagz=$(dx upload primary_fastagz --brief)
    dup_fastagz=$(dx upload dup_fastagz --brief)

    # The following line(s) use the utility dx-jobutil-add-output to format and
    # add output variables to your job's output as appropriate for the output
    # class.  Run "dx-jobutil-add-output -h" for more information on what it
    # does.

    dx-jobutil-add-output primary_fastagz "$primary_fastagz" --class=file
    dx-jobutil-add-output dup_fastagz "$dup_fastagz" --class=file
    for i in "${!auxillary_files[@]}"; do
        dx-jobutil-add-output auxillary_files "${auxillary_files[$i]}" --class=array:file
    done
}
