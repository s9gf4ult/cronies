(in-package #:cronies)

(restas:define-route download/js ("/js/*file-name")
  (let ((fname
         (merge-pathnames
          (make-pathname :name (car (last file-name))
                         :directory (cons :relative (subseq file-name 0 (- (length file-name) 1))))
          (fad:pathname-as-directory *js-files-directory*))))
    (debug-print "js route: fname is ~a" fname)
    fname))

(restas:define-route download/css ("/css/*file-name")
  (let ((fname
         (merge-pathnames
          (make-pathname :name (cdr (last file-name))
                         :directory (cons :relative (subseq file-name 0 (- (length file-name) 1))))
          (fad:pathname-as-directory *js-files-directory*))))
    (debug-print "css route: fname is ~a" fname)
    fname))
        
                                   

(restas:define-route main-route ("")
  (debug-print "main route called")
  "<h1>test</h1>")

