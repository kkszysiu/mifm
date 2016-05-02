#!/bin/bash
git pull

python pull_translations.py
python propagate_translations.py

TDATE=`date +'%Y_%m_%d_%H%M%S'`
MODIFIED_FILES=`git status | grep 'modified:'`

echo "MODIFIED_FILES $MODIFIED_FILES"

if [ -z "$MODIFIED_FILES" ]; then
    echo "Nothing to commit..."
else
    git add translation/*
    git commit -m "Added new translations" translation/*

    git add translation_statistics.txt
    git commit -m "Added new translation stats" translation_statistics.txt

    translation_values=$(<translation_statistics.txt)

    git tag -a "v.$TDATE" -m "v.$TDATE
$translation_values"

    git push origin master --tags
fi

