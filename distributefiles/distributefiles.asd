(asdf:defsystem "rd-mv"
    :description "rd-mv: move each student's files to his corresponding folder."
    :version "1.0.0"
    :author "Ryan Duan <duanpanda@gmail.com>"
    :licence "General Public Licence"
    :components ((:file "packages")
		 (:file "pclpathnames" :depends-on ("packages"))
		 (:file "mv-files" :defpends-on ("pclpathnames"))))