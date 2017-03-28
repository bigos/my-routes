(defpackage :server
  (:use :common-lisp :cl-ppcre :hunchentoot)
  (:export :restart-acceptor
           :create-custom-dispatcher
           :add-routes))

(in-package :server)

;; Loosely based on the example from:
;; http://weitz.de/hunchentoot/#subclassing-acceptors

;;; Subclass ACCEPTOR
(defclass vhost (acceptor)
  ;; slots
  ((dispatch-table
    :initform '()
    :accessor dispatch-table
    :documentation "List of dispatch functions"))
  ;; options
  (:default-initargs                   ; default-initargs must be used
   :address "127.0.0.1"))              ; because ACCEPTOR uses it

;;; Instantiate VHOST
(defvar vhost1 (make-instance 'vhost :port 5000))

;;; Specialise ACCEPTOR-DISPATCH-REQUEST for VHOSTs
(defmethod acceptor-dispatch-request ((vhost vhost) request)
  ;; try REQUEST on each dispatcher in turn
  (mapc (lambda (dispatcher) ; as defined in the function create-custom-dispatcher
          (let ((handler (funcall dispatcher request)))
            (when handler ; Handler found. FUNCALL it and return result
              (return-from tbnl:acceptor-dispatch-request (funcall handler)))))
        (dispatch-table vhost))
  (call-next-method))

(defun create-custom-dispatcher (prefix handler)
  "Creates a request dispatch function which will dispatch to the
function denoted by HANDLER if the file name of the current request
starts with the string PREFIX."
  (lambda (request)
    (let ((mismatch (mismatch (script-name request) prefix
                              :test #'char=)))
      (and (or (null mismatch)
               (>= mismatch (length prefix)))
           handler))))

;;; the lambda from above becomes the route below

;;; Populate the dispatch table
(defun add-routes (route-function-list)
  ;; clear previously defined routes so we do not have to restart the server
  (setf (dispatch-table vhost1) '())
  ;; add route functions
  (loop for route in route-function-list
     do (push route (dispatch-table vhost1))))

;;; Start VHOST
(defun restart-acceptor ()
  (unless (hunchentoot::acceptor-shutdown-p vhost1)
    (stop vhost1))
  (start vhost1))
