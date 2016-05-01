#!/bin/bash

python pull_translations.py
python propagate_translations.py

git add translation/*
git commit -m "Added new translations" translation/*
