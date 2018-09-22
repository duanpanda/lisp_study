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
'(b . ((c . ((d . nil) . nil)) . nil))	 ; '(b (c (d)))
'(a . ((b . ((c . ((d . nil) . nil)) . nil)) . nil)) ; '(a (b (c (d)))), 7 conses

'(((a b) c) d)
'(a . (b . nil))			; '(a b)
'((a . (b . nil)) . (c . nil))		; '((a b) c)
'(((a . (b . nil)) . (c . nil)) . (d . nil)) ; '(((a b) c) d), 6 conses

'(a (b . c) . d)
'(a . ((b . c) . d))			; 3 conses

;;; 2. Write a version of UION that preserves the order of the elements in the
;;; original lists.
;;; (new-union '(a b c) '(b a d)) => (a b c d)
(union '(a b c) '(b a d))
(defun new-union (&rest lists)
  (let ((acc nil))
    (dolist (lst lists)
      (dolist (elm lst)
	(pushnew elm acc :test #'equal)))
    (reverse acc)))

;;; 3. Define a function that takes a list and returns a list indicating the
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

;;; 4. Why does (member '(a) '((a) (b))) return NIL?
(member '(a) '((a) (b)) :test #'equal)	; => ((A) (B))
(member 'a '((a) (b)) :key #'car) 	; => ((A) (B))

;;; 5. Suppose the function POS+ takes a list and returns a list of each element
;;; plus its position:
;;; (POS+ '(7 5 1 4)) => (7 6 3 7)
;;; Define this function using (a) recursion, (b) iteration, (c) mapcar.
(defun pos+-helper (lst current-pos)
  (if (null lst)
      nil
      (cons (+ (car lst)
	       current-pos)
	    (pos+-helper (cdr lst)
			 (+ current-pos 1)))))
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

(defun pos+-mapcar-2 (lst)
  (let ((i -1))
    (mapcar (lambda (n)
	      (+ n (incf i)))
	    lst)))

;;; 6. Construct a kind of list such that "CDR" points to its first element
;;; and "CAR" points to the rest of it.
;;; Define CONS, LIST, LENGTH (for lists), and MEMBER (for lists; no keywords)
;;; for this kind of list.
(defun g-cons (x y)
  (cons y x))

;;; (g-list 1 3 5 nil)
;;; => ((((NIL) . 5) . 3) . 1)
(defun g-list-1 (&rest args)
  (let* ((z (reverse args))
	 (result (g-cons (car z) nil)))
    (dolist (elm (cdr z) result)
      (setf result (g-cons elm result)))))
(defun g-list-2 (&rest args)
  (if args
      (if (null (car args))
	  (g-cons (car args) nil)
	  (g-cons (car args) (apply #'g-list-2 (cdr args))))))

(defun g-length (glist)
  (if (null glist)
      0
      (1+ (g-length (car glist)))))

(defun g-member (item glist)
  (if (null glist)
      nil
      (if (equal (cdr glist) item)
	  glist
	  (g-member item (car glist)))))
;;; CL-USER> (setf *r* (g-list-2 1 3 5 nil))
;;; => ((((NIL) . 5) . 3) . 1)
;;; CL-USER> (g-member nil *r*)
;;; => (NIL)
;;; CL-USER> (g-member 2 *r*)
;;; NIL

;;; SICP exercise (just for fun)
(defun d-cons (x y)
  (lambda (m) (funcall m x y)))
;;; The following definition works even DCONS is NIL
(defun d-car (dcons)
  (if dcons (funcall dcons (lambda (p q) p))))
(defun d-cdr (dcons)
  (if dcons (funcall dcons (lambda (p q) q))))

;;; 7. Modify the program in Figure 3.6 (compress) to use fewer cons cells.
;;; Hint: use dotted lists.
(defun n-elts (elt n)
  (if (> n 1)
      (cons n elt)
      elt))

;;; 8. Define a function that takes a list and prints it in dot notation
;;; > (showdots '(a b c))
;;; (A . (B . (C . NIL)))
;;; NIL
;;;
;;; ()    => NIL                => consp => false,  null => true
;;; (a)   => (A . NIL)          => consp => true,   null => false
;;; ((a)) => ((A . NIL) . NIL)  => consp => true,   null => false
(defun showdots (lst)
  (if (not (consp lst))
      (format t "~A" lst)
      (if (null lst)
	  (format t "NIL")
	  (progn
	    (format t "(")
	    (if (consp (car lst))
		(progn
		  (showdots (car lst))
		  (format t " . "))
		(format t "~A . " (car lst)))
	    (showdots (cdr lst))
	    (format t ")")))))

(showdots '())
(showdots '(a))
(showdots '(a b))
(showdots '((a)))
(showdots '(a b (c d)))
(showdots '(a (b (c (d)))))
(showdots '(((a b) c) d))
(showdots '(a . b))
(showdots '(a (b . c) . d))
