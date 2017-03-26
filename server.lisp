(defpackage :server
  (:use :common-lisp :cl-ppcre :hunchentoot)
  (:export :restart-acceptor
           :vhost
           :dispatch-table))

(in-package :server)

;; Loosely based on the example from:
;; http://weitz.de/hunchentoot/#subclassing-acceptors

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

;;; Instantiate VHOSTs
(defvar vhost (make-instance 'vhost :port 5000))

(defun restart-acceptor ()
  (if (hunchentoot::acceptor-shutdown-p vhost)
      (hunchentoot:start vhost)
      (progn (hunchentoot:stop vhost)
             (hunchentoot:start vhost))))

(defun add-routes (route-list)
  (loop for route in route-list
     do (push
         route
         (dispatch-table vhost))))

(defun list-routes ()
  (dispatch-table vhost))
