(load "svg-writer")

(with-open-file (*standard-output* "random_walk.svg"
				   :direction :output
				   :if-exists :supersede)
  (svg (loop repeat 10
	  do (polygon (append '((0 . 200))
			      (loop for x from 0
				 for y in (random-walk 100 400)
				 collect (cons x y))
			      '((400 . 200)))
		      (loop repeat 3
			 collect (random 256))))))