(in-package #:cronies)

(defgeneric page-append-defaults (pg)
  (:documentation "append default things to the page object (like links to jquery and so on)"))

(defmethod page-append-defaults ((pg page))
  (prependf "/js/jquery.js"
            (page-src-scripts pg)))

(defgeneric render-page (pg)
  (:documentation "return string containing rendered page"))

(defmethod render-page ((pg page))
  (apply #'cronies.tpl:main
         (append (when (slot-boundp pg 'content-type)
                   (list :content-type (page-content-type pg)))
                 (list :src-styles (page-src-styles pg)
                       :src-scripts (page-src-scripts pg)
                       :styles (page-styles pg)
                       :scripts (page-scripts pg)
                       :body (page-content pg)))))

(defmethod render-object ((designer ajax-drawer) (obj index-page))
  (page-append-defaults obj)
  (setf (page-content obj)
        (cronies.tpl:index))
  (render-page obj))

(defmethod render-object ((designer ajax-drawer) (obj login-page))
  (page-append-defaults obj)
  (setf (page-content obj)
        "Страница с логином")
  (render-page obj))