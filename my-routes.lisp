(in-package #:my-routes)

;;; list of functions for adding to the dispatch-table
(server:add-routes
 (list (server:create-custom-dispatcher "/foo" 'handlers::foo1)
       (server:create-custom-dispatcher "/baz/:subj/has/:obj" 'handlers::baz)
       (server:create-custom-dispatcher "/bar" 'handlers::bar)))

;;; Start VHOST
(server:restart-acceptor)
