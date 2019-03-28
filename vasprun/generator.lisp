(in-package :vaspkit)

(defmethod %generator ((vasprun node))
  (find-child-by-name "generator" vasprun))

(defmethod generator ((vasprun node))
  (let ((nodes (node-children (%generator vasprun)))
	(table (make-hash-table :test #'equal)))
    (dolist (node nodes)
      (destructuring-bind (key value) (parse-item-leaf node)
	(setf (gethash key table) value)))
    table))

	  
