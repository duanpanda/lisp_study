;;; Utilities

(in-package :util)

;;; Exercise 13.12
(defun elementp (object)
  "Return T if object is of type symbol, or character, or number, or package;
NIL otherwise.  Objects of these types are testable with eql, they can be
called \"element\" or \"elemental object\"."
  (or (symbolp object)
      (characterp object)
      (numberp object)
      (packagep object)))

(defmacro with-gensyms ((&rest names) &body body)
  `(let ,(loop for n in names collect `(,n (gensym)))
     ,@body))
