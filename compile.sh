#!/bin/bash
filename=$1
./FerLang < $1 > "${filename%.*}".c
gcc "${filename%.*}".c -o "${filename%.*}"