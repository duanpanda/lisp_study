(defparameter *all*
  (with-open-file (in "in-all")
    (read in)))

(defparameter *sms-group*
  (with-open-file (in "in-smsgroup")
    (read in)))

(defparameter *fetion-group*
  (with-open-file (in "in-fetiongroup")
    (read in)))

(defparameter *phone-numbers*
  (with-open-file (in "in-phone-numbers")
    (read in)))

(with-open-file (out "out-sms-send-list"
		     :direction :output
		     :if-exists :supersede)
  (prin1 (set-difference *sms-group* *fetion-group*) out))

(defun filter (indicator-list alist)
  (if (null indicator-list)
      nil
      (cons (assoc (car indicator-list) alist)
	    (filter (cdr indicator-list) alist))))

(defparameter *special-name-list*
  (set-difference (set-difference *all* *sms-group*)
		  *fetion-group*))

(let ((result (filter *special-name-list*
	       (pairlis *all* *phone-numbers*))))
  (with-open-file (out "out-special-name-list"
		       :direction :output
		       :if-exists :supersede)
    (prin1 result out)))