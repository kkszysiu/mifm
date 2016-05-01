#!/bin/bash

# this script will generate travis.yml file from files located in ./dist/

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

# sed -e "s/\$\-\$DIST_FILES\$\-\$/${BUILDS}/g" .travis.yml.template > output.txt
sed -e "s|>-DIST_FILES-<|$bar_escaped|g" .travis.yml.template > .travis.yml
sed -i '' 's/\\n/\
/g' .travis.yml
