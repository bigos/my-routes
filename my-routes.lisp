(in-package #:my-routes)

;;; regexp can be converted to parse tree using
;;; (cl-ppcre:parse-string "/ala/.*/kota" )
;;; parse tree can replace regexp
(cl-ppcre:all-matches-as-strings '(:SEQUENCE "/ala/" (:GREEDY-REPETITION 0 NIL :EVERYTHING) "/kota")  "/ala/ma/kota")

;;; list of functions for adding to the dispatch-table
(server:add-routes
 (list (server:create-custom-dispatcher "/foo" 'handlers::foo1)
       (server:create-custom-dispatcher "/baz/:a/:b" 'handlers::baz)
       (server:create-custom-dispatcher "/bar" 'handlers::bar)))

;;; Start VHOST
(server:restart-acceptor)
