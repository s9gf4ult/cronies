(in-package #:cronies)

(defgeneric page-append-defaults (pg)
  (:documentation "append default things to the page object (like links to jquery and so on)"))

(defmethod page-append-defaults ((pg page))
  (prependf "/js/jquery.js"
            (page-src-scripts pg)))

(defgeneric render-page (pg)
  (:documentation "return string containing rendered page"))

(defmethod render-page ((pg page))
  (macrolet ((when-slot (slot-name accessor symbol)
               (with-gensyms (slot)
                 `(let ((,slot (and (slot-boundp pg ',slot-name)
                                    (,accessor pg))))
                    (when ,slot
                      (list ,symbol ,slot))))))
    (cronies.tpl:main
     (append (when-slot content-type page-content-type :content-type)
             (when-slot src-styles page-src-styles :src-styles)
             (when-slot src-scripts page-src-scripts :src-scripts)
             (when-slot styles page-styles :styles)
             (when-slot scripts page-scripts :scripts)
             (when-slot content page-content :body)))))

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