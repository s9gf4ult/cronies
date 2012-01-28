(in-package #:cronies)

;;;;;;;;;;;;;
;; logging ;;
;;;;;;;;;;;;;

(defmacro debug-print (message &rest args)
  `(when *debugging*
     (log5:log-for (debug) ,message ,@args)))

(defmacro warning-print (message &rest args)
  `(log5:log-for (log5:warn) ,message ,@args))

;;;;;;;;;;;;
;; routes ;;
;;;;;;;;;;;;

(defmacro define-file-downloader (route-name route file-name directory-pathspec)
  `(define-route ,route-name (,route)
     (let ((fname
            (fad:file-exists-p
             (merge-pathnames
              (make-pathname :name      (car (last ,file-name))
                             :directory (cons :relative (subseq ,file-name 0 (- (length ,file-name) 1))))
              (fad:pathname-as-directory ,directory-pathspec)))))
       (if fname
           (progn
             (debug-print ,(format nil "~a: fname is ~~a" route-name) fname)
             (setf (hunchentoot:content-type*) (hunchentoot:mime-type fname))
             fname)
           (progn
             (warning-print ,(format nil "~a: requested file name is NIL, path is ~~a" route-name) ,file-name)
             404)))))

;;;;;;;;;;;;;
;; storage ;;
;;;;;;;;;;;;;

(defmacro with-browser-session (varname &body body)
  `(let ((,varname (hunchentoot:cookie-in "session")))
     (when ,varname
       ,@body)))

;;;;;;;;;;;;
;; common ;;
;;;;;;;;;;;;

(defmacro prependf (&rest args)
  (let ((target (lastcar args))
        (elts (subseq args 0 (1- (length args)))))
    (let ((elements (mapcar #'(lambda (a)
                                (if (listp a)
                                    a
                                    `(list ,a))) elts)))
      `(setf ,target
             (append ,@elements ,target)))))