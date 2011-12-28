(in-package #:cronies)

(defun concat-strings (delimiter &rest strings)
  (reduce #'(lambda (a b) (concatenate 'string a delimiter b)) strings))