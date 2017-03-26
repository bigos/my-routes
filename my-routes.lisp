(in-package #:my-routes)

;;; clear previously defined routes so we do not have to restart the server all
;;; the time
(setf (server:dispatch-table server:vhost1) '())

;;; list of functions for adding to the dispatch-table
(server:add-routes
 (list (hunchentoot:create-prefix-dispatcher "/foo" 'my-routes::foo1)
       (hunchentoot:create-prefix-dispatcher "/baz" 'my-routes::baz)
       (hunchentoot:create-prefix-dispatcher "/bar" 'my-routes::bar)))

;;; Define handlers
(defun foo1 () "Hello everyone")
(defun bar () "Weeeeeeeeeee yay!!!")
(defun baz () "Baaaz")

;;; Start VHOST
(server:restart-acceptor)
