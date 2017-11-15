;;------------------------------------------------------------------------------
;; This file provides the function MAIN which can move each student's files in
;; the first dir to the student's corresponding folder in the second dir.
;;
;; The student's folder's name must be a substring of the names of the
;; student's files.
;;
;; For example, Folder name "2011093205 Ryan Duan" is a substring of
;; "2011093205 Ryan Duan.zip".
;;
;; Files that satisfies this rule will be moved to the corresponding folder.
;;
;; $date: January 1st, 2014
;;------------------------------------------------------------------------------

(in-package :rd-mv)

;; Example:
;;
;; (rd-mv:main "~/vmshare/stupapers/2new/" "~/vmshare/stupapers/class_2")
(defun main (from-dir-name to-dir-name)
  (let ((containers (collect-all-containers to-dir-name))
	(files (collect-all-files from-dir-name)))
    (mv-files files containers)))

(defun dir-p (pathname)
  (not (eql nil (pathname-name pathname))))

(defun not-dir-p (pathname)
  (eql nil (pathname-name pathname)))

(defun collect-all-containers (dirname)
  (remove-if #'dir-p
	     (com.gigamonkeys.pathnames:list-directory dirname)))

(defun collect-all-files (dirname)
  (remove-if #'not-dir-p
	     (com.gigamonkeys.pathnames:list-directory dirname)))

(defun contains-substring-p (substr string)
  ;; If STRING does not contain SUBSTR, it returns NIL.
  (search substr string))

(defun find-matched-files (str-to-be-matched files-pathnames)
  (labels ((find-recursive (str pathname-list found-files)
	     (if (null pathname-list)
		 found-files
		 (let ((pn (first pathname-list)))
		   (if (contains-substring-p str (pathname-name pn))
		       (find-recursive str
				       (rest pathname-list)
				       (cons pn found-files))
		       (find-recursive str
				       (rest pathname-list)
				       found-files))))))
    (find-recursive str-to-be-matched files-pathnames nil)))

(defun mv-file (from to)
  (rename-file from (translate-pathname from from to)))

(defun pathname-dir-thislevel (pathname)
  (let ((d (pathname-directory pathname)))
    (car (last d))))

(defun mv-files (files containers)
  (dolist (container-pathname containers)
    (let* ((c (pathname-dir-thislevel container-pathname))
	   (mflist (find-matched-files c files)))
      (when mflist
	(dolist (f mflist)
	  (mv-file f container-pathname))))))

;(defun translate-logical-pathname-1 (pathname rules)
;  (let ((rule (assoc pathname rules :test #'pathname-match-p)))
;    (unless rule (error "No translation rule for ~A" pathname))
;    (translate-pathname pathname (first rule) (second rule))))
