(in-package #:my-routes)

;;; list of functions for adding to the dispatch-table
(server:add-routes
 (list (hunchentoot:create-prefix-dispatcher "/foo" 'handlers::foo1)
       (hunchentoot:create-prefix-dispatcher "/baz" 'handlers::baz)
       (hunchentoot:create-prefix-dispatcher "/bar" 'handlers::bar)))

;;; Start VHOST
(server:restart-acceptor)
