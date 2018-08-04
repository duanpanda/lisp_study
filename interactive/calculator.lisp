(in-package :calculator)

(defun combine-expr (operator operand expression)
  "Returns the expression with the operator and operand applied to the first
member of the expression.  The expression is a list representing an arithmetic
expression.  For example, (combine-exptr '+ 3 '(5 - 6 * 8)) should evaluate
to ((3 + 5) - 6 * 8)."
  (cons (list operand operator (first expression)) (rest expression)))