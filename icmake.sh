#!/bin/bash
# wrap arguments in quotes and escape double quotes
args=
for arg in "$@"
do
  args="$args \"$arg\"" 
done
args="\"${args//\"/\\\"}\""
# get script path
pushd `dirname $0` > /dev/null
scriptPath=`pwd -P`
popd > /dev/null
currentDir=`pwd`
scriptPath+="/icmake.cmake"
# echo $args
# compile cmake command
cutil="cmake -P $scriptPath" 
# echo $cutil
# execute cmake command
eval $cutil

