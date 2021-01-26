;;; mcl-setup.lisp -- scripts for MCL haskell
;;;
;;; author :  Sandra Loosemore
;;; date   :  15 Jan 1993
;;;
;;; Since the Mac doesn't have a shell, this file contains some stuff to
;;; do basic system-building of the Yale Haskell system under MCL.

(in-package #:cl-user)

(setf *compile-print* t)
(setf *compile-verbose* t)

;;; MCL implements CLtL2 rather than CLtL1.  However, we still have a
;;; few references to the LISP package around in our code.

(unless (find-package "LISP")
  (defpackage "LISP"
    (:use :cl)))


;;; Create the mumble-implementation package.  It's important to do this
;;; explicitly, because MCL's make-package defaults include extra junk that
;;; we don't want to have accessible.

(defpackage "MUMBLE-IMPLEMENTATION"
  (:use #:cl))

(in-package "MUMBLE-IMPLEMENTATION")


;;; MCL doesn't have environment variables, so we're rolling our own.
;;; You need to tweak this a-list when installing Yale Haskell to account
;;; for the place where you put it.

;(defvar *environment-alist* 
;  '(("Y2"         . "/Users/bitmapper/Downloads/haskell-2.2-source")
;    ("HASKELL"    . "/Users/bitmapper/Downloads/haskell-2.2-source")
;    ("PRELUDE"    . "/Users/bitmapper/Downloads/haskell-2.2-source/progs/prelude")
;    ("PRELUDEBIN" . "/Users/bitmapper/Downloads/haskell-2.2-source/progs/prelude/mcl")
;     ))


;;; These pathnames also need to be hardwired for bootstrapping.

(defvar *support-directory* "./cl-support/")
(defvar *support-binary-directory* "./cl-support/sbcl/")

