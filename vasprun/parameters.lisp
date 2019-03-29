(in-package :vaspkit)

(defmethod %parameters ((vasprun node))
  (find-child-by-name "parameters" vasprun))

(defun parse-separator (separator)
  (let ((name (attrs-name separator))
	(nodes (node-children separator))
	(table (make-hash-table :test #'equal)))
    (loop for node in nodes
       do (let ((typename (node-name node)))
	    (eswitch (typename :test #'equal)
	      ("i"
	       (destructuring-bind (key value) (parse-item-leaf node)
		 (setf (gethash key table) value)))
	      ("v"
	       (destructuring-bind (key value) (parse-vector-leaf node)
		 (setf (gethash key table) value))))))
    (list name table)))

(defmethod parameters ((vasprun node))
  (let* ((parameters (%parameters vasprun))
	 (separators (node-children parameters))
	 (table (make-hash-table :test #'equal)))
    (loop for separator in separators
       for (key value) = (parse-separator separator)
       do (setf (gethash key table) value))
    table))
	 
	      
	      
