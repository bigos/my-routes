(in-package #:my-routes)

(defun split-by-slash (string)
  (loop for i = 0 then (1+ j)
     as j = (position #\/ string :start i)
     collect (subseq string i j)
     while j))

(defun build-regex (str)
  (let ((chunks (cdr (split-by-slash str))))
    (with-output-to-string (s)
      (loop for p in (mapcar
                      (lambda (c) (if (equal (subseq c 0 1) ":") "\w*" c))
                      chunks)
         do (format s "~a/~A" "\\"  p)))))

;;; regexp can be converted to parse tree using
;;; (cl-ppcre:parse-string "/ala/.*/kota" )
;;; parse tree can replace regexp
(cl-ppcre:all-matches-as-strings '(:SEQUENCE "/ala/" (:GREEDY-REPETITION 0 NIL :EVERYTHING) "/kota")  "/ala/ma/kota")

;;; list of functions for adding to the dispatch-table
(server:add-routes
 (list (server:create-custom-dispatcher "/foo" 'handlers::foo1)
       (server:create-custom-dispatcher "/baz" 'handlers::baz)
       (server:create-custom-dispatcher "/bar" 'handlers::bar)))

;;; Start VHOST
(server:restart-acceptor)
