(in-package #:my-routes)

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
