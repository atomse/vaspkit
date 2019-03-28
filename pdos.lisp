(in-package :vaspkit)

(defmethod pdos-s ((vasprun xml))
  (let ((pdos (pdos vasprun)))
    (loop for ion in pdos
       collect (mapcar (rcurry #'subseq 0 2) ion))))

(defmethod pdos-p ((vasprun xml))
  (let ((pdos (pdos vasprun)))
    (loop for ion in pdos
       collect (mapcar (lambda (list)
			 (list (first list)
			       (apply #'+ (subseq list 1 4))))
		       ion))))

(defmethod pdos-d ((vasprun xml))
  (let ((pdos (pdos vasprun)))
    (loop for ion in pdos
       collect (mapcar (lambda (list)
			 (list (first list)
			       (apply #'+ (subseq list 4 9))))
		       ion))))

(defmethod pdos-f ((vasprun xml))
  (let ((pdos (pdos vasprun)))
    (loop for ion in pdos
       collect (mapcar (lambda (list)
			 (list (first list)
			       (apply #'+ (subseq list 9 16))))
		       ion))))

(defun sum-pdos (pdos)
  (apply #'mapcar (lambda (&rest pairs)
		    (list (first (car pairs))
			  (apply #'+ (mapcar #'second pairs))))
	 pdos))
		    
