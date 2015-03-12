#! /bin/bash -eu

retry(){ "$@" || "$@" || "$@"; }

retry cabal install pandoc pandoc-citeproc
