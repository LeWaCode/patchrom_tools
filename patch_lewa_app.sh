#!/bin/bash
#
# $1: dir for original lewa app 
# $2: dir for target lewa app
#
if [ -f "customize_lewa_app.sh" ]; then
    ./customize_lewa_app.sh $1 $2
    if [ $? -ne 0 ];then
       exit 1
    fi
fi

if [ $1 = "LewaLauncher" ];then
   if [ -f $1/res/xml/default_workspace.xml.part ]; then
       $PORT_ROOT/tools/gen_desklayout.pl $1/res/xml/default_workspace.xml.part $2/res/xml
       for file in $2/res/xml/default_workspace*.xml; do
           mv $file.new $file
       done
   fi
fi

# patch *.smali.method under $1
for file in `find $1 -name "*.smali.method"`; do
    $PORT_ROOT/tools/replace_smali_method.sh apply $file
done
