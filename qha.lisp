(in-package :vaspkit)

(defun write-ve (pathnames)
  (let* ((xmls (mapcar #'load-vasprun pathnames))
	 (volumes (mapcar #'volume xmls))
	 (totens (mapcar #'toten xmls)))
    (os:write-data (mapcar #'list volumes totens) "v-e.dat")))
    
