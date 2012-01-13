(in-package #:cronies)

(log5:defoutput formated-time
    (multiple-value-bind (sec min h day mon year) (get-decoded-time)
      (format nil "~a-~a-~a ~a:~a:~a" year mon day h min sec)))

(log5:defcategory debug)

(defmacro debug-print (message &rest args)
  `(when *debugging*
     (log5:log-for (debug) ,message ,@args)))

(defmacro warning-print (message &rest args)
  `(log5:log-for (log5:warn) ,message ,@args))

(log5:start-sender '*default-log-sender* (log5:stream-sender :location *log-file*) :category-spec '(log5:info+ debug) :output-spec '(formated-time log5:category log5:message))


(defmethod restas:render-object :before (designer object)
  (when *debugging*
    (hunchentoot:no-cache)))