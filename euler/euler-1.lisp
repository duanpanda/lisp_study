;;; If we list all the natural numbers below 10 that are multiples of 3 or 5,
;;; we get 3, 5, 6 and 9. The sum of these multiples is 23.  Find the sum of
;;; all the multiples of 3 or 5 below 1000.

(in-package :euler)

(defun p1-sum (n)
  "Find the sum of all the multiples of 3 or 5 below N."
  (apply #'+
	  (loop for i below n
	       when (or (= (rem i 3) 0)
			(= (rem i 5) 0))
	       collect i)))
(export 'p1-sum)

(defun p1-sum-imperative (n)
  (let ((sum 0))
    (loop for i below n
	 when (or (= (rem i 3) 0)
		  (= (rem i 5) 0))
	 do (incf sum i))
    sum))
(export 'p1-sum-imperative)

(defun p1-sum-recursive (n)
  (let ((i (1- n)))
    (if (< i 3)
	0
	(+ (if (or (= (rem i 3) 0) (= (rem i 5) 0))
	       i
	       0)
	   (p1-sum-recursive i)))))
(export 'p1-sum-recursive)

(defun p1-sum-reduce (n)
  (reduce #'+
	 (loop for i below n
	      when (or (= (rem i 3) 0)
		       (= (rem i 5) 0))
	      collect i)))
(export 'p1-sum-reduce)