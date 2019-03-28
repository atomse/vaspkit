(in-package :vaspkit)

(defmethod bands ((vasprun xml))
  (let* ((kpoints (kpoints vasprun))
	 (eigenvalues (eigenvalues vasprun))
	 (nband (length (car eigenvalues)))
	 (bands
	  (loop for i from 0 below nband
	     collect (mapcar (compose #'car (curry #'nth i)) eigenvalues))))
    (list kpoints bands)))

(defmethod write-bands ((vasprun xml))
  (destructuring-bind (kpoints bands) (bands vasprun)
    (flet ((module (x y)
	     (sqrt (loop for element in (mapcar #'- x y)
		      sum (expt (coerce element 'double-float) 2)))))
      (let* ((divisions (kpoints-divisions vasprun))
	     (x (loop 
		   for k = (first kpoints) then nk
		   for nk in kpoints 
		   for dk = (module nk k)
		   for x = 0d0 then (+ x dk)
		   collect x))
	     (symmetry-points
	      (cons 0d0
		    (let ((length (length x)))
		      (loop for i from divisions to length
			 if (= (mod i divisions) 0)
			 collect (nth (1- i) x))))))
	(with-open-file (stream "band.dat" 
				:direction :output
				:if-exists :supersede
				:if-does-not-exist :create)
	  (format stream "# efermi: ~F~%" (efermi vasprun))
	  (format stream "# symmetry points: ~{~F ~}~%" symmetry-points)
	  (loop for band in bands
	     do (loop for a in x
		   for b in band
		   do (format stream "~F~20T~F~%" a b))
	     do (format stream "~%")))))))

(defmethod plot-bands ((vasprun xml) &key (ymin -10.0) (ymax 10.0))
  (write-bands vasprun)
  (let ((kpoints (car (bands vasprun))))
    (flet ((module (x y)
	     (sqrt (loop for element in (mapcar #'- x y)
		      sum (expt (coerce element 'double-float) 2)))))
      (let* ((divisions (kpoints-divisions vasprun))
	     (x (loop 
		   for k = (first kpoints) then nk
		   for nk in kpoints 
		   for dk = (module nk k)
		   for x = 0d0 then (+ x dk)
		   collect x))
	     (symmetry-points
	      (cons 0d0
		    (let ((length (length x)))
		      (loop for i from divisions to length
			 if (= (mod i divisions) 0)
			 collect (nth (1- i) x))))))
	(with-open-file (stream "band.gnuplot"
				:direction :output
				:if-exists :supersede
				:if-does-not-exist :create)
	  (format stream "set term epslatex standalone size 8.6cm,6cm~%~%")
	  (format stream "set linestyle 1 lw 2 lc rgb \"red\"~%~%")
	  (format stream "set out \"band.tex\"~%")
	  (format stream "set ylabel '$E\\,(\\mathrm{eV})$'~%")
	  (format stream "set xrange [0:~F]~%" (lastcar symmetry-points))
	  (format stream "set yrange [~F:~F]~%" ymin ymax)
	  (format stream "set arrow from 0,0 to ~F,0 nohead dashtype 2 lw 2~%" (lastcar symmetry-points))
	  (loop for p in symmetry-points
	     do (format stream "set arrow from ~F,~F to ~F,~F nohead lw 1~%" p ymin p ymax))
	  (format stream "set xtics (")
	  (format stream "~{'P' ~F~^, ~})~%" symmetry-points)
	  (format stream "plot \"band.dat\" u 1:($2-~F) w l ls 1 notitle~%" (efermi vasprun)))))))
	  
