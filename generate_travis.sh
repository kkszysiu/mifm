#!/bin/bash

# this script will generate travis.yml file from files located in ./dist/

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   platform='freebsd'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='darwin'
fi

BUILDS=""

DIST_BUILDS=`ls -l ./dist/ | awk '{print $9}'`
for DIST_BUILD in $DIST_BUILDS
do
    LINE="    - dist/$DIST_BUILD\n"
    BUILDS+=$LINE
done

bar=$BUILDS
bar_escaped=$(printf '%s\n' "$bar" | sed 's,[\/&],\\&,g;s/$/\\/')
bar_escaped=${bar_escaped%?}

sed -e "s|>-DIST_FILES-<|$bar_escaped|g" .travis.yml.template > .travis.yml

if [[ $platform == 'linux' ]]; then
sed -i 's/\\n/\
/g' .travis.yml
elif [[ $platform == 'darwin' ]]; then
sed -i '' 's/\\n/\
/g' .travis.yml
fi
