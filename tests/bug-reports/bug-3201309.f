      CALL UVSET(NX,NY,NZ,HVAR,ZET,NP,DZ,DKM,UM,VM,UG,VG,TM,DCDX, ! { dg-warning "Rank mismatch" }
     *ITY,ISH,NSMT,F)
      END
