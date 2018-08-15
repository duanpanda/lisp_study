(defun ask-number ()
  (format t "Please enter a number. ")
  (let ((val (read)))
    (if (numberp val)
        val
        (ask-number))))

;;; Find how many elements are there in y such that they are not equal to x
(defun mystery (x y)
  (if (null y)
      nil                               ; if y is exausted, x is not found, nil
      (if (eql (car y) x)
          0                              ; return 0 as long as the elem equals x
          (let ((z (mystery x (cdr y)))) ; other wise add 1 and move to the rest
            (and z (+ z 1))))))

;;; always return NIL
(defun enigma (x)
  (and (not (null x))
       (or (null (car x))
           (enigma (cdr x)))))

(apply #'list 1 nil)
;; => (1)

(funcall #'list 1 nil)
;; => (1 NIL)

;;; pre: LST must be a list
(defun contains-list-p (lst)
  (assert (listp lst) (lst) "LST must be a list, but ~A is not." lst)
  (if (null lst)
      nil
      (if (listp (car lst))
          t
          (contains-list-p (cdr lst)))))

;; (and x y z ... w) == (cond ((not x) nil)
;;                            ((not y) nil)
;;                            ((not z) nil)
;;                            ...
;;                            (t w))

;; (or x y z ... w) == (cond (x) (y) (z) ... (t w))

(defun contains-list-p-2 (lst)
  (assert (listp lst) (lst) "LST must be a list, but ~A is not." lst)
  (cond ((null lst)
         nil)
        (t
         (cond ((listp (car lst))
                t)
               (t
                (contains-list-p-2 (cdr lst)))))))

(defun contains-list-p-3 (lst)
  (assert (listp lst) (lst) "LST must be a list, but ~A is not." lst)
  (and (not (null lst))
       (or (listp (car lst))
           (contains-list-p-3 (cdr lst)))))

(defun contains-list-p-4 (lst)
  (assert (listp lst) (lst) "LST must be a list, but ~A is not." lst)
  (some #'listp lst))

(defun contains-list-p-5 (lst)
  (assert (listp lst) (lst) "LST must be a list, but ~A is not." lst)
  (dolist (item lst)
    (if (listp item)
	(return t))))

(defun run-test (&key test-fn)
  (dolist (form '(
                  (() . nil)
                  ((1) . nil)
                  ((1 2) . nil)
                  (((1) 2) . t)
                  ((1 (2)) . t)
                  ((1 ()) . t)
                  ((() 1) . t)
                  ((()) . t)
                  )
           )
    (let ((result (funcall test-fn (car form))))
      (if (eql result
               (cdr form))
          (format t "~10A: ~5A -- correct~%"
                  (car form)
                  (if result "true" "false"))
          (format t "~10A: ~5A -- WRONG~%"
                  (car form)
                  (if result "true" "false"))))))

;;; Because X can be nil, and then (null x) is true, so (summit nil) will cause
;;; an infinite loop.
;; (defun summit (1st)
;;   (let ((x (car 1st)))
;;     (if (null x)
;; 	(summit (cdr 1st))
;; 	(+ x (summit (cdr 1st))))))

(defun summit-1 (lst)
  (apply #'+ (remove nil lst)))

(defun summit-2 (lst)
  (if (null lst)
      0
      (let ((x (car lst)))
	(if (null x)
	    (summit-2 (cdr lst))
	    (+ x (summit-2 (cdr lst)))))))
