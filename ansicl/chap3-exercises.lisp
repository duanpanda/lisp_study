;;; 1. Show the following lists in box notation
;;; one dot <==> one cons
'()				       ; nil, 0 cons
'(a)				       ; (a . nil)
'(a b)				       ; (a . (b . nil)), two conses

'(a b (c d))
'(a . (b . ((c . (d . nil)) . nil)))	; 5 conses

'(a (b (c (d))))
'(d . nil)				 ; '(d)
'((d . nil) . nil)			 ; '((d))
'(c . ((d . nil) . nil))		 ; '(c (d))
'(b . ((c . ((d . nil) . nil))))	 ; '(b (c (d)))
'(a . ((b . ((c . ((d . nil) . nil)))))) ; '(a (b (c (d)))), 5 conses

'(((a b) c) d)
'(a . (b . nil))			; '(a b)
'((a . (b . nil)) . (c . nil))		; '((a b) c)
'(((a . (b . nil)) . (c . nil)) . (d . nil)) ; '(((a b) c) d), 6 conses

'(a (b . c) . d)
'(a . ((b . c) . d))			; 3 conses

;;; Write a version of UION that preserves the order of the elements in the
;;; original lists.
;;; (new-union '(a b c) '(b a d)) => (a b c d)
(union '(a b c) '(b a d))
(defun new-union (&rest lists)
  (let ((acc nil))
    (dolist (lst lists)
      (dolist (elm lst)
	(pushnew elm acc :test #'equal)))
    (reverse acc)))

;;; Define a function that takes a list and returns a list indicating the
;;; number of times each (EQL) element appears, sorted from most common element
;;; to least common:
;;; (occurrences '(a b a d a c d c a)) =>
;;; ((a . 4) (c . 2) (d . 2) (b . 1))
(defun occurrences (lst)
  (let ((acc nil))
    (dolist (elm lst)
      (let ((rec (assoc elm acc)))
	(if rec
	    (incf (cdr rec))
	    (push (cons elm 1) acc))))
    (sort acc #'> :key #'cdr)))

;;; Why does (member '(a) '((a) (b))) return NIL?
(member '(a) '((a) (b)) :test #'equal)	; => ((A) (B))
(member 'a '((a) (b)) :key #'car) 	; => ((A) (B))

;;; Suppose the function POS+ takes a list and returns a list of each element
;;; plus its position:
;;; (POS+ '(7 5 1 4)) => (7 6 3 7)
;;; Define this function using (a) recursion, (b) iteration, (c) mapcar.
(defun pos+-helper (lst current-pos)
  (if (null lst)
      nil
      (cons (+ (car lst) current-pos) (pos+-helper (cdr lst) (+ current-pos 1)))))
(defun pos+-recursive (lst)
  (pos+-helper lst 0))
(setf (symbol-function 'pos+) #'pos+-recursive)

(defun pos+-iterative (lst)
  (let ((result '()))
    (do ((i 0 (+ i 1)))
	((>= i (length lst)) (reverse result))
      (push (+ i (nth i lst)) result))))
(setf (symbol-function 'pos+) #'pos+-iterative)

(defun range (n)
  (let ((result '()))
    (do ((i (- n 1) (- i 1)))
	((< i 0) result)
      (setf result (cons i result)))))
(defun pos+-mapcar (lst)
  (mapcar #'+ lst (range (length lst))))
(setf (symbol-function 'pos+) #'pos+-mapcar)
