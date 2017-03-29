(defpackage :handlers
  (:use :cl :hunchentoot))

(in-package :handlers)

;;; Define handlers
(defun foo1 (&rest args) "Hello everyone")
(defun bar  (&rest args)
  (format nil "Weeeeeeeeeee yay!!! ~A" args))
(defun baz  (&rest args)
  ;; this is the way of invoking a debugger
  ;; (cerror "debugging session" "tried ~a" args)
  (format nil "Baaaz ~A ~a" (request-method (car args)) (cdr args)))
