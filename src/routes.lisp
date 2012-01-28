(in-package #:cronies)


(define-file-downloader download/js "/js/*file-name" file-name *js-files-directory*)
(define-file-downloader download/css "/css/*css-file" css-file *css-files-directory*)
(define-file-downloader download/images "/images/*image-file" image-file *images-files-directory*)

(define-route login-route ("/login/next/:path")
  (debug-print "route login called with next path ~a" path)
  (make-instance 'login-page :next path))

(define-route main-route ("")
  (debug-print "main route called")
  (if (loginedp)
      (make-instance 'index-page)
      (redirect login-route :path "")))
