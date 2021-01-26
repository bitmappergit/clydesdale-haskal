;;; cl-init.lisp -- initialize Common Lisp, loading cl-specific files.
;;;
;;; author :  Sandra Loosemore
;;; date   :  23 Oct 1991
;;;
;;; All of the files loaded here are assumed to be regular Common Lisp
;;; files.

(cl:in-package "MUMBLE-IMPLEMENTATION")


;;; Turn off bogus warnings and messages!!!

;;; Lucid complains if files don't start with IN-PACKAGE.
#+lucid
(setq lcl:*warn-if-no-in-package* '())


;;; CMU CL prints too many compiler progress messages.
#+cmu
(progn
  (setq *compile-print* '())
  (setq *load-verbose* t)
  )


;;; AKCL complains if any package operations appear at top-level
;;; after any other code.
;;; Also prints useless notes about when it does tail recursion elimination.
#+akcl
(progn
  (setq compiler:*suppress-compiler-notes* t)
  (setq compiler:*compile-verbose* t)
  (setq *load-verbose* t)
  (setq compiler::*compile-ordinaries* t)
  (si:putprop 'make-package nil 'compiler::package-operation)
  (si:putprop 'shadow nil 'compiler::package-operation)
  (si:putprop 'shadowing-import nil 'compiler::package-operation)
  (si:putprop 'export nil 'compiler::package-operation)
  (si:putprop 'unexport nil 'compiler::package-operation)
  (si:putprop 'use-package nil 'compiler::package-operation)
  (si:putprop 'unuse-package nil 'compiler::package-operation)
  (si:putprop 'import nil 'compiler::package-operation)
  (si:putprop 'provide nil 'compiler::package-operation)
  (si:putprop 'require nil 'compiler::package-operation)
  )


;;; Allegro also issues too many messages.
;;; ***We really ought to rename the defstructs that give the package
;;; locked errors....

#+allegro
(progn
  (setf *compile-print* nil)
  (setf compiler:*cltl1-compile-file-toplevel-compatibility-p* nil)
  (setq excl:*enable-package-locked-errors* nil)
  (setf excl:*load-source-file-info* nil)
  (setf excl:*record-source-file-info* nil)
  (setf excl:*load-xref-info* nil)
  (setf excl:*record-source-file-info* nil)
  )


;;; Harlequin Lispworks prints too many messages too.

#+lispworks
(progn
  (setf *compile-print* nil)
  (setf *load-print* nil)
  (lw:toggle-source-debugging nil)
  )


;;; Load up definitions

(defvar *lisp-source-file-type* ".lisp")
(defvar *lisp-binary-file-type*
  #+lucid
  (namestring (make-pathname :type (car lcl:*load-binary-pathname-types*)))
  #+allegro
  (concatenate 'string "." excl:*fasl-default-type*)
  #+cmu
  (concatenate 'string "." (c:backend-fasl-file-type c:*backend*))
  #+akcl
  ".o"
  #+(or sbcl mcl)
  ".fasl"
  #+lispworks
  ".wfasl"
  #+wcl
  ".o"
  #+clisp
  ".fas"
  #+ccl
  ".dx64fsl"
  #-(or sbcl lucid allegro cmu akcl mcl ccl lispworks wcl clisp)
  (error "Don't know how to initialize *LISP-BINARY-FILE-TYPE*.")
  )

(defvar *lisp-implementation-name* (lisp-implementation-type))




;;; Note that this assumes that the current directory is $Y2.
;;; Environment variables in pathnames may not be supported by the
;;; host Lisp.

#-mcl (progn
        (defvar *support-directory* "cl-support/")
        (defvar *support-binary-directory*
          (concatenate 'string 
                       *support-directory* 
                       *lisp-implementation-name*
                       "/")))

(defun load-cl-file (filename)
  (let ((source-file (concatenate 'string
				  *support-directory*
				  filename
				  *lisp-source-file-type*)))
    (load source-file)))


;;; Do NOT change the load order of these files.

(load-cl-file "cl-setup")
(load-cl-file "cl-support")
(load-cl-file "cl-definitions")
(load-cl-file "cl-types")
(load-cl-file "cl-structs")
(load-cl-file "foreign")


;;; It would be nice if at this point we could switch *package*
;;; over to the right package.  But because *package* is rebound while 
;;; this file is being loaded, it will get set back to whatever it was 
;;; anyway.  Bummer.  Well, let's at least make the package that we want 
;;; to use.

(defpackage "MUMBLE-USER"
  (:use "MUMBLE"))


;;; Compile and load the rest of the system.  (The Lucid compiler is fast
;;; enough to make it practical to compile things all the time.)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (setf *package* (find-package "MUMBLE-USER")))

(load "$Y2/support/system")
(compile-haskell)


;;; All done

(write-line "Remember to do (in-package \"MUMBLE-USER\")!")
