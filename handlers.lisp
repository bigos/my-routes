(defpackage :handlers
  (:use :cl :hunchentoot))

(in-package :handlers)

;;; Define handlers
(defun foo1 (&rest args) "Hello everyone")
(defun bar  (&rest args) (format nil "Weeeeeeeeeee yay!!! ~A" args))
(defun baz  (&rest args) (format nil "Baaaz ~A" args))
