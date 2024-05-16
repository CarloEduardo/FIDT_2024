#!/bin/bash

git status

DAY=`date +"%d/%m/%Y"`

TIME=`date +"%H:%M"`

git add --all

git commit -m "Automatic update of $DAY at $TIME"

git push
