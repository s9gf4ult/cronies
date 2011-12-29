(in-package #:cronies)

(defun main(&key (host "127.0.0.1") (port 8080))
  (recompile-all-templates)
  (restas:start '#:cronies
                :port port
                :hostname host))
