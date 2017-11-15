;;; Solutions to exercises in Chapter 14 of the book "COMMON LISP: An
;;; Interactive Approach"

(in-package :ch15)

;;; 15.2
(defun sum0 (n1 n2)
  "Returns the sum of two nonnegative integers."
  (if (zerop n1) n2
      (sum0 (1- n1) (1+ n2))))

;;; 15.11
(defun sum (n1 n2)
  "Returns the sum of two nonnegative integers."
  (assert
   (and (integerp n1) (>= n1 0))
   (n1)
   "N1 must be a nonnegative integer, instead it's ~S."
   n1)
  (assert
   (integerp n2)
   (n2)
   "N2 must be an integer, instead it's ~S."
   n2)
  (if (zerop n1) n2
      (sum (1- n1) (1+ n2))))