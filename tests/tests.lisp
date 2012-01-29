(in-package #:cronies.test)

(defun run! ()
  (run-test :suite 'all-tests))

(deftestsuite all-tests ()
  ())

(addtest (all-tests)
  prependf
  (let ((var '(1 2)))
    (flet ((return-list ()
             (list 10 10))) 
      (cronies::prependf "test"
                         (list 5 6)
                         (return-list)
                         var)
      (ensure-same
       var
       '("test" 5 6 10 10 1 2)))))

(addtest (all-tests)
  datetime-isoformat
  (ensure-same
   "2012-10-02T12:07:56" (cronies::datetime-isoformat (encode-universal-time 56 7 12 2 10 2012))))

(addtest (all-tests)
  password-checking
  (let* ((passwd (write-to-string (uuid:make-v4-uuid)))
         (salted (cronies::salt-password passwd)))
    (ensure (cronies::check-password salted passwd))))

(addtest (all-tests)
  generate-pairs
  (let ((x 10)
        (y nil))
    (ensure-same (list 'x x) (cronies::generate-pairs x))
    (ensure-same nil (cronies::generate-pairs y))))