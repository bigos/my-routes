(in-package #:my-routes)

;;; move to server
(defun create-custom-dispatcher (prefix handler)
  "Creates a request dispatch function which will dispatch to the
function denoted by HANDLER if the file name of the current request
starts with the string PREFIX."
  (lambda (request)
    (let ((mismatch (mismatch (hunchentoot::script-name request) prefix
                              :test #'char=)))
      (and (or (null mismatch)
               (>= mismatch (length prefix)))
           handler))))

;;; list of functions for adding to the dispatch-table
(server:add-routes
 (list (create-custom-dispatcher "/foo" 'handlers::foo1)
       (create-custom-dispatcher "/baz" 'handlers::baz)
       (create-custom-dispatcher "/bar" 'handlers::bar)))

;;; Start VHOST
(server:restart-acceptor)
