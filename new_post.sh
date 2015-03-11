#!/bin/bash

stamped=$(date +%F)
NAME=src/_posts/${stamped}-${1}.markdown
touch $NAME
ls $NAME

