(load "wizards-game.lisp")

(defmacro game-action (command subj obj place &body body)
  (let ((subject (gensym))
	(object (gensym)))
    `(progn (defun ,command (,subject ,object)
	      (if (and (eq *location* ',place)
		       (eq ,subject ',subj)
		       (eq ,object ',obj)
		       (have ',subj))
		  ,@body
		  '(i cant ,command like that.)))
	    (pushnew ',command *allowed-commands*))))
