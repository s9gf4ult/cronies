(in-package #:cronies)


(defvar *site-directory* (fad:pathname-as-directory
                          (asdf:system-source-directory '#:cronies)))

(defvar *js-files-directory* (fad:pathname-as-directory
                              (merge-pathnames
                               #P"js/"
                               *site-directory*)))

(defvar *css-files-directory* (fad:pathname-as-directory
                               (merge-pathnames
                                #P"css/"
                                *site-directory*)))

(defvar *images-files-directory* (fad:pathname-as-directory
                                  (merge-pathnames
                                   #P"images/"
                                   *site-directory*)))

(defvar *log-file* (fad:pathname-as-file
                    (merge-pathnames
                     #P"cronies.log"
                     *site-directory*)))

(defvar *templates-directory* (fad:pathname-as-directory
                               (merge-pathnames
                                #P"tmpl/"
                                *site-directory*)))

(defvar *js-templates-directory* (fad:pathname-as-directory
                                  (merge-pathnames
                                   #P"js/"
                                   *templates-directory*)))

(defvar *cl-templates-directory* (fad:pathname-as-directory
                                  (merge-pathnames
                                   #P"cl/"
                                   *templates-directory*)))

(defvar *common-templates-directory* (fad:pathname-as-directory
                                      (merge-pathnames
                                       #P"common/"
                                       *templates-directory*)))

(defvar *jscript-templates* (make-hash-table :test #'equal))
                                

(defvar *debugging* nil)