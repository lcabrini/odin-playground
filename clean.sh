#! /bin/bash

# Makefile?! We don't need no stinkin' Makefile!

while IFS= read -r prog; do
    [[ -x $prog ]] && rm -f $prog
done < .gitignore

find . -name screenshot.png -delete