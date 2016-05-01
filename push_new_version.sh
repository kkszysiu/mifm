#!/bin/bash
git pull

python pull_translations.py
python propagate_translations.py

TDATE=`date +'%Y/%m/%d %H:%M:%S:%3N'`
MODIFIED_FILES=`git status | grep "modified:"`

if [ -z "$MODIFIED_FILES" ]; then
    git add translation/*
    git commit -m "Added new translations" translation/*

    git add translation_statistics.txt
    git commit -m "Added new translation stats" translation_statistics.txt

    git tag -a "v.$TDATE" -m "v.$TDATE"

    git push origin master --tags
else
    echo "Nothing to commit..."
fi

