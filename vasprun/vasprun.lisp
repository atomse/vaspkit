(in-package :vaspkit)

(defclass vasprun ()
  ((generator :initarg :generator
	      :accessor generator)
   (incar :initarg :incar
	  :accessor incar)))
 


(defun load-vasprun (&optional (vasprun "vasprun.xml"))
  (parse (read-file-string vasprun)))

    
;; (defmethod %incar ((vasprun xml))
;;   (let ((incar (find-node-by-name "incar"
;; 				  (node-children (content vasprun))))
;; 	(list nil))
;;     (dolist (leaf (node-children incar))
;;       (appendf list (parse-leaf leaf)))
;;     list))

;; (defmethod %poscar ((vasprun xml))
;;   (let* ((poscar (find-node-by-attrs '("name" "primitive_cell")
;; 				     (node-children (content vasprun))))
;; 	 (crystal (find-node-by-name "crystal" (node-children poscar)))
;; 	 (basis (find-node-by-attrs '("name" "basis") (node-children crystal)))
;; 	 (volume (find-node-by-attrs '("name" "volume") (node-children crystal)))
;; 	 (rec-basis (find-node-by-attrs '("name" "rec_basis") (node-children crystal)))
;; 	 (positions (find-node-by-attrs '("name" "positions") (node-children poscar)))
;; 	 (list nil))
;;     (appendf list (parse-varray basis))
;;     (appendf list (parse-leaf volume))
;;     (appendf list (parse-varray rec-basis))
;;     (appendf list (parse-varray positions))
;;     list))

;; (defmethod %kpoints ((vasprun xml))
;;   (let* ((kpoints (find-node-by-name "kpoints"
;; 				     (node-children (content vasprun))))
;; 	 (generation (find-node-by-name "generation" (node-children kpoints)))
;; 	 (kpointlist (find-node-by-attrs '("name" "kpointlist") (node-children kpoints)))
;; 	 (weights (find-node-by-attrs '("name" "weights") (node-children kpoints)))
;; 	 (list nil))
;;     (appendf list
;; 	     (list :generation
;; 		   (loop for x in (mapcar #'parse-leaf (node-children generation))
;; 		      collect x)))
;;     (appendf list (parse-varray kpointlist))
;;     (appendf list (parse-varray weights))
;;     list))
    
;; (defmethod %parameters ((vasprun xml))
;;   (let ((parameters (find-node-by-name "parameters"
;; 				       (node-children (content vasprun))))
;; 	(list nil))
;;     (labels ((recur (node)
;; 	       (if (leaf-node-p node)
;; 		   (appendf list (parse-leaf node))
;; 		   (dolist (x (node-children node))
;; 		     (recur x)))))
;;       (recur parameters))
;;     list))

;; (defmethod %atominfo/atoms ((vasprun xml))
;;   (let* ((atominfo (find-node-by-name "atominfo"
;; 				      (node-children (content vasprun))))
;; 	 (atoms (find-node-by-attrs '("name" "atoms") (node-children atominfo)))
;; 	 (atoms-set (find-node-by-name "set" (node-children atoms))))
;;     (labels ((parse-rc (rc)
;; 	       (let* ((children (node-children rc))
;; 		      (atom (car (node-children (first children))))
;; 		      (type (parse-integer (car (node-children (second children))))))
;; 		 (cons atom type))))
;;       (mapcar #'parse-rc (node-children atoms-set)))))

;; (defmethod %atominfo/types ((vasprun xml))
;;   (let* ((atominfo (find-node-by-name "atominfo"
;; 				      (node-children (content vasprun))))
;; 	 (atomtypes (find-node-by-attrs '("name" "atomtypes") (node-children atominfo)))
;; 	 (field  (remove-if-not (compose (curry #'equalp "field") #'node-name)
;; 				(node-children atomtypes)))
;; 	 (types (mapcar (compose #'second #'car #'node-attrs) field))
;; 	 (names (mapcar (compose #'car #'node-children) field))
;; 	 (sets (mapcar #'node-children (node-children (find-node-by-name "set" (node-children atomtypes)))))
;; 	 (rcs (mapcar (curry #'mapcar (compose #'car #'node-children)) sets)))
;;     (loop for rc in rcs
;;        collect
;; 	 (let ((list nil))
;; 	   (loop for type in types
;; 	      for name in names
;; 	      for data in rc
;; 	      do (appendf list (parse-leaf
;; 				(make-node :name "i"
;; 					   :attrs (list (list "type" type) (list "name" name))
;; 					   :children (list data)))))
;; 	   list))))
	 
;; (defmethod %atominfo ((vasprun xml))
;;   (list (%atominfo/atoms vasprun)
;; 	(%atominfo/types vasprun)))

;; (defmethod %eigenvalues ((vasprun xml))
;;   (let* ((calculation (find-node-by-name "calculation"
;; 					 (node-children (content vasprun))))
;; 	 (eigenvalues (find-node-by-name "eigenvalues"
;; 					 (node-children calculation)))
;; 	 (array (find-node-by-name "array" (node-children eigenvalues)))
;; 	 (sets (node-children (find-node-by-name "set" (node-children array))))
;; 	 (list nil))
;;     (labels ((parse-set (set)
;; 	       (let ((comment (second (find "comment" (node-attrs set) :key #'first :test #'equalp)))
;; 		     (kpointlist (node-children set)))
;; 		 (list comment
;; 		       (loop for kpoint in kpointlist
;; 			  collect (mapcar #'parse-leaf (node-children kpoint)))))))
;;       (dolist (set sets)
;; 	(appendf list (parse-set set))))
;;     list))

;; (defmethod %magdipolout (vasprun)
;;   (let* ((calculation (find-node-by-name "calculation"
;; 					 (node-children (content vasprun))))
;; 	 (magnetization (find-node-by-attrs '("name" "orbital magnetization") (node-children calculation))))
;;     (parse-leaf (car (node-children magnetization)))))

;; (defmethod %efermi ((vasprun xml))
;;   (let* ((calculation (find-node-by-name "calculation"
;; 					 (node-children (content vasprun))))
;; 	 (dos (find-node-by-name "dos" (node-children calculation)))
;; 	 (efermi (find-node-by-attrs '("name" "efermi") (node-children dos))))
;;     (parse-leaf efermi)))

;; (defmethod %dos ((vasprun xml))
;;   (let* ((calculation (find-node-by-name "calculation"
;; 					 (node-children (content vasprun))))
;; 	 (dos (find-node-by-name "dos" (node-children calculation)))
;; 	 (total (find-node-by-name "total" (node-children dos)))
;; 	 (array (find-node-by-name "array" (node-children total)))
;; 	 (sets (node-children (find-node-by-name "set" (node-children array))))
;; 	 (list nil))
;;         (labels ((parse-set (set)
;; 		   (let ((comment (second (find "comment" (node-attrs set) :key #'first :test #'equalp)))
;; 			 (doslist (node-children set)))
;; 		     (list comment
;; 			   (loop for s in doslist
;; 			      collect (parse-leaf s))))))
;;       (dolist (set sets)
;; 	(appendf list (parse-set set))))
;;     list))

;; (defmethod %pdos ((vasprun xml))
;;   (let* ((calculation (find-node-by-name "calculation"
;; 					 (node-children (content vasprun))))
;; 	 (dos (find-node-by-name "dos" (node-children calculation)))
;; 	 (partial (find-node-by-name "partial" (node-children dos))))
;;     (if partial
;; 	(let* ((array (find-node-by-name "array" (node-children partial)))
;; 	       (fields (mapcar (compose #'car #'node-children)
;; 					(remove-if-not (curry #'equalp "field") (node-children array)
;; 						       :key #'node-name)))
;; 	       (ions (node-children (find-node-by-name "set" (node-children array))))
;; 	       (list (list :field fields)))
;; 	  (labels ((parse-spin (spin)
;; 		     (let ((comment (second (find "comment" (node-attrs spin) :key #'first :test #'equalp)))
;; 			   (doslist (node-children spin)))
;; 		       (list comment
;; 			     (loop for s in doslist
;; 				collect (parse-leaf s)))))
;; 		   (parse-ion (ion)
;; 		     (let ((comment (second (find "comment" (node-attrs ion) :key #'first :test #'equalp)))
;; 			   (spinlist (node-children ion))
;; 			   (pdoslist nil))
;; 		       (dolist (spin spinlist)
;; 			 (appendf pdoslist (parse-spin spin)))
;; 		       (list comment pdoslist))))
;; 	    (dolist (ion ions)
;; 	      (appendf list (parse-ion ion))))
;; 	  list)
;; 	nil)))

;; (defmethod %energy ((vasprun xml))
;;   (let* ((calculation (find-node-by-name "calculation"
;; 					 (node-children (content vasprun))))
;; 	 (energy (find-node-by-name "energy" (node-children calculation)))
;; 	 (list nil))
;;     (dolist (e (node-children energy))
;;       (appendf list (parse-leaf e)))
;;     list))

;; (defmethod %scstep ((vasprun xml))
;;   (let* ((calculation (find-node-by-name "calculation"
;; 					 (node-children (content vasprun))))
;; 	 (scstep (remove-if-not (curry #'equal "scstep")
;; 				(node-children calculation)
;; 				:key #'node-name)))
;;      scstep))
