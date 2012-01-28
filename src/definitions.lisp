(in-package #:cronies)

;;;;;;;;;;;;;
;; globals ;;
;;;;;;;;;;;;;

(defvar *jscript-templates* (make-hash-table :test #'equal)) ;place where all compiled javascript templates are
(defvar *debugging* nil)                ;if true debug messages will be printed

;;;;;;;;;;;;;;;
;; templates ;;
;;;;;;;;;;;;;;;

(recompile-all-templates)

;;;;;;;;;;;;;;;;
;; postmodern ;;
;;;;;;;;;;;;;;;;

(cl-postgres:set-sql-datetime-readers
 :timestamp-with-timezone               ;timestamp with time zone type does not work without this
 #'(lambda (stamp)
     (+ (/ stamp 1000000) (encode-universal-time 0 0 0 1 1 2000 0))))

;;;;;;;;;;;;;
;; logging ;;
;;;;;;;;;;;;;

(log5:defoutput formated-time
    (datetime-isoformat (get-universal-time)))

(log5:defcategory debug)

(log5:start-sender '*default-log-sender* (log5:stream-sender :location *log-file*) :category-spec '(log5:info+ debug) :output-spec '(formated-time log5:category log5:message))

(defmethod restas:render-object :before (designer object)
  (when *debugging*
    (hunchentoot:no-cache)))

;;;;;;;;;;;;;
;; content ;;
;;;;;;;;;;;;;

(defclass page ()
  ((content-type :accessor page-content-type
                 :initarg :content-type
                 :documentation "Content type to return in HTTP header")
   (scripts :accessor page-scripts
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

;;;;;;;;;;;;;
;; drawers ;;
;;;;;;;;;;;;;

(defclass drawer ()
  ())

(defclass ajax-drawer (drawer)
  ())