(in-package #:cronies)

(cl-postgres:set-sql-datetime-readers
 :timestamp-with-timezone               ;timestamp with time zone type does not work without this
 #'(lambda (stamp)
     (+ (/ stamp 1000000) (encode-universal-time 0 0 0 1 1 2000 0))))


(defun main (&key (host "127.0.0.1") (port 8080) (render-method (make-instance 'ajax-drawer))
             (database-host "127.0.0.1") (database-user "test") (database-passwd "test") (database-name "test"))
  (recompile-all-templates)
  (setf *default-render-method* render-method)
  (setf *database* (connect database-name database-user database-passwd database-host))
  (restas:start '#:cronies
                :port port
                :hostname host))