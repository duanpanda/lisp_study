(defpackage :test
  (:use :common-lisp))

(in-package :test)

(defun foo (x y)
  (and (not (= y 0)) (> (/ x y) 100)))