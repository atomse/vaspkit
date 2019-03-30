(in-package :vaspkit)

(defun children-names (node)
  (mapcar #'node-name (node-children node)))

(defun children-attrs (node)
  (mapcar #'node-attrs (node-children node)))

(defun find-child-by-name (name node)
  (find name (node-children node) :key #'node-name :test #'equal))

(defun find-child-by-attrs (attrs node)
  (find attrs (node-children node) :key #'node-attrs :test (rcurry #'member :test #'equal)))

(defun leaf-node-p (node)
  (member-if-not #'node-p (node-children node)))

(defun parse-item-leaf (leaf)
  (let* ((attrs (node-attrs leaf))
	 (type (second (find "type" attrs :key #'car :test #'equal)))
	 (type (if type type "float"))
	 (name (second (find "name" attrs :key #'car :test #'equal)))
	 (item (car (node-children leaf))))
    (list name
	  (eswitch (type :test #'equal)
	    ("string" (trim item))
	    ("int" (parse-integer item))
	    ("logical" (if (equalp (trim item) "T") t nil)) 
	    ("float" (parse-number item))))))
      
(defun parse-vector-leaf (leaf)
  (let* ((attrs (node-attrs leaf))
	 (type (second (find "type" attrs :key #'car :test #'equal)))
	 (type (if type type "float"))
	 (name (second (find "name" attrs :key #'car :test #'equal)))
	 (vector (split "\\s+" (car (node-children leaf)))))
    (list name
	    (eswitch (type :test #'equal)
	      ("int" (mapcar #'parse-integer vector))
	      ("float" (mapcar #'parse-float vector))))))
	    
(defun parse-varray-node (node)
  (let* ((attrs (node-attrs node))
	 (name (second (find "name" attrs :key #'car :test #'equal)))
	 (varray (node-children node)))
    (list name
	    (mapcar (lambda (leaf)
		      (second (parse-vector-leaf leaf)))
		    varray))))

(defun attrs-type (node)
  (second (find "type" (node-attrs node) :test #'equal :key #'car)))

(defun attrs-name (node)
  (second (find "name" (node-attrs node) :test #'equal :key #'car)))

