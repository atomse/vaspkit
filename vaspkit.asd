(defsystem "vaspkit"
  :description "vaspkit: my post processing toolkit for vasp"
  :version "0.1"
  :author "Chen Ruofan <physcrf@qq.com>"
  :licence "GPL"
  :depends-on (:xmls ;; https://www.common-lisp.net/project/xmls/
	       :utility ;; https://github.com/physcrf/utility
	       :string ;; https://github.com/physcrf/string#
	       :cl-ppcre) ;; https://edicl.github.io/cl-ppcre/
  :components ((:file "package")
	       (:module "vasprun"
			:depends-on ("package")
			:serial t
			:components ((:file "utility")
				     (:file "vasprun")
				     (:file "generator")
				     (:file "incar")
				     (:file "cell")))
;;	       (:file "utility" :depends-on ("package"))
;;	       (:file "vasprun" :depends-on ("utility"))
;;	       (:file "vaspinfo" :depends-on ("vasprun"))
;;	       (:file "band" :depends-on ("vaspinfo"))
;;	       (:file "dos" :depends-on ("vaspinfo"))
;;	       (:file "pdos" :depends-on ("vaspinfo"))
;;	       (:file "qha" :depends-on ("vaspinfo"))
	       ))
