(asdf:defsystem #:cronies
  :depends-on (#:restas #:hunchentoot #:closure-template #:log5)
  :components ((:file "package")
               (:file "routes" :depends-on ("settings" "logging" "templates"))
               (:file "main" :depends-on ("routes"))
               (:file "settings" :depends-on ("package"))
               (:file "logging" :depends-on ("package" "settings"))
               (:file "templates" :depends-on ("package" "settings"))
               ))