(defun maptree (tree f)
  (cond ((null tree) nil)
	((consp (car tree))
	 (cons (maptree (car tree) f) (maptree (cdr tree) f)))
	(t (cons (funcall f (car tree)) (maptree (cdr tree) f)))))