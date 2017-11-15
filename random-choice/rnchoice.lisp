;;==============================================================================
;;
;; This file provides facilities for choosing several persons randomly from a
;; group.
;;
;; INPUT: a text file contains all the persons in the group, one line for one
;; person.
;;
;; OUTPUT: a text file contains the selected persons, one line for one person.
;;
;; date: Dec 12, 2013
;;==============================================================================

(defun gen-random-seq (candidates-cnt limit)
  "Generate a sorted list whose length is CANDIDATES-CNT.
The list contains randomly chose numbers less than LIMIT."
  (let ((choice nil))
    (loop until (>= (length choice) candidates-cnt)
       do (pushnew (random limit) choice))
    (sort choice #'<)))

;; Write (read into) BUF-ARRAY
;; return line count
(defun read-group-info (buf-array f-in-name)
  (with-open-file (in f-in-name)
    (loop for line = (read-line in nil)
       while line do
	 (vector-push-extend line buf-array))
    (fill-pointer buf-array)))

(defun write-result-to-file (fname seq buf-array)
  (with-open-file (out-stream
		   fname
		   :direction :output
		   :if-exists :supersede)
    (dolist (i seq)		  ; i is item of seq, and is index of buf-array
      (format out-stream "~a~%" (aref buf-array i)))))

;; main function
;;
;; four steps:
;;   1. make a buffer
;;   2. read group info into buffer
;;   3. generate random sequence
;;   4. write selection to file
(defun make-a-random-choice (candidates-cnt
			     f-in-name
			     f-out-name)

  (let* ((buf-array (make-array 50 :fill-pointer 0 :adjustable t)) ; buffer

	 ;; read to buffer and return total lines
	 (total-num (read-group-info buf-array f-in-name)))

    ;; CANDIDATES-CNT must be greater than 0 and not greater than TOTAL-NUM
    (assert (> candidates-cnt 0) (candidates-cnt))
    (assert (<= candidates-cnt total-num)
	    (candidates-cnt)
	    "CANDIDATES-CNT ~a cannot be greater than total number ~a."
	    candidates-cnt
	    total-num)

    (write-result-to-file f-out-name
			  (gen-random-seq candidates-cnt total-num)
			  buf-array)))
