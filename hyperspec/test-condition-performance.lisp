(defun handle-division-conditions (condition)
;  (format t "Considering condition for division condition handling~%")
  (when (and (typep condition 'arithmetic-error)
	     (eq '/ (arithmetic-error-operation condition)))
    (invoke-debugger condition)))

(defun foo (x y)
  (signal 'arithmetic-error :operands '(1 0) :operation '*))

(defun bar (a b)
  (foo a b))

(defun test1 ()
  (handler-case (bar 1 0)
    (arithmetic-error (e) (handle-division-conditions e))))

(defun test2 ()
  (handler-bind ((arithmetic-error #'handle-division-conditions))
    (bar 1 0)))

(defun profile-test1 ()
  (time (dotimes (i 100000) (test1))))
;; Evaluation took:
;;   0.164 seconds of real time
;;   0.168011 seconds of total run time (0.168011 user, 0.000000 system)
;;   [ Run times consist of 0.024 seconds GC time, and 0.145 seconds non-GC time. ]
;;   102.44% CPU
;;   306,284,202 processor cycles
;;   23,201,592 bytes consed

(defun profile-test2 ()
  (time (dotimes (i 100000) (test2))))
;; Evaluation took:
;;   0.567 seconds of real time
;;   0.568036 seconds of total run time (0.568036 user, 0.000000 system)
;;   [ Run times consist of 0.020 seconds GC time, and 0.549 seconds non-GC time. ]
;;   100.18% CPU
;;   1,055,957,504 processor cycles
;;   35,209,816 bytes consed
