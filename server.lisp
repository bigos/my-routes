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

;;; ----------------------------------------------------------------------------
;;; helpers for extracting parameters from url

(defun split-by-slash (string)
  (cdr                                  ; urls start with slash
   (loop for i = 0 then (1+ j)
      as j = (position #\/ string :start i)
      collect (subseq string i j)
      while j)))

(defun starts-with-colon (str)
  (equal (subseq str 0 1) ":"))

(defun build-regex (str)
  (let ((chunks (split-by-slash str)))
    (with-output-to-string (s)
      (loop for p in (mapcar
                      (lambda (c) (if (starts-with-colon c) "\\w*" c))
                      chunks)
         do (format s "~a/~A" "\\"  p)))))

(defun build-args (regex-builder url)
  (loop
     for r in (split-by-slash regex-builder)
     for u in (split-by-slash url)
     when (starts-with-colon r)
     collect  u))
;;; ----------------------------------------------------------------------------

;;; Specialise ACCEPTOR-DISPATCH-REQUEST for VHOSTs
(defmethod acceptor-dispatch-request ((vhost vhost) request)
  ;; try REQUEST on each dispatcher in turn
  (mapc (lambda (dispatcher) ; as defined in the function create-custom-dispatcher
          (let ((handler-cons (funcall dispatcher request)))
            (when (car handler-cons) ; Handler found. FUNCALL it and return result
              (return-from tbnl:acceptor-dispatch-request (apply (car handler-cons)
                                                                   (cdr handler-cons))))))
        (dispatch-table vhost))
  (call-next-method))

(defun create-custom-dispatcher (regex-builder handler)
  "Creates a request dispatch function which will dispatch to the
function denoted by HANDLER if the file name of the current request
matches the CL-PPCRE regular expression REGEX."
  (let* ((regex (build-regex regex-builder))
         (scanner (create-scanner regex)))
    (lambda (request)
      (and (scan scanner (script-name request))
           (cons handler
                 (build-args regex-builder (script-name request)))))))

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
