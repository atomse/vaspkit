(in-package :vaspkit)

(defmethod %incar ((vasprun node))
  (find-child-by-name "incar" vasprun))

(defmethod incar ((vasprun node))
  (let ((nodes (node-children (%incar vasprun)))
	(table (make-hash-table :test #'equal)))
    (dolist (node nodes)
      (let ((typename (node-name node)))
	(eswitch (typename :test #'equal)
	  ("i" 
	   (destructuring-bind (key value) (parse-item-leaf node)
	     (setf (gethash key table) value)))
	  ("v"
	   (destructuring-bind (key value) (parse-vector-leaf node)
	     (setf (gethash key table) value))))))
    table))

