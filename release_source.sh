#!/bin/bash
echo "The android source code is located at: $1"
echo "The lewa source code is located at: $2"
echo "The released source code would be put at: $3"

echo "[IMPORTANT] make sure the source codes has been put under $1"

src_dir=frameworks/base
android=$1/$src_dir
android_rlz=$PORT_ROOT/android/src/$src_dir
lewa=$2/$src_dir
release=$3/src/$src_dir

for mf in `find $lewa -name "*.java"`
do
       af=${mf/$lewa/$android}
       if [ -f "$af" ]
       then
        diff $af $mf > /dev/null || {
                #echo $af is different with $mf;
                arf=${af/$android/$android_rlz}
                mkdir -p `dirname $arf`
                cp $af $arf
                rf=${mf/$lewa/$release}
                mkdir -p `dirname $rf`
                cp $mf $rf
            }
       else
            echo "Have $mf but $af does not exist!"
       fi
done

for mf in `find $lewa -name "*.aidl"`
do
       af=${mf/$lewa/$android}
       if [ -f "$af" ]
       then
        diff $af $mf > /dev/null || {
                #echo $af is different with $mf;
                arf=${af/$android/$android_rlz}
                mkdir -p `dirname $arf`
                cp $af $arf
                rf=${mf/$lewa/$release}
                mkdir -p `dirname $rf`
                cp $mf $rf
            }
       else
            echo "Have $mf but $af does not exist!"
       fi
done

