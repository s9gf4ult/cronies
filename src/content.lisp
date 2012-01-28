(in-package #:cronies)


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
  