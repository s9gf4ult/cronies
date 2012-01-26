(in-package #:cronies)

(defvar *active-database-versions* (make-hash-table))
(defvar *databases* (make-hash-table :test #'equal))

(defclass model ()
  ((name :initarg :name :accessor model-name)
   (colons :initarg :colons :accessor model-colons)
   (constraints :initarg :constraints :accessor :model-constraints))
  (:documentation "class represent model attached to some version of some database"))

(defun append-database (name)
  "Append database to global store if it does not exists"
  (multiple-value-bind (val has) (gethash name *databases*)
    (unless has
      (setf (gethash name *databases*)
            (make-hash-table)))))

(defmacro defdatabase (name)
  "Define new database by name"
  (with-gensyms (evaled)
    `(let ((,evaled ,name))
       (append-database ,evaled))))

