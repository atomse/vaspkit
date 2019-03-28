(in-package :vaspkit)

(defmethod write-dos ((vasprun xml))
  (let* ((dos (dos vasprun))
	 (efermi (efermi vasprun)))
    (with-open-file (stream "dos.dat"
			    :direction :output
			    :if-exists :supersede
			    :if-does-not-exist :create)
      (format stream "# efermi: ~F~%" efermi)
      (loop for data in dos
	 do (format stream "~F~20T~F~%" (first data) (second data))))))

