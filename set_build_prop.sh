#!/bin/bash

build_prop_file=$1
# other arguments: # product=$2 # number=$3 # partner=$4

cat $build_prop_file | sed -e "s/ro\.build\.version\.incremental=.*/ro\.build\.version\.incremental=$3/" \
                     | sed -e "s/ro\.lewa\.device=.*//" | sed -e "s/ro\.sys\.partner=.*//" \
                     | sed -e "s/ro\.lewa\.version=.*//" > $build_prop_file.new

echo "ro.lewa.device=$2" >> $build_prop_file.new
echo "ro.sys.partner=$4" >>  $build_prop_file.new
echo "ro.lewa.version=LeWa_$(date +%y.%m.%d)" >> $build_prop_file.new
mv $build_prop_file.new $build_prop_file

