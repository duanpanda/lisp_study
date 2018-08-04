;;; Solutions to exercises in Chapter 13 of the book "COMMON LISP: An
;;; Interactive Approach"

(in-package :test)

;;; Exercise 13.4
(defun foo (x y)
  (and (not (= y 0)) (> (/ x y) 100)))

;;; Exercise 13.5
(defun five-more-p (x)
  (and (or (stringp x) (listp x))
       (> (length x) 5)))

;;; Exercise 13.6
(defun <= (x y)
  "Returns T if the first number is less than or equal to the second number;
NIL otherwise."
  (or (< x y) (= x y)))

;;; Exercise 13.7
;;;
;;; (eql o nil) is also OK.
(defun null (o)
  "Returns T if O is NIL, and NIL otherwise."
  (equal o nil))

;;; Exercise 13.9
(defun consp (o)
  "Returns T if the argument is nonempty list and NIL otherwise."
  (and (listp o) (> (length o) 0)))
(defun nonempty-list-p (x)
  "Returns T if X is a nonempty list, and NIL otherwise."
  (eql (type-of x) (type-of '(1))))

;;; Exercise 13.10
;;;
;;; (eql o nil) is also OK.
(defun not (o)
  "Returns T if O is NIL; NIL if o is T."
  (equal o nil))
