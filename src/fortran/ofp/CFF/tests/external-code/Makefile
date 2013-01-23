all : check

check :
	@for file in *.f90 ; do \
           echo "Running test $$file"; \
           sglri -p ../../syntax/Fortran.tbl -i $$file -o $$file.ast; \
           if test $$? != 0 ; then \
             echo $$file "		FAILED!"; \
           else \
             echo $$file "		Passed"; \
           fi; \
        done;

clean :
	rm -f *.ast *.acff
	rm -f *.o *.mod
