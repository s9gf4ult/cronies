(in-package #:cronies)

(restas:define-route download/js ("/js/*file-name")
                                  ;; :requirement
                                  ;; #'(lambda ()
                                  ;;     (let ((file-name (elt
                                  ;;                       (puri:uri-parsed-path
                                  ;;                        (puri:parse-uri
                                  ;;                         (hunchentoot:request-uri*)))
                                  ;;                       2)))
                                  ;;       (debug-print "testing route \"download/js\" with file ~a" file-name)
                                  ;;       (and (ppcre:scan "^.+\.js$" file-name)
                                  ;;            (fad:file-exists-p
                                  ;;             (merge-pathnames
                                  ;;              *js-files-directory*
                                  ;;              file-name))))))
  (debug-print "file name is ~a" file-name)
  (let ((fname
         (merge-pathnames
          (fad:pathname-as-directory *js-files-directory*)
          (fad:pathname-as-file (apply #'concat-strings "/" file-name)))))
          ;; (make-pathname :name (car (last file-name))
          ;;                :directory (cons :relative (subseq file-name 0 (- (length file-name) 1)))
          ;;                :device (pathname-device *js-files-directory*)
          ;;                :version (pathname-version *js-files-directory*)
          ;;                :host (pathname-host *js-files-directory*)))))
    (debug-print "fname is ~a" fname)))
                                     
                                

(restas:define-route download/css ("/css/:file-name"
                                   :requirement
                                   #'(lambda ()
                                       (let ((file-name (elt
                                                         (puri:uri-parsed-path
                                                          (puri:parse-uri
                                                           (hunchentoot:request-uri*)))
                                                         2)))
                                         (debug-print "testing route \"download/css\" with file ~a" file-name)
                                         (and (ppcre:scan "^.+\.css" file-name)
                                              (fad:file-exists-p
                                               (merge-pathnames
                                                *css-files-directory*
                                                file-name))))))
  (debug-print "download/css route called")
  (merge-pathnames *css-files-directory* file-name))

(restas:define-route main-route ("")
  (debug-print "main route called")
  "<h1>test</h1>")

