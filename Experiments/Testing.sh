#!/bin/zsh

# shellcheck shell=bash

IFS=$'\n'
# CART
cd '/Applications' || exit

for appFolder in `ls -d *`; do
    for innerFolder in $appFolder/*; do
      echo $innerFolder
    done
done
