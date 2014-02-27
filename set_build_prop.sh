#!/bin/bash

build_prop_file=$1
# other arguments: # product=$2 # number=$3 # partner=$4

cat $build_prop_file | sed -e "s/ro\.build\.version\.incremental=.*/ro\.build\.version\.incremental=$3/" \
                     | sed -e "s/ro\.lewa\.device=.*//" | sed -e "s/ro\.sys\.partner=.*//" \
                     | sed -e "s/ro\.lewa\.version=.*//" > $build_prop_file.new


if [ $2 == "Unknown" ]; then
    device=`cat $build_prop_file | grep ro.product.device= | sed -e "s/ro\.product\.device=//"`
    echo "ro.lewa.device=$device" >> $build_prop_file.new
else
    echo "ro.lewa.device=$2" >> $build_prop_file.new
fi
echo "ro.sys.partner=$4" >>  $build_prop_file.new
echo "ro.lewa.version=LeWa_OS5.1_$(date +%y.%m.%d)" >> $build_prop_file.new
mv $build_prop_file.new $build_prop_file

