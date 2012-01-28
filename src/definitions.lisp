(in-package #:cronies)

(cl-postgres:set-sql-datetime-readers
 :timestamp-with-timezone               ;timestamp with time zone type does not work without this
 #'(lambda (stamp)
     (+ (/ stamp 1000000) (encode-universal-time 0 0 0 1 1 2000 0))))

(defclass page ()
  ((scripts :accessor page-scripts
            :initform ()
            :initarg :scripts
            :documentation "List of strings with scripts")
   (src-scripts :accessor page-src-scripts
                :initform ()
                :initarg :src-scripts
                :documentation "List of URI to include scripts into the page")
   (styles :accessor page-styles
           :initform ()
           :initarg :styles
           :documentation "List of strings with styles")
   (src-styles :accessor page-src-styles
               :initform ()
               :initarg :src-styles
               :documentation "List of URI to include styles into the page")
   (content  :accessor page-content
             :initform ""
             :initarg :content
             :documentation "Content of the body tag")))
             
(defclass index-page (page)
  ())

(defclass login-page (page)
  ((next :accessor login-page-next
         :initform ""
         :initarg :next
         :documentation "Path to go after login")))
