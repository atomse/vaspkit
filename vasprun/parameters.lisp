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
		 (setf (gethash key table) value)))
	      ("separator"
	       (destructuring-bind (name table) (parse-separator node)
		 (setf (gethash name table) table))))))
    (list name table)))

(defmethod parameters ((vasprun node))
  (let* ((parameters (%parameters vasprun))
	 (nodes (node-children parameters))
	 (table (make-hash-table :test #'equal)))
    (loop for node in nodes
       for typename = (node-name node)
       do (eswitch (typename :test #'equal)
	    ("i"
	     (destructuring-bind (key value) (parse-item-leaf node)
	       (setf (gethash key table) value)))
	    ("v" 
	     (destructuring-bind (key value) (parse-vector-leaf node)
	       (setf (gethash key table) value)))
	    ("separator"
	     (destructuring-bind (key value) (parse-separator node)
	       (setf (gethash key table) value)))))
    table))
	     
    
	      
	      
