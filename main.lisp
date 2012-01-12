(in-package #:cronies)

(defun main (&key (host "127.0.0.1") (port 8080) (render-method (make-instance 'ajax-drawer)))
  (recompile-all-templates)
  (setf *default-render-method* render-method)
  (restas:start '#:cronies
                :port port
                :hostname host))
