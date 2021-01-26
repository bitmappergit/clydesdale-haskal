#!/bin/bash

Y2=$PWD \
  HASKELL=$PWD \
  PRELUDE=$PWD/progs/prelude \
  PRELUDEBIN=$PWD/progs/prelude/sbcl \
  sbcl \
  --load ./com/sbcl/sbcl-setup.lisp \
  --load ./cl-support/cl-init.lisp
