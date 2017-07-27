#!/bin/bash

set -e

DST=/results

vers=( 3.0.0 3.1.0 3.2.0 3.3.0-rc master )
num=${#vers[@]}

pushd $DST
for n in $(seq 1 $num) ; do

    base="${vers[@]:$(( n - 1 )):1}"
    candidates=("${vers[@]:$n}")


    for candidate in ${candidates[@]} ; do
        echo "/ ------------------------"
        echo "| ${base} VS ${candidate} "
        echo "\ ------------------------"
        abi-compliance-checker \
            -l opencv \
            -old current-${base}.abi.tar.gz \
            -new current-${candidate}.abi.tar.gz \
            -report-path abi_report_${base}_vs_${candidate}.html \
            -skip-internal '.*UMatData.*|.*randGaussMixture.*|.*cv\d+hal.*|.*cv\d+dnn\d+experimental.*' \
        || echo "FAILED!!!"
    done

done
popd
