;;;; my-routes.asd

(asdf:defsystem #:my-routes
  :description "Describe my-routes here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:hunchentoot
               #:cl-who
               #:parenscript)
  :serial t
  :components ((:file "package")
               (:file "server")
               (:file "my-routes")))
