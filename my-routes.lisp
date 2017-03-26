;;;; my-routes.lisp

(in-package #:my-routes)

;;; "my-routes" goes here. Hacks and glory await!

;;; Subclass ACCEPTOR
(defclass vhost (hunchentoot:acceptor)
  ;; slots
  ((dispatch-table
    :initform '()
    :accessor dispatch-table
    :documentation "List of dispatch functions"))
  ;; options
  (:default-initargs                   ; default-initargs must be used
   :address "127.0.0.1"))              ; because ACCEPTOR uses it

;;; Specialise ACCEPTOR-DISPATCH-REQUEST for VHOSTs
(defmethod hunchentoot:acceptor-dispatch-request ((vhost vhost) request)
  ;; try REQUEST on each dispatcher in turn
  (mapc (lambda (dispatcher)
          (let ((handler (funcall dispatcher request)))
            (when handler ; Handler found. FUNCALL it and return result
              (return-from tbnl:acceptor-dispatch-request (funcall handler)))))
        (dispatch-table vhost))
  (call-next-method))

;;; ======================================================================
;;; Now all we need to do is test it

;;; Instantiate VHOSTs
(defvar vhost1 (make-instance 'vhost :port 5000))

;;; Populate each dispatch table
(push
 (hunchentoot:create-prefix-dispatcher "/foo" 'foo1)
 (dispatch-table vhost1))
(push
 (hunchentoot:create-prefix-dispatcher "/bar" 'bar)
 (dispatch-table vhost1))

;;; Define handlers
(defun foo1 () "Hello everyone")
(defun bar () "Weeeeeeeeeee!!!")

;;; Start VHOSTs
(hunchentoot:start vhost1)
