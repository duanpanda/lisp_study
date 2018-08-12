;;; True if the specified subsequence of the string is a
;;; palindrome (reads the same forwards and backwards).
(defun palindromep (string
		    &optional
		      (start 0)
		      (end (length string)))
  (dotimes (k (floor (- end start) 2) t)
    (unless (char-equal (char string (+ start k))
			(char string (- end k 1)))
      (return nil))))

(palindromep "Able was I ere I saw Elba")

(palindromep "A man, a plan, a canal--Panama!")

(remove-if-not #'alpha-char-p		;Remove punctuation.
	       "A man, a plan, a canal--Panama!")
(palindromep
 (remove-if-not #'alpha-char-p
		"A man, a plan, a canal--Panama!"))
(palindromep
 (remove-if-not #'alpha-char-p
		"Unremarkable was I ere I saw Elba Kramer, nu?"))

(palindromep
 (remove-if-not
  #'alpha-char-p
  "A man, a plan, a cat, a ham, a yak,
                  a yam, a hat, a canal--Panama!"))
