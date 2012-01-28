(asdf:defsystem #:cronies
  :depends-on (#:restas
               #:hunchentoot
               #:closure-template
               #:log5
               #:postmodern
               #:alexandria
               #:uuid
               #:ironclad
               #:cl-ppcre
               #:cl-fad)
  :components ((:file "package")
               (:file "macros" :depends-on ("package"))
               (:file "defuns" :depends-on ("macros"))
               (:file "settings" :depends-on ("package"))            ;variable definitions
               (:file "templates" :depends-on ("package"))       ;templates search complation and other functions
               (:file "definitions" :depends-on ("macros"
                                                 "defuns"
                                                 "settings"
                                                 "templates"))       ;some definitions to make stuffs work
               (:file "main" :depends-on ("definitions" "routes"))   ;where main function is
               (:file "routes" :depends-on ("definitions"))          ;route definitions 
               (:file "storage" :depends-on ("definitions"))         ;functions to get and put data from database
               (:file "content" :depends-on ("definitions"))         ;content rendering functions
               ))
