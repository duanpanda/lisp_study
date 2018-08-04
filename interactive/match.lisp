;;; Project 1 in the book "COMMON LISP: An Interactive Approach"

(in-package :match)

;;; Exercise 12.2
(defun variablep (s)
  "Returns T if the first character of the symbol's name is #\? and returns NIL
otherwise."
  (and (symbolp s) (eql (elt (symbol-name s) 0) #\?)))

;;; Exercise 13.13
;;; Exercise 14.8
(defun match-element (e1 e2)
  "Returns T if e1 and e2 are eql or either of them is the question-mark
symbol;
   if either is a variable (as recognized by variablep), returns a
two-member list whose first member is the variable and whose second member is
the other argument;
   otherwise returns NIL."
  (cond ((eql e1 e2) t)
	((or (dont-care e1) (dont-care e2)) t)
	((and (variablep e1) (not (variablep e2))) (list e1 e2))
	((and (not (variablep e1)) (variablep e2)) (list e2 e1))
	(t nil)))

;;; Exercise 14.7
;;;
;;; Don't define it as (eql s '?) because here '? will be interpreted as
;;; 'match::?, then if call (dont-care '?) in other package, it will return NIL.
(defun dont-care (s)
  "Returns T if s is a question-mark symbol and NIL in any other case."
  (and (symbolp s) (string= (symbol-name s) "?")))