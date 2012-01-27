(in-package #:cronies)

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

(defmethod render-object ((designer ajax-drawer) (obj page)) t) ;to stop general method combination at this point

(defmethod render-object :around  ((designer ajax-drawer) (obj page))
  (call-next-method)
  (cronies.tpl:main (list :styles (page-styles obj)
                          :src_styles (page-src-styles obj)
                          :scripts (page-scripts obj)
                          :src_scripts (page-src-scripts obj)
                          :body (page-content obj))))

(defmethod render-object :before ((designer ajax-drawer) (obj page))
  (appendf (page-src-styles obj)
           '("/css/main.css"))
  (appendf (page-src-scripts obj)
           '("/js/jquery.js"
             "/js/main.js"))) 

(defmethod render-object :before ((designer ajax-drawer) (obj index-page))
  (declare (ignore designer))
  (setf 
   (page-content obj)
   (cronies.tpl:index)))

(defmethod render-object :before ((designer ajax-drawer) (obj login-page))
  