;;; Solutions to exercises in Chapter 14 of the book "COMMON LISP: An
;;; Interactive Approach"

(in-package :ch14)

;;; Exercise 14.2
(defun div142 (x y)
  (if (= y 0)
      9999999999
      (/ x y)))

;;; Exercise 14.3
;;;
;;; (absval -0.0) ==> -0.0
;;; (absval 0.0) ==> 0.0
;;; (eql 0.0 -0.0) ==> NIL
;;; (equal 0.0 -0.0) ==> NIL
;;; (= 0.0 -0.0) ==> T
;;; (eql -0 0) ==> T
(defun absval (n)
  "Returns the absolute value of the argument, which must be a number."
  (if (< n 0) (- n) n))

;;; Exercise 14.4
(defun sign (n)
  "Takes a numeric argument and returns - if it is negative, 0 if it is zero,
and + if it is positive."
  (if (< n 0)
      '-
      (if (= n 0) 0 '+)))

;;; Exercise 14.5
(defun sign2 (n)
  "Takes a numeric argument and returns - if it is negative, 0 if it is zero,
and + if it is positive."
  (cond ((< n 0) '-)
	((= n 0) 0)
	((> n 0) '+)))