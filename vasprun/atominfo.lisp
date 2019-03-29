(in-package :vaspkit)

(defmethod %atominfo ((vasprun node))
  (find-child-by-name "atominfo" vasprun))

(defun parse-set-rc (rc))
  

(defmethod atominfo ((vasprun node))
  (let* ((atominfo (%atominfo vasprun))
	 (atoms (find-child-by-name "atoms" atominfo))
	 (types (find-child-by-name "types" atominfo))
	 (table (make-hash-table :test #'equal)))))
    
    
