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

(defmethod restas:render-object ((designer ajax-drawer) (obj page)) t)

(defmethod restas:render-object :around  ((designer ajax-drawer) (obj page))
  (call-next-method)
  (cronies.tpl:main (list :styles (reverse (page-styles obj))
                          :src_styles (reverse (page-src-styles obj))
                          :scripts (reverse (page-scripts obj))
                          :src_scripts (reverse (page-src-scripts obj))
                          :body (page-content obj))))

(defmethod restas:render-object :before ((designer ajax-drawer) (obj page))
  (push "/css/main.css"
        (page-src-styles obj))
  (push "/js/right.js"
        (page-src-scripts obj))
  (push "/js/main.js"
        (page-src-scripts obj)))


(defmethod restas:render-object :before ((designer ajax-drawer) (obj index-page))
  (declare (ignore designer))
  (setf 
   (page-content obj)
   (cronies.tpl:index)))