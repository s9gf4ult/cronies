(asdf:defsystem #:cronies
  :depends-on (#:restas #:hunchentoot #:closure-template)
  :components ((:file "package")
               (:file "routes" :depends-on ("package"))
               (:file "main" :depends-on ("package" "routes"))
               ))