(in-package :common-lisp-user)

(defpackage :util
  (:use :common-lisp)
  (:export :elementp :with-gensyms))

(defpackage :common-lisp-unit-test
  (:nicknames :cl-unit)
  (:use :common-lisp :util)
  (:export :*test-name* :deftest :check :combine-results))

;; General test
(defpackage :test
  (:use :common-lisp)
  (:shadow :null :not)
  (:export :div134 :five-more-p :<= :null :nonempty-list-p :not))

;; Project 1
(defpackage :match
  (:use :common-lisp)
  (:export :variablep :match-element :dont-care))

;; Project 2
(defpackage :calculator
  (:use :common-lisp)
  (:export :combine-expr))

;; Chapter 14
(defpackage :ch14
  (:use :common-lisp))

(defpackage :ch15
  (:use :common-lisp))

;; Chapter 16
(defpackage :ch16
  (:use :common-lisp)
  (:shadow :length :member)
  (:export :length :member))