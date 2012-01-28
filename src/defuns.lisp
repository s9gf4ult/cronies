(in-package #:cronies)

(defun concat-strings (delimiter &rest strings)
  (reduce #'(lambda (a b) (concatenate 'string a delimiter b)) strings))

(defun datetime-isoformat (univ-time)
  (apply #'format nil "~a-~2,'0D-~2,'0DT~2,'0D:~2,'0D:~2,'0D"
         (reverse 
          (subseq
           (multiple-value-list (decode-universal-time univ-time)) 0 6))))

