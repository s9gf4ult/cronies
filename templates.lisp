(in-package #:cronies)

(defun compile-template-lisp-from-file (path)
  (prog1
      (closure-template:compile-template
       :common-lisp-backend
       (reduce #'(lambda (a b) (concatenate 'string a b)) ;конкатенируем строки в файле
               (with-open-file (fin path :direction :input)
                 (loop for line = (read-line fin nil :eof)
                    until (eql line :eof)
                    collect line))))
    (log5:log-for (log5:info) "template ~a compiled by common lisp backend" path)))

(defun compile-template-jscript-from-file (path)
  (setf (gethash (pathname-name         ;результат компиляции в таблицу, ключ - имя файла
                  (fad:pathname-as-file
                   path))
                 *jscript-templates*)
        (prog1
            (closure-template:compile-template
             :javascript-backend
             (reduce #'(lambda (a b) (concatenate 'string a b)) ;коекатенируем все строки в файле
                     (with-open-file (fin path :direction :input)
                       (loop for line = (read-line fin nil :eof)
                          until (eql line :eof)
                          collect line))))
          (log5:log-for (log5:info) "template ~a compiled by javascript backend" path))))
  
(defun compile-template-common-from-file (path)
  (compile-template-lisp-from-file path)
  (compile-template-jscript-from-file path))

(defun walk-templates (dirpath func)
  (fad:walk-directory dirpath
                      #'(lambda (path)
                          (let ((ftype (pathname-type
                                        (fad:pathname-as-file
                                         path))))
                            (when (equal (string-downcase ftype) "soy") ;если тип файла - soy то вызываем функию компиляции
                              (funcall func path))))))
                          

(defun recompile-all-templates ()
  (walk-templates *cl-templates-directory* #'compile-template-lisp-from-file)
  (walk-templates *js-templates-directory* #'compile-template-jscript-from-file)
  (walk-templates *common-templates-directory* #'compile-template-common-from-file))

(recompile-all-templates)