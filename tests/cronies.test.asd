(asdf:defsystem #:cronies.test
  :depends-on (#:lift #:cronies)
  :components ((:file "package")
               (:file "tests" :depends-on ("package"))))