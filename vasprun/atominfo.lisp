(in-package :vaspkit)

(defmethod %atominfo ((vasprun node))
  (find-child-by-name "atominfo" vasprun))

(defun atominfo-rc (rc)
  (let ((nodes (node-children rc)))
    (loop for node in nodes
       for str = (car (node-children node))
       if (string-numberp str)
       collect (parse-number str)
       else
       collect str)))

(defun atominfo-set (set)
  (mapcar #'atominfo-rc (node-children set)))

(defun atominfo-array (array)
  (let* ((name (attrs-name array))
	 (fields (loop for node in (node-children array)
		    if (equal "field" (node-name node))
		    collect node))
	 (field-names (mapcar (compose #'car #'node-children) fields))
	 (set (find-child-by-name "set" array))
	 (table (make-hash-table :test #'equal)))
    (setf (gethash "fields" table) field-names)
    (setf (gethash "set" table) (atominfo-set set))
    (list name table)))
    
(defmethod atominfo ((vasprun node))
  (let* ((atominfo (%atominfo vasprun))
	 (table (make-hash-table :test #'equal)))
    (loop for node in (node-children atominfo)
       if (equal "array" (node-name node))
       do (destructuring-bind (key value) (atominfo-array node)
     	    (setf (gethash key table) value)))
    table))
    
    
