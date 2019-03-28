(in-package :vaspkit)

(defmethod generator ((vasprun xml))
  (%generator vasprun))

(defmethod incar ((vasprun xml))
  (%incar vasprun))

(defmethod poscar ((vasprun xml))
  (%poscar vasprun))

(defmethod basis ((vasprun xml))
  (ref (poscar vasprun) :basis))

(defmethod volume ((vasprun xml))
  (ref (poscar vasprun) :volume))

(defmethod rec_basis ((vasprun xml))
  (ref (poscar vasprun) :rec_basis))

(defmethod kpoints ((vasprun xml))
  (ref (%kpoints vasprun) :kpointlist))

(defmethod kpoints-weights ((vasprun xml))
  (mapcar #'car (ref (%kpoints vasprun) :weights)))

(defmethod kpoints-divisions ((vasprun xml))
  (ref 
   (find :divisions (ref (%kpoints vasprun) :generation)
	 :key #'car)
   :divisions))

(defmethod parameters ((vasprun xml))
  (%parameters vasprun))

(defmethod atoms ((vasprun xml))
  (%atominfo/atoms vasprun))

(defmethod atoms-types ((vasprun xml))
  (%atominfo/types vasprun))

(defmethod eigenvalues ((vasprun xml))
  (ref (%eigenvalues vasprun) "spin 1"))

(defmethod dos ((vasprun xml))
  (ref (%dos vasprun) "spin 1"))

(defmethod magnetization ((vasprun xml))
  (ref (%magdipolout vasprun) :magdipolout))

(defmethod efermi ((vasprun xml))
  (ref (%efermi vasprun) :efermi))

(defmethod pdos ((vasprun xml))
  (let ((pdos (cddr (%pdos vasprun))))
    (loop
       for a in pdos by #'cddr
       for b in (cdr pdos) by #'cddr
       collect (second b))))

(defmethod toten ((vasprun xml))
  (ref (%energy vasprun) :e_fr_energy))

(defmethod oszicar ((vasprun xml))
  (let* ((scstep (%scstep vasprun))
	 (energy (loop for step in scstep
	       collect (find-node-by-name "energy" (node-children step))))
	 (energy (loop for step in energy
	       collect (find-node-by-attrs '("name" "e_fr_energy")
					   (node-children step))))
	 (energy (mapcar #'second (mapcar #'parse-leaf energy)))
	 (dE (loop
		for E0 = 0 then E
		for E in energy
		collect (- E E0))))
    dE))

(defmethod converge ((vasprun xml))
  (let ((oszicar (oszicar vasprun)))
    (list (length oszicar) (lastcar oszicar))))
		  
	 
