#!/bin/bash
filename=$1
./PataSucia < $1 > "${filename%.*}".c
gcc "${filename%.*}".c -o "${filename%.*}"