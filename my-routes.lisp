(in-package #:my-routes)

(server::add-routes
 (list (hunchentoot:create-prefix-dispatcher "/foo" 'my-routes::foo1)
       (hunchentoot:create-prefix-dispatcher "/bar" 'my-routes::bar)))

;;; Define handlers
(defun foo1 () "Hello everyone")
(defun bar () "Weeeeeeeeeee yay!!!")

;;; Start VHOSTs
(server:restart-acceptor)
