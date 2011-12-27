(in-package #:cronies)

(restas:define-route download/js ("/js/:file-name"
                                  :requirement
                                  #'(lambda ()
                                      (let ((file-name (elt
                                                        (puri:uri-parsed-path
                                                         (puri:parse-uri
                                                          (hunchentoot:request-uri*)))
                                                        2)))
                                        (debug-print "testing route \"download/js\" with file ~a" file-name)
                                        (and (ppcre:scan "^.+\.js$" file-name)
                                             (fad:file-exists-p
                                              (merge-pathnames
                                               *js-files-directory*
                                               file-name))))))
  (debug-print "download/js route called")
  (merge-pathnames *js-files-directory* file-name))

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