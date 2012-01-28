
(in-package #:cronies)

(defprepared get-user-by-session
    "select u.* from users as u
inner join session_parameter as p on p.table_reference = u.id
inner join session as s on p.session_id = s.id
where p.name = 'user' and s.uuid = $1"
  :plist)

(defprepared get-session-parameter
    "select p.* from
session_parameter as p inner join session as s on p.session_id = s.id
where s.uuid = $1 and p.name = $2"
  :plist)

(defprepared get-participant-by-session
    "select pt.* from
participant as pt inner join session_parameter as p on p.table_reference = pt.id
inner join session as s on p.session_id = s.id
where p.name = 'participant' and s.uuid = $1"
  :plist)


(defun session-user ()
  (with-browser-session uuid
    (get-user-by-session uuid)))

(defun session-guest ()
  (with-browser-session uuid
    (get-session-parameter uuid "guest")))

(defun session-participant ()
  (with-browser-session uuid
    (get-participant-by-session uuid)))

(defun loginedp ()
  "Return t if session set in cookies and exists in database"
  (when (or (session-guest)
            (session-user)
            (session-participant))
    t))

(defun format-date (universal-time)
  "return string representing universal time as iso formated string"
  (apply #'format nil "~a-~a-~a ~a:~a:~a" (reverse
                                           (subseq
                                            (multiple-value-list (decode-universal-time universal-time))
                                            0 6))))

(defprepared-with-names create-session (&key (creation-date (get-universal-time))
                                             (expiration-interval 172800)) ;this is just two days in seconds (default)
                                             
    ((:insert-into 'session :set
                   'uuid '$1
                   'creation_date '$2
                   'expiration_date '$3
                   :returning 'id 'uuid) (write-to-string (make-v4-uuid)) (format-date creation-date) (format-date (+ creation-date expiration-interval)))
    :plist)

(defmacro generate-pairs (&rest names)
  "Generate form returning list of sequence quoted symbol then symbol if value of symbol is not nil"
  `(append
    ,@(loop for name in names collect `(when ,name (list ',name ,name)))))

(defun make-hexdigest (value)
  (ironclad:byte-array-to-hex-string
   (ironclad:digest-sequence :sha1 (trivial-utf-8:string-to-utf-8-bytes value)))) ;trivial-utf-8 is the package from postmodern

(defun salt-password (password)
  (let* ((u (write-to-string (make-v4-uuid)))
         (s (make-hexdigest (format nil "~a:~a" u password))))
    (format nil "~a:~a" u s)))

(defun check-password (salted password)
  (let ((splited (ppcre:split ":" salted)))
    (unless (= 2 (length splited))
      (error "salted part has 0 or more that 1 : character"))
    (let ((u (first splited))
          (h (second splited)))
      (equal h (make-hexdigest (format nil "~a:~a" u password))))))

(defun create-user (login password &key name email)
  "Create user, name and email is not required"
  (query `(:insert-into 'users :set
                        'login ,login
                        'password ,(salt-password password)
                        ,@(generate-pairs name email)
                        :returning 'id 'name 'login 'email 'creation_date 'deleted)
         :plist))