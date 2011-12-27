(in-package #:cronies)


(defvar *site-directory* (fad:pathname-as-directory
                          #P"/home/razor/work/cronies/"))

(defvar *js-files-directory* (fad:pathname-as-directory
                              (merge-pathnames
                               *site-directory*
                               #P"js")))

(defvar *css-files-directory* (fad:pathname-as-directory
                               (merge-pathnames
                                *site-directory*
                                #P"css")))

(defvar *log-file* (fad:pathname-as-directory
                    (merge-pathnames
                     *site-directory*
                     #P"cronies.log")))

(defvar *debugging* nil)