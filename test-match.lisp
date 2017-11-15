;;; Test of the public functions in package "MATCH".

(in-package :cl-user)

(load "util")
(load "cl-unit")
(load "match")

(cl-unit:deftest test-match-element ()
  (cl-unit:check
   (eq (match:match-element 'a 'a) t)
   (eq (match:match-element 'a '?) t)
   (eq (match:match-element '? 'a) t)
   (equal (match:match-element 'a '?x) '(?x a))
   (equal (match:match-element '?x 'a) '(?x a))
   (eq (match:match-element 'a 'b) nil)))