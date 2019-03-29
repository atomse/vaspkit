(in-package :vaspkit)

(defmethod %kpoints ((vasprun node))
  (find-child-by-name "kpoints" vasprun))

(defun parse-generation (generation)
  (let* ((param (second (find "param" (node-attrs generation) :key #'car :test #'equal)))
	 (nodes (node-children generation))
	 (table (make-hash-table :test #'equal)))
    (setf (gethash "param" table) param)
    (loop for node in nodes
       for typename = (node-name node)
       do (eswitch (typename :test #'equal)
	    ("i"
	     (destructuring-bind (key value) (parse-item-leaf node)
	       (setf (gethash key table) value)))
	    ("v"
	     (destructuring-bind (key value) (parse-vector-leaf node)
	       (setf (gethash key table) value)))))
    table))

(defmethod kpoints ((vasprun node))
  (let* ((kpoints (%kpoints vasprun))
	 (generation (find-child-by-name "generation" kpoints))
	 (kpointlist (find-child-by-attrs '("name" "kpointlist") kpoints))
	 (weights (find-child-by-attrs '("name" "weights") kpoints))
	 (table (make-hash-table :test #'equal)))
    (setf (gethash "generation" table) (parse-generation generation))
    (destructuring-bind (key value) (parse-varray-node kpointlist)
      (setf (gethash key table) value))
    (destructuring-bind (key value) (parse-varray-node weights)
      (setf (gethash key table) value))
    table))
