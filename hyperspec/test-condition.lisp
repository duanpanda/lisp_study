;; test for SIGNAL
(defun handle-division-conditions (condition)
  (format t "Considering condition for division condition handling~%")
  (when (and (typep condition 'arithmetic-error)
	     (eq '/ (arithmetic-error-operation condition)))
    (invoke-debugger condition)))

(defun handle-other-arithmetic-errors (condition)
  (format t "Considering condition for arithmetic condition handling~%")
  (when (typep condition 'arithmetic-error)
    (abort)))

(define-condition a-condition-with-no-handler (condition) ())

(signal 'a-condition-with-no-handler)

(handler-bind ((condition #'handle-division-conditions)
	       (condition #'handle-other-arithmetic-errors))
  (signal 'a-condition-with-no-handler))

(handler-bind ((arithmetic-error #'handle-division-conditions)
	       (arithmetic-error #'handle-other-arithmetic-errors))
  (signal 'arithmetic-error :operation '* :operands '(1.2 b)))

;;------------------------------------------------------------------------------

;; test for HANDLER-CASE
(defun assess-condition (condition)
  (handler-case (signal condition)
    (warning () "Lots of smoke, but no fire.")
    ((or arithmetic-error control-error cell-error stream-error)
        (condition)
      (format nil "~S looks especially bad." condition))
    (serious-condition (condition)
      (format nil "~S looks serious." condition))
    (condition () "Hardly worth mentioning.")))

(assess-condition (make-condition 'stream-error :stream *terminal-io*))

(define-condition random-condition (condition) () 
  (:report (lambda (condition stream)
	     (declare (ignore condition))
	     (princ "Yow" stream))))

(assess-condition (make-condition 'random-condition))

;; (handler-case form
;;    (type1 (var1) . body1)
;;    (type2 (var2) . body2) ...)
;;
;; is equivalent to
;;
;; (block #1=#:g0001
;;   (let ((#2=#:g0002 nil))
;;     (tagbody
;;        (handler-bind ((type1 #'(lambda (temp)
;; 				 (setq #1# temp)
;; 				 (go #3=#:g0003)))
;;                       (type2 #'(lambda (temp)
;; 				 (setq #2# temp)
;; 				 (go #4=#:g0004))) ...)
;; 	 (return-from #1# form))
;;        #3# (return-from #1# (let ((var1 #2#)) . body1))
;;        #4# (return-from #1# (let ((var2 #2#)) . body2)) ...)))

;; (handler-case form
;;    (type1 (var1) . body1)
;;    ...
;;    (:no-error (varN-1 varN-2 ...) . bodyN))
;; is equivalent to
;;
;; (block #1=#:error-return
;;   (multiple-value-call #'(lambda (varN-1 varN-2 ...) . bodyN)
;;     (block #2=#:normal-return
;;       (return-from #1#
;; 	(handler-case (return-from #2# form)
;; 	  (type1 (var1) . body1) ...)))))

;;------------------------------------------------------------------------------

;; test HANDLER-BIND

(defun trap-error-handler (condition)
  (format *error-output* "~&~A~&" condition)
  (throw 'trap-errors nil))

(defmacro trap-errors (&rest forms)
  `(catch 'trap-errors
     (handler-bind ((error #'trap-error-handler))
       ,@forms)))

(list (trap-errors (signal "Foo.") 1)
      (trap-errors (error  "Bar.") 2)
      (+ 1 2))

;;------------------------------------------------------------------------------

;; test IGNORE-ERRORS

(defun load-init-file (program)
  (let ((win nil))
    (ignore-errors ;if this fails, don't enter debugger
      (load (merge-pathnames (make-pathname :name program :type :lisp)
			     (user-homedir-pathname)))
      (setq win t))
    (unless win (format t "~&Init file failed to load.~%"))
    win))

(load-init-file "no-such-program")

;; (ignore-errors . forms)
;; 
;; is equivalent to:
;;
;; (handler-case (progn . forms)
;;  (error (condition) (values nil condition)))

;;------------------------------------------------------------------------------

;; my test

(defun foo (x y)
;  (/ x y))
  (signal 'arithmetic-error :operands '(1 0) :operation '*))

(defun bar (a b)
  (foo a b))

(defun baz (a b)
  (signal 'file-error :pathname (make-pathname :directory `(:absolute ,a)
					       :name `,b)))
(handler-case (bar 1 0)
  (arithmetic-error () (format t "Considering arithmetic-error.~%"))
  (error () (format t "Considering general error.~%")))

(handler-case (bar 1 0)
  (arithmetic-error (e) (handle-division-conditions e))
  (arithmetic-error (e) (handle-other-arithmetic-errors e)))

(handler-bind ((arithmetic-error #'handle-division-conditions)
	       (arithmetic-error #'handle-other-arithmetic-errors))
  (bar 1 0))

(handler-bind ((arithmetic-error #'handle-other-arithmetic-errors))
  (format t "Oh, yeah~%")
  (handler-bind ((arithmetic-error #'handle-division-conditions))
    (bar 1 0)))

(handler-bind ((error #'(lambda (condition)
			  (format t "outmost handler for~&~A~%" condition)
			  (abort))))
  (handler-bind ((arithmetic-error #'handle-division-conditions)
		 (arithmetic-error #'handle-other-arithmetic-errors))
    (baz "home" "ryan")))

(defun test1 ()
  (handler-case (bar 1 0)
    (arithmetic-error (e) (handle-division-conditions e))))

(defun test2 ()
  (handler-bind ((arithmetic-error #'handle-division-conditions))
    (bar 1 0)))

(time (dotimes (i 10000) (test1)))
;;;; Evaluation took:
  ;; 0.126 seconds of real time
  ;; 0.124007 seconds of total run time (0.120007 user, 0.004000 system)
  ;; 98.41% CPU
  ;; 234,641,176 processor cycles
  ;; 11,896,064 bytes consed

(time (dotimes (i 10000) (test2)))
;;;; Evaluation took:
  ;; 0.198 seconds of real time
  ;; 0.192012 seconds of total run time (0.176011 user, 0.016001 system)
  ;; 96.97% CPU
  ;; 369,849,074 processor cycles
  ;; 13,046,904 bytes consed
