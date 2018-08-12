;;; The complete syntax of a lamba-expression is:
;;; (lambda ({var}*
;;;          [&optional {var | (var [initform [svar]])}*]
;;;          [&rest var]
;;;          [&key {var | (keyword var)} [initform [svar]])}*]
;;;          [&aux {var | (var [initform])}*])
;;;   <[ {declaration}* | documentation-string ]>
;;;   {form}*)


;;; Examples of &OPTIONAL and &REST parameters
((lambda (a b)
   (+ a (* b 3)))
 4 5)
;;; => 19

((lambda (a &optional (b 2))
   (+ a (* b 3)))
 4 5)
;;; => 19

((lambda (a &optional (b 2))
   (+ a (* b 3)))
 4)
;;; => 10

((lambda (&optional (a 2 b) (c 3 d) &rest x)
   (list a b c d x))
 )
;;; => (2 nil 3 nil nil)

((lambda (&optional (a 2 b) (c 3 d) &rest x)
   (list a b c d x))
 6)
;;; => (6 t 3 nil nil)

((lambda (&optional (a 2 b) (c 3 d) &rest x)
   (list a b c d x))
 6 3)
;;; => (6 t 3 t nil)

((lambda (&optional (a 2 b) (c 3 d) &rest x)
   (list a b c d x))
 6 3 8)
;;; => (6 t 3 t (8))

((lambda (&optional (a 2 b) (c 3 d) &rest x)
   (list a b c d x))
 6 3 8 9 10 11)
;;; => (6 t 3 t (8 9 10 11))

;;; Examples of &KEY parameters
((lambda (a b &key c d)
   (list a b c d))
 1 2)
;;; => (1 2 nil nil)

((lambda (a b &key c d)
   (list a b c d))
 1 2 :c 6)
;;; => (1 2 6 nil)

((lambda (a b &key c d)
   (list a b c d))
 1 2 :d 8)
;;; => (1 2 nil 8)

((lambda (a b &key c d)
   (list a b c d))
 1 2 :c 6 :d 8)
;;; => (1 2 6 8)

((lambda (a b &key c d)
   (list a b c d))
 1 2 :d 8 :c 6)
;;; => (1 2 6 8)

((lambda (a b &key c d)
   (list a b c d))
 :a 1 :d 8 :c 6)
;;; => (:a 1 6 8)

((lambda (a b &key c d)
   (list a b c d))
 :a :b :c :d)
;;; => (:a :b :d nil)

; caught WARNING:
;   function called with unknown argument keyword C
(handler-bind ((error #'abort))
  ((lambda (a b &key c d)
     (list a b c d))
   :a :b 'c 'd))
;;; Unknown &KEY argument: C
;;; [Condition of type UNKNOWN-KEYWORD-ARGUMENT]

((lambda (a b &key ((c cval) nil) d)
   (list a b cval d))
 :a :b 'c 'd)
;;; => (:A :B D NIL)

;;; odd number of &KEY arguments
;;;   [Condition of type SB-INT:SIMPLE-PROGRAM-ERROR]
(handler-bind ((error #'abort))
  ((lambda (a b &key ((c cval) 5) d)
     (list a b cval d))
   :a :b 'c))

((lambda (a b &key ((c cval) 5) d)
   (list a b cval d))
 :a :b)
;;; => (a b 5 nil)

;;; Only a parameter specifier of the form
;;;     ((KEYWORD VAR) ...)
;;; can cause the keyword-name not to be a keyword symbol, by specifying a symbol not
;;; in the KEYWORD package as the KEYWORD.
(defun wager (&key ((secret password) nil) amount)
  (format nil "You ~A $~D"
	  (if (eq password 'joe-sent-me) "win" "lose")
	  amount))

(wager :amount 100)
;;; => "You lose $100"

(wager :amount 100 'secret 'joe-sent-me)
;;; => "You win $100"

;;; Examples of mixtures

; caught STYLE-WARNING:
;   &OPTIONAL and &KEY found in the same lambda list: (A &OPTIONAL (B 3) &REST X
;                                                      &KEY C (D A))
((lambda (a &optional (b 3) &rest x &key c (d a))
   (list a b c d x))
 1)
;;; => (1 3 nil 1 nil)
 
((lambda (a &optional (b 3) &rest x &key c (d a))
   (list a b c d x))
 1 2)
;;; => (1 2 nil 1 nil)

((lambda (a &optional (b 3) &rest x &key c (d a))
   (list a b c d x))
 :c 7)
;;; => (:c 7 nil :c nil)

((lambda (a &optional (b 3) &rest x &key c (d a))
   (list a b c d x))
 1 6 :c 7)
;;; => (1 6 7 1 (:c 7))

((lambda (a &optional (b 3) &rest x &key c (d a))
   (list a b c d x))
 1 6 :d 8)
;;; => (1 6 nil 8 (:d 8))

((lambda (a &optional (b 3) &rest x &key c (d a))
   (list a b c d x))
 1 6 :d 8 :c 9 :d 10)
;;; => (1 6 9 8 (:d 8 :c 9 :d 10))

lambda-list-keywords
;;; in SBCL
;;; => (&ALLOW-OTHER-KEYS &AUX &BODY &ENVIRONMENT &KEY SB-INT:&MORE &OPTIONAL &REST
;;;     &WHOLE)

(defun array-of-strings (str dims
			 &rest keyword-pairs
			 &key (start 0) end
			   &allow-other-keys)
  (apply #'make-array dims
	 :initial-element (subseq str start end)
	 :allow-other-keys t
	 keyword-pairs))

(array-of-strings "good morning" '(3 2 4) :start 0 :end 4 :home "ryan")
;;; => #3A((("good" "good" "good" "good") ("good" "good" "good" "good"))
;;;        (("good" "good" "good" "good") ("good" "good" "good" "good"))
;;;        (("good" "good" "good" "good") ("good" "good" "good" "good")))

lambda-parameters-limit
;;; in SBCL
;;; 4611686018427387903

call-arguments-limit
;;; in SBCL
;;; 4611686018427387903
