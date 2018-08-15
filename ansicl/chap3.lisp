(defun our-listp (x)
  (or (null x) (consp x)))

(defun our-atom (x)
  (not (consp x)))

(defun our-equal (x y)
  (or (eql x y)
      (and (consp x)
	   (consp y)
	   (our-equal (car x) (car y))
	   (our-equal (cdr x) (cdr y)))))

(defun our-copy-list (lst)
  (if (atom lst)
      lst
      (cons (car lst) (our-copy-list (cdr lst)))))

(defun our-nthcdr (n lst)
  (if (zerop n)
      lst
      (our-nthcdr (- n 1) (cdr lst))))

(defun our-copy-tree (tr)
  (if (atom tr)
      tr
      (cons (our-copy-tree (car tr))
	    (our-copy-tree (cdr tr)))))

(defun our-subst (new old tree)
  (if (eql tree old)
      new
      (if (atom tree)
	  tree
	  (cons (our-subst new old (car tree))
		(our-subst new old (cdr tre))))))

(defun our-member-if (fn lst)
  (and (consp lst)
       (if (funcall fn (car lst))
	   lst
	   (our-member-if fn (cdr lst)))))

(defun mirror? (s)
  (let ((len (length s)))
    (and (evenp len)
	 (let ((mid (/ len 2)))
	   (equal (subseq s 0 mid)
		  (reverse (subseq s mid)))))))

(defun nthmost (n lst)
  (nth (- n 1)
       (sort (copy-list lst) #'>)))


(defun our-reverse (lst)
  (let ((acc nil))
    (dolist (elt lst)
      (push elt acc))
    acc))

(defun proper-list? (x)
  (or (null x)
      (and (consp x)
	   (proper-list? (cdr x)))))

(defun our-assoc (key alist)
  (and (consp alist)
       (let ((pair (car alist)))
	 (if (eql key (car pair))
	     pair
	     (our-assoc key (cdr alist))))))
