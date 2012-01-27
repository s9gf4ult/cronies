(asdf:defsystem #:cronies
  :depends-on (#:restas #:hunchentoot #:closure-template #:log5 #:postmodern #:alexandria #:uuid #:ironclad #:ppcre)
  :components ((:file "package")
               (:file "routes" :depends-on ("settings" "logging" "templates"))
               (:file "storage" :depends-on ("package"))
               (:file "main" :depends-on ("routes" "drawers" "content"))
               (:file "settings" :depends-on ("package"))
               (:file "logging" :depends-on ("package" "settings"))
               (:file "templates" :depends-on ("package" "settings"))
               (:file "content" :depends-on ("package" "drawers" "templates"))
               (:file "drawers" :depends-on ("package"))
               ))
