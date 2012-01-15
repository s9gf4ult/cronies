(in-package #:cronies)

(defmacro define-file-downloader (route-name route file-name directory-pathspec)
  `(restas:define-route ,route-name (,route)
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

(define-file-downloader download/js "/js/*file-name" file-name *js-files-directory*)
(define-file-downloader download/css "/css/*css-file" css-file *css-files-directory*)
(define-file-downloader download/images "/images/*image-file" image-file *images-files-directory*)

(restas:define-route main-route ("")
  (debug-print "main route called")
  (make-instance 'index-page))