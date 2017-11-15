(defun whitespace-p (char)
  (or (equal char #\Space) (equal char #\Tab)))

(defun trim-internal (str)
  (remove-if #'whitespace-p str))

(defun get-entry (in-stream)
  (trim-internal (read-line in-stream nil)))

(defun main (f-in-name)
  (with-open-file (in f-in-name)
    (loop for entry = (get-entry in)
       while entry do
;	 #+sbcl (sb-ext:run-program "/bin/mkdir" (list entry))
;	 #-sbcl (error "Must be run in SBCL."))))
	 (ensure-directories-exist (make-pathname :directory
						  `(:relative ,entry))
				   :verbose t))))