(defun lookup (key table)
  (let ((record (assoc key (cdr table))))
    (if record
	(cdr record)
	nil)))

;; (defun assoc (key records)
;;        (cond ((null records) false)
;; 	     ((equalp key (caar records)) (car records))
;; 	     (else (assoc key (cdr records)))))

(defun insert! (key value table)
  (let ((record (assoc key (cdr table))))
    (if record
	(rplacd record value)
	(rplacd table
		(cons (cons key value) (cdr table)))))
  (format t "insert [~A ~A]~%" key value)
  'ok)

(defun make-table ()
  (list '*table*))

(defun memoize (f)
  (let ((table (make-table)))
    (lambda (x)
      (let ((previously-computed-result (lookup x table)))
	(or previously-computed-result
	    (let ((result (funcall f x)))
	      (insert! x result table)
	      result))))))

(setf (symbol-function 'memo-fib)
  (memoize
   (lambda (n)
     (cond ((= n 0) 0)
	   ((= n 1) 1)
	   (t (+ (memo-fib (- n 1))
		 (memo-fib (- n 2))))))))

