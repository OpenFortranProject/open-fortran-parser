! -*- f90 -*-
!
! Copyright (c) 2009-2012 Cisco Systems, Inc.  All rights reserved.
! Copyright (c) 2009-2012 Los Alamos National Security, LLC.
!                         All rights reserved.
! Copyright (c) 2012      The University of Tennessee and The University
!                         of Tennessee Research Foundation.  All rights
!                         reserved.
! Copyright (c) 2012      Inria.  All rights reserved.
! $COPYRIGHT$
!
! This file provides the interface specifications for the MPI Fortran
! API bindings.  It effectively maps between public names ("MPI_Init")
! and the name for tools ("MPI_Init_f08") and the back-end implementation
! name (e.g., "MPI_Init_f08").

MODULE mpi_f08_interfaces

INTERFACE  MPI_Bsend
SUBROUTINE MPI_Bsend_f08(buf,count,datatype,dest,tag,comm,ierror &
           ) BIND(C,name="MPI_Bsend_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count, dest, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Bsend_f08
END INTERFACE  MPI_Bsend

INTERFACE  MPI_Bsend_init
SUBROUTINE MPI_Bsend_init_f08(buf,count,datatype,dest,tag,comm,request,ierror &
           ) BIND(C,name="MPI_Bsend_init_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   INTEGER, INTENT(IN) :: count, dest, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Bsend_init_f08
END INTERFACE  MPI_Bsend_init

INTERFACE  MPI_Buffer_attach
SUBROUTINE MPI_Buffer_attach_f08(buffer,size,ierror &
           ) BIND(C,name="MPI_Buffer_attach_f08")
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buffer
   INTEGER, INTENT(IN) :: size
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Buffer_attach_f08
END INTERFACE  MPI_Buffer_attach

INTERFACE  MPI_Buffer_detach
SUBROUTINE MPI_Buffer_detach_f08(buffer_addr,size,ierror &
           ) BIND(C,name="MPI_Buffer_detach_f08")
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buffer_addr
   INTEGER, INTENT(OUT) :: size
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Buffer_detach_f08
END INTERFACE  MPI_Buffer_detach

INTERFACE  MPI_Cancel
SUBROUTINE MPI_Cancel_f08(request,ierror &
           ) BIND(C,name="MPI_Cancel_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request
   IMPLICIT NONE
   TYPE(MPI_Request), INTENT(IN) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Cancel_f08
END INTERFACE  MPI_Cancel

INTERFACE  MPI_Get_count
SUBROUTINE MPI_Get_count_f08(status,datatype,count,ierror &
           ) BIND(C,name="MPI_Get_count_f08")
   USE :: mpi_f08_types, ONLY : MPI_Status, MPI_Datatype
   IMPLICIT NONE
   TYPE(MPI_Status), INTENT(IN) :: status
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, INTENT(OUT) :: count
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Get_count_f08
END INTERFACE  MPI_Get_count

INTERFACE  MPI_Ibsend
SUBROUTINE MPI_Ibsend_f08(buf,count,datatype,dest,tag,comm,request,ierror &
           ) BIND(C,name="MPI_Ibsend_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count, dest, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Ibsend_f08
END INTERFACE  MPI_Ibsend

INTERFACE  MPI_Iprobe
SUBROUTINE MPI_Iprobe_f08(source,tag,comm,flag,status,ierror &
           ) BIND(C,name="MPI_Iprobe_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Status
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: source, tag
   TYPE(MPI_Comm), INTENT(IN) :: comm
   LOGICAL, INTENT(OUT) :: flag
   TYPE(MPI_Status), INTENT(OUT) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Iprobe_f08
END INTERFACE  MPI_Iprobe

INTERFACE  MPI_Irecv
SUBROUTINE MPI_Irecv_f08(buf,count,datatype,source,tag,comm,request,ierror &
           ) BIND(C,name="MPI_Irecv_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   INTEGER, INTENT(IN) :: count, source, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Irecv_f08
END INTERFACE  MPI_Irecv

INTERFACE  MPI_Irsend
SUBROUTINE MPI_Irsend_f08(buf,count,datatype,dest,tag,comm,request,ierror &
           ) BIND(C,name="MPI_Irsend_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count, dest, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Irsend_f08
END INTERFACE  MPI_Irsend

INTERFACE  MPI_Isend
SUBROUTINE MPI_Isend_f08(buf,count,datatype,dest,tag,comm,request,ierror &
           ) BIND(C,name="MPI_Isend_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count, dest, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Isend_f08
END INTERFACE  MPI_Isend

INTERFACE  MPI_Issend
SUBROUTINE MPI_Issend_f08(buf,count,datatype,dest,tag,comm,request,ierror &
           ) BIND(C,name="MPI_Issend_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count, dest, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Issend_f08
END INTERFACE  MPI_Issend

INTERFACE  MPI_Probe
SUBROUTINE MPI_Probe_f08(source,tag,comm,status,ierror &
           ) BIND(C,name="MPI_Probe_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Status
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: source, tag
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Status), INTENT(OUT) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Probe_f08
END INTERFACE  MPI_Probe

INTERFACE  MPI_Recv
SUBROUTINE MPI_Recv_f08(buf,count,datatype,source,tag,comm,status,ierror &
           ) BIND(C,name="MPI_Recv_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Status
   IMPLICIT NONE
   TYPE(*), DIMENSION(..) :: buf
   INTEGER, INTENT(IN) :: count, source, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Recv_f08
END INTERFACE  MPI_Recv

INTERFACE  MPI_Recv_init
SUBROUTINE MPI_Recv_init_f08(buf,count,datatype,source,tag,comm,request,ierror &
           ) BIND(C,name="MPI_Recv_init_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   INTEGER, INTENT(IN) :: count, source, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Recv_init_f08
END INTERFACE  MPI_Recv_init

INTERFACE  MPI_Request_free
SUBROUTINE MPI_Request_free_f08(request,ierror &
           ) BIND(C,name="MPI_Request_free_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request
   IMPLICIT NONE
   TYPE(MPI_Request), INTENT(INOUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Request_free_f08
END INTERFACE  MPI_Request_free

INTERFACE  MPI_Request_get_status
SUBROUTINE MPI_Request_get_status_f08(request,flag,status,ierror &
           ) BIND(C,name="MPI_Request_get_status_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_Request), INTENT(IN) :: request
   LOGICAL, INTENT(OUT) :: flag
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Request_get_status_f08
END INTERFACE  MPI_Request_get_status

INTERFACE  MPI_Rsend
SUBROUTINE MPI_Rsend_f08(buf,count,datatype,dest,tag,comm,ierror &
           ) BIND(C,name="MPI_Rsend_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count, dest, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Rsend_f08
END INTERFACE  MPI_Rsend

INTERFACE  MPI_Rsend_init
SUBROUTINE MPI_Rsend_init_f08(buf,count,datatype,dest,tag,comm,request,ierror &
           ) BIND(C,name="MPI_Rsend_init_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   INTEGER, INTENT(IN) :: count, dest, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Rsend_init_f08
END INTERFACE  MPI_Rsend_init

INTERFACE  MPI_Send
SUBROUTINE MPI_Send_f08(buf,count,datatype,dest,tag,comm,ierror &
           ) BIND(C,name="MPI_Send_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count, dest, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Send_f08
END INTERFACE  MPI_Send

INTERFACE  MPI_Sendrecv
SUBROUTINE MPI_Sendrecv_f08(sendbuf,sendcount,sendtype,dest,sendtag,recvbuf, &
                            recvcount,recvtype,source,recvtag,comm,status,ierror &
           ) BIND(C,name="MPI_Sendrecv_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Status
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcount, dest, sendtag, recvcount, source, recvtag
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Sendrecv_f08
END INTERFACE  MPI_Sendrecv

INTERFACE  MPI_Sendrecv_replace
SUBROUTINE MPI_Sendrecv_replace_f08(buf,count,datatype,dest,sendtag,source,recvtag, &
                                    comm,status,ierror &
           ) BIND(C,name="MPI_Sendrecv_replace_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Status
   IMPLICIT NONE
   TYPE(*), DIMENSION(..) :: buf
   INTEGER, INTENT(IN) :: count, dest, sendtag, source, recvtag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Sendrecv_replace_f08
END INTERFACE  MPI_Sendrecv_replace

INTERFACE  MPI_Send_init
SUBROUTINE MPI_Send_init_f08(buf,count,datatype,dest,tag,comm,request,ierror &
           ) BIND(C,name="MPI_Send_init_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   INTEGER, INTENT(IN) :: count, dest, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Send_init_f08
END INTERFACE  MPI_Send_init

INTERFACE  MPI_Ssend
SUBROUTINE MPI_Ssend_f08(buf,count,datatype,dest,tag,comm,ierror &
           ) BIND(C,name="MPI_Ssend_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count, dest, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Ssend_f08
END INTERFACE  MPI_Ssend

INTERFACE  MPI_Ssend_init
SUBROUTINE MPI_Ssend_init_f08(buf,count,datatype,dest,tag,comm,request,ierror &
           ) BIND(C,name="MPI_Ssend_init_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   INTEGER, INTENT(IN) :: count, dest, tag
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Ssend_init_f08
END INTERFACE  MPI_Ssend_init

INTERFACE  MPI_Start
SUBROUTINE MPI_Start_f08(request,ierror &
           ) BIND(C,name="MPI_Start_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request
   IMPLICIT NONE
   TYPE(MPI_Request), INTENT(INOUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Start_f08
END INTERFACE  MPI_Start

INTERFACE  MPI_Startall
SUBROUTINE MPI_Startall_f08(count,array_of_requests,ierror &
           ) BIND(C,name="MPI_Startall_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Request), INTENT(INOUT) :: array_of_requests(count)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Startall_f08
END INTERFACE  MPI_Startall

INTERFACE  MPI_Test
SUBROUTINE MPI_Test_f08(request,flag,status,ierror &
           ) BIND(C,name="MPI_Test_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_Request), INTENT(INOUT) :: request
   LOGICAL, INTENT(OUT) :: flag
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Test_f08
END INTERFACE  MPI_Test

INTERFACE  MPI_Testall
SUBROUTINE MPI_Testall_f08(count,array_of_requests,flag,array_of_statuses,ierror &
           ) BIND(C,name="MPI_Testall_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request, MPI_Status
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Request), INTENT(INOUT) :: array_of_requests(count)
   LOGICAL, INTENT(OUT) :: flag
   TYPE(MPI_Status) :: array_of_statuses(*)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Testall_f08
END INTERFACE  MPI_Testall

INTERFACE  MPI_Testany
SUBROUTINE MPI_Testany_f08(count,array_of_requests,index,flag,status,ierror &
           ) BIND(C,name="MPI_Testany_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request, MPI_Status
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Request), INTENT(INOUT) :: array_of_requests(count)
   INTEGER, INTENT(OUT) :: index
   LOGICAL, INTENT(OUT) :: flag
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Testany_f08
END INTERFACE  MPI_Testany

INTERFACE  MPI_Testsome
SUBROUTINE MPI_Testsome_f08(incount,array_of_requests,outcount, &
                        array_of_indices,array_of_statuses,ierror &
           ) BIND(C,name="MPI_Testsome_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request, MPI_Status
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: incount
   TYPE(MPI_Request), INTENT(INOUT) :: array_of_requests(incount)
   INTEGER, INTENT(OUT) :: outcount, array_of_indices(*)
   TYPE(MPI_Status) :: array_of_statuses(*)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Testsome_f08
END INTERFACE  MPI_Testsome

INTERFACE  MPI_Test_cancelled
SUBROUTINE MPI_Test_cancelled_f08(status,flag,ierror &
           ) BIND(C,name="MPI_Test_cancelled_f08")
   USE :: mpi_f08_types, ONLY : MPI_Status
   IMPLICIT NONE
   TYPE(MPI_Status), INTENT(IN) :: status
   LOGICAL, INTENT(OUT) :: flag
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Test_cancelled_f08
END INTERFACE  MPI_Test_cancelled

INTERFACE  MPI_Wait
SUBROUTINE MPI_Wait_f08(request,status,ierror &
           ) BIND(C,name="MPI_Wait_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_Request), INTENT(INOUT) :: request
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Wait_f08
END INTERFACE  MPI_Wait

INTERFACE  MPI_Waitall
SUBROUTINE MPI_Waitall_f08(count,array_of_requests,array_of_statuses,ierror &
           ) BIND(C,name="MPI_Waitall_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request, MPI_Status
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Request), INTENT(INOUT) :: array_of_requests(count)
   TYPE(MPI_Status) :: array_of_statuses(*)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Waitall_f08
END INTERFACE  MPI_Waitall

INTERFACE  MPI_Waitany
SUBROUTINE MPI_Waitany_f08(count,array_of_requests,index,status,ierror &
           ) BIND(C,name="MPI_Waitany_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request, MPI_Status
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Request), INTENT(INOUT) :: array_of_requests(count)
   INTEGER, INTENT(OUT) :: index
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Waitany_f08
END INTERFACE  MPI_Waitany

INTERFACE  MPI_Waitsome
SUBROUTINE MPI_Waitsome_f08(incount,array_of_requests,outcount, &
                        array_of_indices,array_of_statuses,ierror &
           ) BIND(C,name="MPI_Waitsome_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request, MPI_Status
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: incount
   TYPE(MPI_Request), INTENT(INOUT) :: array_of_requests(incount)
   INTEGER, INTENT(OUT) :: outcount, array_of_indices(*)
   TYPE(MPI_Status) :: array_of_statuses(*)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Waitsome_f08
END INTERFACE  MPI_Waitsome

INTERFACE  MPI_Get_address
SUBROUTINE MPI_Get_address_f08(location,address,ierror &
           ) BIND(C,name="MPI_Get_address_f08")
   USE :: mpi_f08_types, ONLY : MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: location
   INTEGER(MPI_ADDRESS_KIND), INTENT(OUT) :: address
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Get_address_f08
END INTERFACE  MPI_Get_address

INTERFACE  MPI_Get_elements
SUBROUTINE MPI_Get_elements_f08(status,datatype,count,ierror &
           ) BIND(C,name="MPI_Get_elements_f08")
   USE :: mpi_f08_types, ONLY : MPI_Status, MPI_Datatype
   IMPLICIT NONE
   TYPE(MPI_Status), INTENT(IN) :: status
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, INTENT(OUT) :: count
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Get_elements_f08
END INTERFACE  MPI_Get_elements

INTERFACE  MPI_Pack
SUBROUTINE MPI_Pack_f08(inbuf,incount,datatype,outbuf,outsize,position,comm,ierror &
           ) BIND(C,name="MPI_Pack_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: inbuf
   TYPE(*), DIMENSION(..) :: outbuf
   INTEGER, INTENT(IN) :: incount, outsize
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, INTENT(INOUT) :: position
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Pack_f08
END INTERFACE  MPI_Pack

INTERFACE  MPI_Pack_external
SUBROUTINE MPI_Pack_external_f08(datarep,inbuf,incount,datatype,outbuf,outsize, &
                                 position,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_ADDRESS_KIND
   IMPLICIT NONE
   CHARACTER(LEN=*), INTENT(IN) :: datarep
   TYPE(*), DIMENSION(..), INTENT(IN) :: inbuf
   TYPE(*), DIMENSION(..) :: outbuf
   INTEGER, INTENT(IN) :: incount
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: outsize
   INTEGER(MPI_ADDRESS_KIND), INTENT(INOUT) :: position
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Pack_external_f08
END INTERFACE  MPI_Pack_external

INTERFACE  MPI_Pack_external_size
SUBROUTINE MPI_Pack_external_size_f08(datarep,incount,datatype,size,ierror &
           )
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, INTENT(IN) :: incount
   CHARACTER(LEN=*), INTENT(IN) :: datarep
   INTEGER(MPI_ADDRESS_KIND), INTENT(OUT) :: size
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Pack_external_size_f08
END INTERFACE  MPI_Pack_external_size

INTERFACE  MPI_Pack_size
SUBROUTINE MPI_Pack_size_f08(incount,datatype,comm,size,ierror &
           ) BIND(C,name="MPI_Pack_size_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: incount
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(OUT) :: size
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Pack_size_f08
END INTERFACE  MPI_Pack_size

INTERFACE  MPI_Type_commit
SUBROUTINE MPI_Type_commit_f08(datatype,ierror &
           ) BIND(C,name="MPI_Type_commit_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   TYPE(MPI_Datatype), INTENT(INOUT) :: datatype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_commit_f08
END INTERFACE  MPI_Type_commit

INTERFACE  MPI_Type_contiguous
SUBROUTINE MPI_Type_contiguous_f08(count,oldtype,newtype,ierror &
           ) BIND(C,name="MPI_Type_contiguous_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: oldtype
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_contiguous_f08
END INTERFACE  MPI_Type_contiguous

INTERFACE  MPI_Type_create_darray
SUBROUTINE MPI_Type_create_darray_f08(size,rank,ndims,array_of_gsizes, &
                    array_of_distribs,array_of_dargs,array_of_psizes,order, &
                    oldtype,newtype,ierror &
           ) BIND(C,name="MPI_Type_create_darray_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: size, rank, ndims, order
   INTEGER, INTENT(IN) :: array_of_gsizes(ndims), array_of_distribs(ndims)
   INTEGER, INTENT(IN) :: array_of_dargs(ndims), array_of_psizes(ndims)
   TYPE(MPI_Datatype), INTENT(IN) :: oldtype
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_create_darray_f08
END INTERFACE  MPI_Type_create_darray

INTERFACE  MPI_Type_create_hindexed
SUBROUTINE MPI_Type_create_hindexed_f08(count,array_of_blocklengths, &
                                        array_of_displacements,oldtype,newtype,ierror &
           ) BIND(C,name="MPI_Type_create_hindexed_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_ADDRESS_KIND
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: count
   INTEGER, INTENT(IN) :: array_of_blocklengths(count)
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: array_of_displacements(count)
   TYPE(MPI_Datatype), INTENT(IN) :: oldtype
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_create_hindexed_f08
END INTERFACE  MPI_Type_create_hindexed

INTERFACE  MPI_Type_create_hvector
SUBROUTINE MPI_Type_create_hvector_f08(count,blocklength,stride,oldtype,newtype,ierror &
           ) BIND(C,name="MPI_Type_create_hvector_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_ADDRESS_KIND
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: count, blocklength
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: stride
   TYPE(MPI_Datatype), INTENT(IN) :: oldtype
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_create_hvector_f08
END INTERFACE  MPI_Type_create_hvector

INTERFACE  MPI_Type_create_indexed_block
SUBROUTINE MPI_Type_create_indexed_block_f08(count,blocklength, &
                           array_of_displacements,oldtype,newtype,ierror &
           ) BIND(C,name="MPI_Type_create_indexed_block_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: count, blocklength
   INTEGER, INTENT(IN) :: array_of_displacements(count)
   TYPE(MPI_Datatype), INTENT(IN) :: oldtype
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_create_indexed_block_f08
END INTERFACE  MPI_Type_create_indexed_block

INTERFACE  MPI_Type_create_hindexed_block
SUBROUTINE MPI_Type_create_hindexed_block_f08(count,blocklength, &
                           array_of_displacements,oldtype,newtype,ierror &
           ) BIND(C,name="MPI_Type_create_hindexed_block_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_ADDRESS_KIND
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: count, blocklength
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: array_of_displacements(count)
   TYPE(MPI_Datatype), INTENT(IN) :: oldtype
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_create_hindexed_block_f08
END INTERFACE  MPI_Type_create_hindexed_block

INTERFACE  MPI_Type_create_resized
SUBROUTINE MPI_Type_create_resized_f08(oldtype,lb,extent,newtype,ierror &
           ) BIND(C,name="MPI_Type_create_resized_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_ADDRESS_KIND
   IMPLICIT NONE
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: lb, extent
   TYPE(MPI_Datatype), INTENT(IN) :: oldtype
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_create_resized_f08
END INTERFACE  MPI_Type_create_resized

INTERFACE  MPI_Type_create_struct
SUBROUTINE MPI_Type_create_struct_f08(count,array_of_blocklengths, &
                           array_of_displacements,array_of_types,newtype,ierror &
           ) BIND(C,name="MPI_Type_create_struct_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_ADDRESS_KIND
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: count
   INTEGER, INTENT(IN) :: array_of_blocklengths(count)
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: array_of_displacements(count)
   TYPE(MPI_Datatype), INTENT(IN) :: array_of_types(count)
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_create_struct_f08
END INTERFACE  MPI_Type_create_struct

INTERFACE  MPI_Type_create_subarray
SUBROUTINE MPI_Type_create_subarray_f08(ndims,array_of_sizes,array_of_subsizes, &
                    array_of_starts,order,oldtype,newtype,ierror &
           ) BIND(C,name="MPI_Type_create_subarray_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: ndims, order
   INTEGER, INTENT(IN) :: array_of_sizes(ndims), array_of_subsizes(ndims)
   INTEGER, INTENT(IN) :: array_of_starts(ndims)
   TYPE(MPI_Datatype), INTENT(IN) :: oldtype
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_create_subarray_f08
END INTERFACE  MPI_Type_create_subarray

INTERFACE  MPI_Type_dup
SUBROUTINE MPI_Type_dup_f08(oldtype,newtype,ierror &
           ) BIND(C,name="MPI_Type_dup_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   TYPE(MPI_Datatype), INTENT(IN) :: oldtype
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_dup_f08
END INTERFACE  MPI_Type_dup

INTERFACE  MPI_Type_free
SUBROUTINE MPI_Type_free_f08(datatype,ierror &
           ) BIND(C,name="MPI_Type_free_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   TYPE(MPI_Datatype), INTENT(INOUT) :: datatype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_free_f08
END INTERFACE  MPI_Type_free

INTERFACE  MPI_Type_get_contents
SUBROUTINE MPI_Type_get_contents_f08(datatype,max_integers,max_addresses,max_datatypes, &
                                     array_of_integers,array_of_addresses,array_of_datatypes, &
                                     ierror &
           ) BIND(C,name="MPI_Type_get_contents_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, INTENT(IN) :: max_integers, max_addresses, max_datatypes
   INTEGER, INTENT(OUT) :: array_of_integers(max_integers)
   INTEGER(MPI_ADDRESS_KIND), INTENT(OUT) :: array_of_addresses(max_addresses)
   TYPE(MPI_Datatype), INTENT(OUT) :: array_of_datatypes(max_datatypes)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_get_contents_f08
END INTERFACE  MPI_Type_get_contents

INTERFACE  MPI_Type_get_envelope
SUBROUTINE MPI_Type_get_envelope_f08(datatype,num_integers,num_addresses,num_datatypes, &
                                     combiner,ierror &
           ) BIND(C,name="MPI_Type_get_envelope_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, INTENT(OUT) :: num_integers, num_addresses, num_datatypes, combiner
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_get_envelope_f08
END INTERFACE  MPI_Type_get_envelope

INTERFACE  MPI_Type_get_extent
SUBROUTINE MPI_Type_get_extent_f08(datatype,lb,extent,ierror &
           ) BIND(C,name="MPI_Type_get_extent_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER(MPI_ADDRESS_KIND), INTENT(OUT) :: lb, extent
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_get_extent_f08
END INTERFACE  MPI_Type_get_extent

INTERFACE  MPI_Type_get_true_extent
SUBROUTINE MPI_Type_get_true_extent_f08(datatype,true_lb,true_extent,ierror &
           ) BIND(C,name="MPI_Type_get_true_extent_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER(MPI_ADDRESS_KIND), INTENT(OUT) :: true_lb, true_extent
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_get_true_extent_f08
END INTERFACE  MPI_Type_get_true_extent

INTERFACE  MPI_Type_indexed
SUBROUTINE MPI_Type_indexed_f08(count,array_of_blocklengths, &
                                array_of_displacements,oldtype,newtype,ierror &
           ) BIND(C,name="MPI_Type_indexed_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: count
   INTEGER, INTENT(IN) :: array_of_blocklengths(count), array_of_displacements(count)
   TYPE(MPI_Datatype), INTENT(IN) :: oldtype
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_indexed_f08
END INTERFACE  MPI_Type_indexed

INTERFACE  MPI_Type_size
SUBROUTINE MPI_Type_size_f08(datatype,size,ierror &
           ) BIND(C,name="MPI_Type_size_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, INTENT(OUT) :: size
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_size_f08
END INTERFACE  MPI_Type_size

INTERFACE  MPI_Type_vector
SUBROUTINE MPI_Type_vector_f08(count,blocklength,stride,oldtype,newtype,ierror &
           ) BIND(C,name="MPI_Type_vector_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: count, blocklength, stride
   TYPE(MPI_Datatype), INTENT(IN) :: oldtype
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_vector_f08
END INTERFACE  MPI_Type_vector

INTERFACE  MPI_Unpack
SUBROUTINE MPI_Unpack_f08(inbuf,insize,position,outbuf,outcount,datatype,comm, &
                          ierror &
           ) BIND(C,name="MPI_Unpack_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: inbuf
   TYPE(*), DIMENSION(..) :: outbuf
   INTEGER, INTENT(IN) :: insize, outcount
   INTEGER, INTENT(INOUT) :: position
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Unpack_f08
END INTERFACE  MPI_Unpack

INTERFACE  MPI_Unpack_external
SUBROUTINE MPI_Unpack_external_f08(datarep,inbuf,insize,position,outbuf,outcount, &
                                   datatype,ierror &
           )
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_ADDRESS_KIND
   IMPLICIT NONE
   CHARACTER(LEN=*), INTENT(IN) :: datarep
   TYPE(*), DIMENSION(..), INTENT(IN) :: inbuf
   TYPE(*), DIMENSION(..) :: outbuf
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: insize
   INTEGER(MPI_ADDRESS_KIND), INTENT(INOUT) :: position
   INTEGER, INTENT(IN) :: outcount
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Unpack_external_f08
END INTERFACE  MPI_Unpack_external

INTERFACE  MPI_Allgather
SUBROUTINE MPI_Allgather_f08(sendbuf,sendcount,sendtype,recvbuf,recvcount,recvtype, &
                             comm,ierror &
           ) BIND(C,name="MPI_Allgather_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcount, recvcount
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Allgather_f08
END INTERFACE  MPI_Allgather

INTERFACE  MPI_Iallgather
SUBROUTINE MPI_Iallgather_f08(sendbuf,sendcount,sendtype,recvbuf,recvcount,recvtype, &
                             comm,request,ierror &
           ) BIND(C,name="MPI_Iallgather_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcount, recvcount
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Iallgather_f08
END INTERFACE  MPI_Iallgather

INTERFACE  MPI_Allgatherv
SUBROUTINE MPI_Allgatherv_f08(sendbuf,sendcount,sendtype,recvbuf,recvcounts,displs, &
                              recvtype,comm,ierror &
           ) BIND(C,name="MPI_Allgatherv_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcount
   INTEGER, INTENT(IN) :: recvcounts(*), displs(*)
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Allgatherv_f08
END INTERFACE  MPI_Allgatherv

INTERFACE  MPI_Iallgatherv
SUBROUTINE MPI_Iallgatherv_f08(sendbuf,sendcount,sendtype,recvbuf,recvcounts,displs, &
                              recvtype,comm,request,ierror &
           ) BIND(C,name="MPI_Iallgatherv_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcount
   INTEGER, INTENT(IN) :: recvcounts(*), displs(*)
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Iallgatherv_f08
END INTERFACE  MPI_Iallgatherv

INTERFACE  MPI_Allreduce
SUBROUTINE MPI_Allreduce_f08(sendbuf,recvbuf,count,datatype,op,comm,ierror &
           ) BIND(C,name="MPI_Allreduce_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Op, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Op), INTENT(IN) :: op
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Allreduce_f08
END INTERFACE  MPI_Allreduce

INTERFACE  MPI_Iallreduce
SUBROUTINE MPI_Iallreduce_f08(sendbuf,recvbuf,count,datatype,op,comm,request,ierror &
           ) BIND(C,name="MPI_Iallreduce_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Op, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Op), INTENT(IN) :: op
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Iallreduce_f08
END INTERFACE  MPI_Iallreduce

INTERFACE  MPI_Alltoall
SUBROUTINE MPI_Alltoall_f08(sendbuf,sendcount,sendtype,recvbuf,recvcount,recvtype, &
                            comm,ierror &
           ) BIND(C,name="MPI_Alltoall_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcount, recvcount
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Alltoall_f08
END INTERFACE  MPI_Alltoall

INTERFACE  MPI_Ialltoall
SUBROUTINE MPI_Ialltoall_f08(sendbuf,sendcount,sendtype,recvbuf,recvcount,recvtype, &
                            comm,request,ierror &
           ) BIND(C,name="MPI_Ialltoall_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcount, recvcount
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Ialltoall_f08
END INTERFACE  MPI_Ialltoall

INTERFACE  MPI_Alltoallv
SUBROUTINE MPI_Alltoallv_f08(sendbuf,sendcounts,sdispls,sendtype,recvbuf,recvcounts, &
                             rdispls,recvtype,comm,ierror &
           ) BIND(C,name="MPI_Alltoallv_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcounts(*), sdispls(*), recvcounts(*), rdispls(*)
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Alltoallv_f08
END INTERFACE  MPI_Alltoallv

INTERFACE  MPI_Ialltoallv
SUBROUTINE MPI_Ialltoallv_f08(sendbuf,sendcounts,sdispls,sendtype,recvbuf,recvcounts, &
                             rdispls,recvtype,comm,request,ierror &
           ) BIND(C,name="MPI_Ialltoallv_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcounts(*), sdispls(*), recvcounts(*), rdispls(*)
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(IN) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Ialltoallv_f08
END INTERFACE  MPI_Ialltoallv

INTERFACE  MPI_Alltoallw
SUBROUTINE MPI_Alltoallw_f08(sendbuf,sendcounts,sdispls,sendtypes,recvbuf,recvcounts, &
                             rdispls,recvtypes,comm,ierror &
           ) BIND(C,name="MPI_Alltoallw_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcounts(*), sdispls(*), recvcounts(*), rdispls(*)
   TYPE(MPI_Datatype), INTENT(IN) :: sendtypes(*), recvtypes(*)
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Alltoallw_f08
END INTERFACE  MPI_Alltoallw

INTERFACE  MPI_Ialltoallw
SUBROUTINE MPI_Ialltoallw_f08(sendbuf,sendcounts,sdispls,sendtypes,recvbuf,recvcounts, &
                             rdispls,recvtypes,comm,request,ierror &
           ) BIND(C,name="MPI_Ialltoallw_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcounts(*), sdispls(*), recvcounts(*), rdispls(*)
   TYPE(MPI_Datatype), INTENT(IN) :: sendtypes(*), recvtypes(*)
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(IN) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Ialltoallw_f08
END INTERFACE  MPI_Ialltoallw

INTERFACE  MPI_Barrier
SUBROUTINE MPI_Barrier_f08(comm,ierror &
           ) BIND(C,name="MPI_Barrier_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Barrier_f08
END INTERFACE  MPI_Barrier

INTERFACE  MPI_Ibarrier
SUBROUTINE MPI_Ibarrier_f08(comm,request,ierror &
           ) BIND(C,name="MPI_Ibarrier_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Ibarrier_f08
END INTERFACE  MPI_Ibarrier

INTERFACE  MPI_Bcast
SUBROUTINE MPI_Bcast_f08(buffer,count,datatype,root,comm,ierror &
           ) BIND(C,name="MPI_Bcast_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..) :: buffer
   INTEGER, INTENT(IN) :: count, root
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Bcast_f08
END INTERFACE  MPI_Bcast

INTERFACE  MPI_Ibcast
SUBROUTINE MPI_Ibcast_f08(buffer,count,datatype,root,comm,request,ierror &
           ) BIND(C,name="MPI_Ibcast_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..) :: buffer
   INTEGER, INTENT(IN) :: count, root
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Ibcast_f08
END INTERFACE  MPI_Ibcast

INTERFACE  MPI_Exscan
SUBROUTINE MPI_Exscan_f08(sendbuf,recvbuf,count,datatype,op,comm,ierror &
           ) BIND(C,name="MPI_Exscan_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Op, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Op), INTENT(IN) :: op
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Exscan_f08
END INTERFACE  MPI_Exscan

INTERFACE  MPI_Iexscan
SUBROUTINE MPI_Iexscan_f08(sendbuf,recvbuf,count,datatype,op,comm,request,ierror &
           ) BIND(C,name="MPI_Iexscan_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Op, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Op), INTENT(IN) :: op
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Iexscan_f08
END INTERFACE  MPI_Iexscan

INTERFACE  MPI_Gather
SUBROUTINE MPI_Gather_f08(sendbuf,sendcount,sendtype,recvbuf,recvcount,recvtype, &
                          root,comm,ierror &
           ) BIND(C,name="MPI_Gather_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcount, recvcount, root
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Gather_f08
END INTERFACE  MPI_Gather

INTERFACE  MPI_Igather
SUBROUTINE MPI_Igather_f08(sendbuf,sendcount,sendtype,recvbuf,recvcount,recvtype, &
                          root,comm,request,ierror &
           ) BIND(C,name="MPI_Igather_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcount, recvcount, root
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Igather_f08
END INTERFACE  MPI_Igather

INTERFACE  MPI_Gatherv
SUBROUTINE MPI_Gatherv_f08(sendbuf,sendcount,sendtype,recvbuf,recvcounts,displs, &
                           recvtype,root,comm,ierror &
           ) BIND(C,name="MPI_Gatherv_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcount, root
   INTEGER, INTENT(IN) :: recvcounts(*), displs(*)
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Gatherv_f08
END INTERFACE  MPI_Gatherv

INTERFACE  MPI_Igatherv
SUBROUTINE MPI_Igatherv_f08(sendbuf,sendcount,sendtype,recvbuf,recvcounts,displs, &
                           recvtype,root,comm,request,ierror &
           ) BIND(C,name="MPI_Igatherv_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcount, root
   INTEGER, INTENT(IN) :: recvcounts(*), displs(*)
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Igatherv_f08
END INTERFACE  MPI_Igatherv

INTERFACE  MPI_Op_commutative
SUBROUTINE MPI_Op_commutative_f08(op,commute,ierror &
           ) BIND(C,name="MPI_Op_commutative_f08")
   USE :: mpi_f08_types, ONLY : MPI_Op
   IMPLICIT NONE
   TYPE(MPI_Op), INTENT(IN) :: op
   LOGICAL, INTENT(OUT) :: commute
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Op_commutative_f08
END INTERFACE  MPI_Op_commutative

INTERFACE  MPI_Op_create
SUBROUTINE MPI_Op_create_f08(user_fn,commute,op,ierror &
           ) BIND(C,name="MPI_Op_create_f08")
   USE :: mpi_f08_types, ONLY : MPI_Op
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_User_function
   IMPLICIT NONE
   PROCEDURE(MPI_User_function) :: user_fn
   LOGICAL, INTENT(IN) :: commute
   TYPE(MPI_Op), INTENT(OUT) :: op
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Op_create_f08
END INTERFACE  MPI_Op_create

INTERFACE  MPI_Op_free
SUBROUTINE MPI_Op_free_f08(op,ierror &
           ) BIND(C,name="MPI_Op_free_f08")
   USE :: mpi_f08_types, ONLY : MPI_Op
   IMPLICIT NONE
   TYPE(MPI_Op), INTENT(INOUT) :: op
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Op_free_f08
END INTERFACE  MPI_Op_free

INTERFACE  MPI_Reduce
SUBROUTINE MPI_Reduce_f08(sendbuf,recvbuf,count,datatype,op,root,comm,ierror &
           ) BIND(C,name="MPI_Reduce_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Op, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: count, root
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Op), INTENT(IN) :: op
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Reduce_f08
END INTERFACE  MPI_Reduce

INTERFACE  MPI_Ireduce
SUBROUTINE MPI_Ireduce_f08(sendbuf,recvbuf,count,datatype,op,root,comm,request,ierror &
           ) BIND(C,name="MPI_Ireduce_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Op, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: count, root
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Op), INTENT(IN) :: op
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Ireduce_f08
END INTERFACE  MPI_Ireduce

INTERFACE  MPI_Reduce_local
SUBROUTINE MPI_Reduce_local_f08(inbuf,inoutbuf,count,datatype,op,ierror &
           ) BIND(C,name="MPI_Reduce_local_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Op
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: inbuf
   TYPE(*), DIMENSION(..) :: inoutbuf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Op), INTENT(IN) :: op
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Reduce_local_f08
END INTERFACE  MPI_Reduce_local

INTERFACE  MPI_Reduce_scatter
SUBROUTINE MPI_Reduce_scatter_f08(sendbuf,recvbuf,recvcounts,datatype,op,comm, &
                                  ierror &
           ) BIND(C,name="MPI_Reduce_scatter_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Op, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: recvcounts(*)
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Op), INTENT(IN) :: op
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Reduce_scatter_f08
END INTERFACE  MPI_Reduce_scatter

INTERFACE  MPI_Ireduce_scatter
SUBROUTINE MPI_Ireduce_scatter_f08(sendbuf,recvbuf,recvcounts,datatype,op,comm, &
                                  request,ierror &
           ) BIND(C,name="MPI_Ireduce_scatter_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Op, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: recvcounts(*)
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Op), INTENT(IN) :: op
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Ireduce_scatter_f08
END INTERFACE  MPI_Ireduce_scatter

INTERFACE  MPI_Reduce_scatter_block
SUBROUTINE MPI_Reduce_scatter_block_f08(sendbuf,recvbuf,recvcount,datatype,op,comm, &
                                        ierror &
           ) BIND(C,name="MPI_Reduce_scatter_block_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Op, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: recvcount
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Op), INTENT(IN) :: op
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Reduce_scatter_block_f08
END INTERFACE  MPI_Reduce_scatter_block

INTERFACE  MPI_Ireduce_scatter_block
SUBROUTINE MPI_Ireduce_scatter_block_f08(sendbuf,recvbuf,recvcount,datatype,op,comm, &
                                        request,ierror &
           ) BIND(C,name="MPI_Ireduce_scatter_block_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Op, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: recvcount
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Op), INTENT(IN) :: op
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Ireduce_scatter_block_f08
END INTERFACE  MPI_Ireduce_scatter_block

INTERFACE  MPI_Scan
SUBROUTINE MPI_Scan_f08(sendbuf,recvbuf,count,datatype,op,comm,ierror &
           ) BIND(C,name="MPI_Scan_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Op, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Op), INTENT(IN) :: op
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Scan_f08
END INTERFACE  MPI_Scan

INTERFACE  MPI_Iscan
SUBROUTINE MPI_Iscan_f08(sendbuf,recvbuf,count,datatype,op,comm,request,ierror &
           ) BIND(C,name="MPI_Iscan_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Op, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Op), INTENT(IN) :: op
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Iscan_f08
END INTERFACE  MPI_Iscan

INTERFACE  MPI_Scatter
SUBROUTINE MPI_Scatter_f08(sendbuf,sendcount,sendtype,recvbuf,recvcount,recvtype, &
                           root,comm,ierror &
           ) BIND(C,name="MPI_Scatter_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcount, recvcount, root
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Scatter_f08
END INTERFACE  MPI_Scatter

INTERFACE  MPI_Iscatter
SUBROUTINE MPI_Iscatter_f08(sendbuf,sendcount,sendtype,recvbuf,recvcount,recvtype, &
                           root,comm,request,ierror &
           ) BIND(C,name="MPI_Iscatter_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: sendcount, recvcount, root
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Iscatter_f08
END INTERFACE  MPI_Iscatter

INTERFACE  MPI_Scatterv
SUBROUTINE MPI_Scatterv_f08(sendbuf,sendcounts,displs,sendtype,recvbuf,recvcount, &
                            recvtype,root,comm,ierror &
           ) BIND(C,name="MPI_Scatterv_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: recvcount, root
   INTEGER, INTENT(IN) :: sendcounts(*), displs(*)
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Scatterv_f08
END INTERFACE  MPI_Scatterv

INTERFACE  MPI_Iscatterv
SUBROUTINE MPI_Iscatterv_f08(sendbuf,sendcounts,displs,sendtype,recvbuf,recvcount, &
                            recvtype,root,comm,request,ierror &
           ) BIND(C,name="MPI_Iscatterv_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Comm, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), INTENT(IN) :: sendbuf
   TYPE(*), DIMENSION(..) :: recvbuf
   INTEGER, INTENT(IN) :: recvcount, root
   INTEGER, INTENT(IN) :: sendcounts(*), displs(*)
   TYPE(MPI_Datatype), INTENT(IN) :: sendtype, recvtype
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Iscatterv_f08
END INTERFACE  MPI_Iscatterv

INTERFACE  MPI_Comm_compare
SUBROUTINE MPI_Comm_compare_f08(comm1,comm2,result,ierror &
           ) BIND(C,name="MPI_Comm_compare_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm1
   TYPE(MPI_Comm), INTENT(IN) :: comm2
   INTEGER, INTENT(OUT) :: result
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_compare_f08
END INTERFACE  MPI_Comm_compare

INTERFACE  MPI_Comm_create
SUBROUTINE MPI_Comm_create_f08(comm,group,newcomm,ierror &
           ) BIND(C,name="MPI_Comm_create_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Group), INTENT(IN) :: group
   TYPE(MPI_Comm), INTENT(OUT) :: newcomm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_create_f08
END INTERFACE  MPI_Comm_create

INTERFACE  MPI_Comm_create_keyval
SUBROUTINE MPI_Comm_create_keyval_f08(comm_copy_attr_fn,comm_delete_attr_fn,comm_keyval, &
                                      extra_state,ierror &
           ) BIND(C,name="MPI_Comm_create_keyval_f08")
   USE :: mpi_f08_types, ONLY : MPI_ADDRESS_KIND
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_Comm_copy_attr_function
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_Comm_delete_attr_function
   IMPLICIT NONE
   PROCEDURE(MPI_Comm_copy_attr_function) :: comm_copy_attr_fn
   PROCEDURE(MPI_Comm_delete_attr_function) :: comm_delete_attr_fn
   INTEGER, INTENT(OUT) :: comm_keyval
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: extra_state
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_create_keyval_f08
END INTERFACE  MPI_Comm_create_keyval

INTERFACE  MPI_Comm_delete_attr
SUBROUTINE MPI_Comm_delete_attr_f08(comm,comm_keyval,ierror &
           ) BIND(C,name="MPI_Comm_delete_attr_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: comm_keyval
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_delete_attr_f08
END INTERFACE  MPI_Comm_delete_attr

INTERFACE  MPI_Comm_dup
SUBROUTINE MPI_Comm_dup_f08(comm,newcomm,ierror &
           ) BIND(C,name="MPI_Comm_dup_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Comm), INTENT(OUT) :: newcomm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_dup_f08
END INTERFACE  MPI_Comm_dup

INTERFACE  MPI_Comm_free
SUBROUTINE MPI_Comm_free_f08(comm,ierror &
           ) BIND(C,name="MPI_Comm_free_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(INOUT) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_free_f08
END INTERFACE  MPI_Comm_free

INTERFACE  MPI_Comm_free_keyval
SUBROUTINE MPI_Comm_free_keyval_f08(comm_keyval,ierror &
           ) BIND(C,name="MPI_Comm_free_keyval_f08")
   IMPLICIT NONE
   INTEGER, INTENT(INOUT) :: comm_keyval
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_free_keyval_f08
END INTERFACE  MPI_Comm_free_keyval

INTERFACE  MPI_Comm_get_attr
SUBROUTINE MPI_Comm_get_attr_f08(comm,comm_keyval,attribute_val,flag,ierror &
           ) BIND(C,name="MPI_Comm_get_attr_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: comm_keyval
   INTEGER(MPI_ADDRESS_KIND), INTENT(OUT) :: attribute_val
   LOGICAL, INTENT(OUT) :: flag
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_get_attr_f08
END INTERFACE  MPI_Comm_get_attr

INTERFACE  MPI_Comm_get_name
SUBROUTINE MPI_Comm_get_name_f08(comm,comm_name,resultlen,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_MAX_OBJECT_NAME
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   CHARACTER(LEN=MPI_MAX_OBJECT_NAME), INTENT(OUT) :: comm_name
   INTEGER, INTENT(OUT) :: resultlen
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_get_name_f08
END INTERFACE  MPI_Comm_get_name

INTERFACE  MPI_Comm_group
SUBROUTINE MPI_Comm_group_f08(comm,group,ierror &
           ) BIND(C,name="MPI_Comm_group_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Group), INTENT(OUT) :: group
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_group_f08
END INTERFACE  MPI_Comm_group

INTERFACE  MPI_Comm_rank
SUBROUTINE MPI_Comm_rank_f08(comm,rank,ierror &
           ) BIND(C,name="MPI_Comm_rank_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(OUT) :: rank
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_rank_f08
END INTERFACE  MPI_Comm_rank

INTERFACE  MPI_Comm_remote_group
SUBROUTINE MPI_Comm_remote_group_f08(comm,group,ierror &
           ) BIND(C,name="MPI_Comm_remote_group_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Group), INTENT(OUT) :: group
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_remote_group_f08
END INTERFACE  MPI_Comm_remote_group

INTERFACE  MPI_Comm_remote_size
SUBROUTINE MPI_Comm_remote_size_f08(comm,size,ierror &
           ) BIND(C,name="MPI_Comm_remote_size_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(OUT) :: size
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_remote_size_f08
END INTERFACE  MPI_Comm_remote_size

INTERFACE  MPI_Comm_set_attr
SUBROUTINE MPI_Comm_set_attr_f08(comm,comm_keyval,attribute_val,ierror &
           ) BIND(C,name="MPI_Comm_set_attr_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: comm_keyval
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: attribute_val
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_set_attr_f08
END INTERFACE  MPI_Comm_set_attr

INTERFACE  MPI_Comm_set_name
SUBROUTINE MPI_Comm_set_name_f08(comm,comm_name,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   CHARACTER(LEN=*), INTENT(IN) :: comm_name
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_set_name_f08
END INTERFACE  MPI_Comm_set_name

INTERFACE  MPI_Comm_size
SUBROUTINE MPI_Comm_size_f08(comm,size,ierror &
           ) BIND(C,name="MPI_Comm_size_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(OUT) :: size
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_size_f08
END INTERFACE  MPI_Comm_size

INTERFACE  MPI_Comm_split
SUBROUTINE MPI_Comm_split_f08(comm,color,key,newcomm,ierror &
           ) BIND(C,name="MPI_Comm_split_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: color, key
   TYPE(MPI_Comm), INTENT(OUT) :: newcomm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_split_f08
END INTERFACE  MPI_Comm_split

INTERFACE  MPI_Comm_test_inter
SUBROUTINE MPI_Comm_test_inter_f08(comm,flag,ierror &
           ) BIND(C,name="MPI_Comm_test_inter_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   LOGICAL, INTENT(OUT) :: flag
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_test_inter_f08
END INTERFACE  MPI_Comm_test_inter

INTERFACE  MPI_Group_compare
SUBROUTINE MPI_Group_compare_f08(group1,group2,result,ierror &
           ) BIND(C,name="MPI_Group_compare_f08")
   USE :: mpi_f08_types, ONLY : MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Group), INTENT(IN) :: group1, group2
   INTEGER, INTENT(OUT) :: result
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Group_compare_f08
END INTERFACE  MPI_Group_compare

INTERFACE  MPI_Group_difference
SUBROUTINE MPI_Group_difference_f08(group1,group2,newgroup,ierror &
           ) BIND(C,name="MPI_Group_difference_f08")
   USE :: mpi_f08_types, ONLY : MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Group), INTENT(IN) :: group1, group2
   TYPE(MPI_Group), INTENT(OUT) :: newgroup
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Group_difference_f08
END INTERFACE  MPI_Group_difference

INTERFACE  MPI_Group_excl
SUBROUTINE MPI_Group_excl_f08(group,n,ranks,newgroup,ierror &
           ) BIND(C,name="MPI_Group_excl_f08")
   USE :: mpi_f08_types, ONLY : MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Group), INTENT(IN) :: group
   INTEGER, INTENT(IN) :: n, ranks(n)
   TYPE(MPI_Group), INTENT(OUT) :: newgroup
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Group_excl_f08
END INTERFACE  MPI_Group_excl

INTERFACE  MPI_Group_free
SUBROUTINE MPI_Group_free_f08(group,ierror &
           ) BIND(C,name="MPI_Group_free_f08")
   USE :: mpi_f08_types, ONLY : MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Group), INTENT(INOUT) :: group
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Group_free_f08
END INTERFACE  MPI_Group_free

INTERFACE  MPI_Group_incl
SUBROUTINE MPI_Group_incl_f08(group,n,ranks,newgroup,ierror &
           ) BIND(C,name="MPI_Group_incl_f08")
   USE :: mpi_f08_types, ONLY : MPI_Group
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: n, ranks(n)
   TYPE(MPI_Group), INTENT(IN) :: group
   TYPE(MPI_Group), INTENT(OUT) :: newgroup
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Group_incl_f08
END INTERFACE  MPI_Group_incl

INTERFACE  MPI_Group_intersection
SUBROUTINE MPI_Group_intersection_f08(group1,group2,newgroup,ierror &
           ) BIND(C,name="MPI_Group_intersection_f08")
   USE :: mpi_f08_types, ONLY : MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Group), INTENT(IN) :: group1, group2
   TYPE(MPI_Group), INTENT(OUT) :: newgroup
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Group_intersection_f08
END INTERFACE  MPI_Group_intersection

INTERFACE  MPI_Group_range_excl
SUBROUTINE MPI_Group_range_excl_f08(group,n,ranges,newgroup,ierror &
           ) BIND(C,name="MPI_Group_range_excl_f08")
   USE :: mpi_f08_types, ONLY : MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Group), INTENT(IN) :: group
   INTEGER, INTENT(IN) :: n, ranges(3,n)
   TYPE(MPI_Group), INTENT(OUT) :: newgroup
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Group_range_excl_f08
END INTERFACE  MPI_Group_range_excl

INTERFACE  MPI_Group_range_incl
SUBROUTINE MPI_Group_range_incl_f08(group,n,ranges,newgroup,ierror &
           ) BIND(C,name="MPI_Group_range_incl_f08")
   USE :: mpi_f08_types, ONLY : MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Group), INTENT(IN) :: group
   INTEGER, INTENT(IN) :: n, ranges(3,n)
   TYPE(MPI_Group), INTENT(OUT) :: newgroup
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Group_range_incl_f08
END INTERFACE  MPI_Group_range_incl

INTERFACE  MPI_Group_rank
SUBROUTINE MPI_Group_rank_f08(group,rank,ierror &
           ) BIND(C,name="MPI_Group_rank_f08")
   USE :: mpi_f08_types, ONLY : MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Group), INTENT(IN) :: group
   INTEGER, INTENT(OUT) :: rank
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Group_rank_f08
END INTERFACE  MPI_Group_rank

INTERFACE  MPI_Group_size
SUBROUTINE MPI_Group_size_f08(group,size,ierror &
           ) BIND(C,name="MPI_Group_size_f08")
   USE :: mpi_f08_types, ONLY : MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Group), INTENT(IN) :: group
   INTEGER, INTENT(OUT) :: size
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Group_size_f08
END INTERFACE  MPI_Group_size

INTERFACE  MPI_Group_translate_ranks
SUBROUTINE MPI_Group_translate_ranks_f08(group1,n,ranks1,group2,ranks2,ierror &
           ) BIND(C,name="MPI_Group_translate_ranks_f08")
   USE :: mpi_f08_types, ONLY : MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Group), INTENT(IN) :: group1, group2
   INTEGER, INTENT(IN) :: n
   INTEGER, INTENT(IN) :: ranks1(n)
   INTEGER, INTENT(OUT) :: ranks2(n)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Group_translate_ranks_f08
END INTERFACE  MPI_Group_translate_ranks

INTERFACE  MPI_Group_union
SUBROUTINE MPI_Group_union_f08(group1,group2,newgroup,ierror &
           ) BIND(C,name="MPI_Group_union_f08")
   USE :: mpi_f08_types, ONLY : MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Group), INTENT(IN) :: group1, group2
   TYPE(MPI_Group), INTENT(OUT) :: newgroup
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Group_union_f08
END INTERFACE  MPI_Group_union

INTERFACE  MPI_Intercomm_create
SUBROUTINE MPI_Intercomm_create_f08(local_comm,local_leader,peer_comm,remote_leader, &
                                    tag,newintercomm,ierror &
           ) BIND(C,name="MPI_Intercomm_create_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: local_comm, peer_comm
   INTEGER, INTENT(IN) :: local_leader, remote_leader, tag
   TYPE(MPI_Comm), INTENT(OUT) :: newintercomm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Intercomm_create_f08
END INTERFACE  MPI_Intercomm_create

INTERFACE  MPI_Intercomm_merge
SUBROUTINE MPI_Intercomm_merge_f08(intercomm,high,newintracomm,ierror &
           ) BIND(C,name="MPI_Intercomm_merge_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: intercomm
   LOGICAL, INTENT(IN) :: high
   TYPE(MPI_Comm), INTENT(OUT) :: newintracomm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Intercomm_merge_f08
END INTERFACE  MPI_Intercomm_merge

INTERFACE  MPI_Type_create_keyval
SUBROUTINE MPI_Type_create_keyval_f08(type_copy_attr_fn,type_delete_attr_fn,type_keyval, &
                                      extra_state,ierror &
           ) BIND(C,name="MPI_Type_create_keyval_f08")
   USE :: mpi_f08_types, ONLY : MPI_ADDRESS_KIND
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_Type_copy_attr_function
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_Type_delete_attr_function
   IMPLICIT NONE
   PROCEDURE(MPI_Type_copy_attr_function) :: type_copy_attr_fn
   PROCEDURE(MPI_Type_delete_attr_function) :: type_delete_attr_fn
   INTEGER, INTENT(OUT) :: type_keyval
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: extra_state
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_create_keyval_f08
END INTERFACE  MPI_Type_create_keyval

INTERFACE  MPI_Type_delete_attr
SUBROUTINE MPI_Type_delete_attr_f08(datatype,type_keyval,ierror &
           ) BIND(C,name="MPI_Type_delete_attr_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, INTENT(IN) :: type_keyval
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_delete_attr_f08
END INTERFACE  MPI_Type_delete_attr

INTERFACE  MPI_Type_free_keyval
SUBROUTINE MPI_Type_free_keyval_f08(type_keyval,ierror &
           ) BIND(C,name="MPI_Type_free_keyval_f08")
   IMPLICIT NONE
   INTEGER, INTENT(INOUT) :: type_keyval
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_free_keyval_f08
END INTERFACE  MPI_Type_free_keyval

INTERFACE  MPI_Type_get_attr
SUBROUTINE MPI_Type_get_attr_f08(datatype,type_keyval,attribute_val,flag,ierror &
           ) BIND(C,name="MPI_Type_get_attr_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, INTENT(IN) :: type_keyval
   INTEGER(MPI_ADDRESS_KIND), INTENT(OUT) :: attribute_val
   LOGICAL, INTENT(OUT) :: flag
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_get_attr_f08
END INTERFACE  MPI_Type_get_attr

INTERFACE  MPI_Type_get_name
SUBROUTINE MPI_Type_get_name_f08(datatype,type_name,resultlen,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_MAX_OBJECT_NAME
   IMPLICIT NONE
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   CHARACTER(LEN=MPI_MAX_OBJECT_NAME), INTENT(OUT) :: type_name
   INTEGER, INTENT(OUT) :: resultlen
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_get_name_f08
END INTERFACE  MPI_Type_get_name

INTERFACE  MPI_Type_set_attr
SUBROUTINE MPI_Type_set_attr_f08(datatype,type_keyval,attribute_val,ierror &
           ) BIND(C,name="MPI_Type_set_attr_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, INTENT(IN) :: type_keyval
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: attribute_val
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_set_attr_f08
END INTERFACE  MPI_Type_set_attr

INTERFACE  MPI_Type_set_name
SUBROUTINE MPI_Type_set_name_f08(datatype,type_name,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   CHARACTER(LEN=*), INTENT(IN) :: type_name
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_set_name_f08
END INTERFACE  MPI_Type_set_name

INTERFACE  MPI_Win_create_keyval
SUBROUTINE MPI_Win_create_keyval_f08(win_copy_attr_fn,win_delete_attr_fn,win_keyval, &
                                     extra_state,ierror &
           ) BIND(C,name="MPI_Win_create_keyval_f08")
   USE :: mpi_f08_types, ONLY : MPI_ADDRESS_KIND
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_Win_copy_attr_function
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_Win_delete_attr_function
   IMPLICIT NONE
   PROCEDURE(MPI_Win_copy_attr_function) :: win_copy_attr_fn
   PROCEDURE(MPI_Win_delete_attr_function) :: win_delete_attr_fn
   INTEGER, INTENT(OUT) :: win_keyval
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: extra_state
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_create_keyval_f08
END INTERFACE  MPI_Win_create_keyval

INTERFACE  MPI_Win_delete_attr
SUBROUTINE MPI_Win_delete_attr_f08(win,win_keyval,ierror &
           ) BIND(C,name="MPI_Win_delete_attr_f08")
   USE :: mpi_f08_types, ONLY : MPI_Win
   IMPLICIT NONE
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, INTENT(IN) :: win_keyval
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_delete_attr_f08
END INTERFACE  MPI_Win_delete_attr

INTERFACE  MPI_Win_free_keyval
SUBROUTINE MPI_Win_free_keyval_f08(win_keyval,ierror &
           ) BIND(C,name="MPI_Win_free_keyval_f08")
   IMPLICIT NONE
   INTEGER, INTENT(INOUT) :: win_keyval
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_free_keyval_f08
END INTERFACE  MPI_Win_free_keyval

INTERFACE  MPI_Win_get_attr
SUBROUTINE MPI_Win_get_attr_f08(win,win_keyval,attribute_val,flag,ierror &
           ) BIND(C,name="MPI_Win_get_attr_f08")
   USE :: mpi_f08_types, ONLY : MPI_Win, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, INTENT(IN) :: win_keyval
   INTEGER(MPI_ADDRESS_KIND), INTENT(OUT) :: attribute_val
   LOGICAL, INTENT(OUT) :: flag
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_get_attr_f08
END INTERFACE  MPI_Win_get_attr

INTERFACE  MPI_Win_get_name
SUBROUTINE MPI_Win_get_name_f08(win,win_name,resultlen,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Win, MPI_MAX_OBJECT_NAME
   IMPLICIT NONE
   TYPE(MPI_Win), INTENT(IN) :: win
   CHARACTER(LEN=MPI_MAX_OBJECT_NAME), INTENT(OUT) :: win_name
   INTEGER, INTENT(OUT) :: resultlen
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_get_name_f08
END INTERFACE  MPI_Win_get_name

INTERFACE  MPI_Win_set_attr
SUBROUTINE MPI_Win_set_attr_f08(win,win_keyval,attribute_val,ierror &
           ) BIND(C,name="MPI_Win_set_attr_f08")
   USE :: mpi_f08_types, ONLY : MPI_Win, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, INTENT(IN) :: win_keyval
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: attribute_val
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_set_attr_f08
END INTERFACE  MPI_Win_set_attr

INTERFACE  MPI_Win_set_name
SUBROUTINE MPI_Win_set_name_f08(win,win_name,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Win
   IMPLICIT NONE
   TYPE(MPI_Win), INTENT(IN) :: win
   CHARACTER(LEN=*), INTENT(IN) :: win_name
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_set_name_f08
END INTERFACE  MPI_Win_set_name

INTERFACE  MPI_Cartdim_get
SUBROUTINE MPI_Cartdim_get_f08(comm,ndims,ierror &
           ) BIND(C,name="MPI_Cartdim_get_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(OUT) :: ndims
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Cartdim_get_f08
END INTERFACE  MPI_Cartdim_get

INTERFACE  MPI_Cart_coords
SUBROUTINE MPI_Cart_coords_f08(comm,rank,maxdims,coords,ierror &
           ) BIND(C,name="MPI_Cart_coords_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: rank, maxdims
   INTEGER, INTENT(OUT) :: coords(maxdims)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Cart_coords_f08
END INTERFACE  MPI_Cart_coords

INTERFACE  MPI_Cart_create
SUBROUTINE MPI_Cart_create_f08(comm_old,ndims,dims,periods,reorder,comm_cart,ierror &
           ) BIND(C,name="MPI_Cart_create_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm_old
   INTEGER, INTENT(IN) :: ndims, dims(ndims)
   LOGICAL, INTENT(IN) :: periods(ndims), reorder
   TYPE(MPI_Comm), INTENT(OUT) :: comm_cart
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Cart_create_f08
END INTERFACE  MPI_Cart_create

INTERFACE  MPI_Cart_get
SUBROUTINE MPI_Cart_get_f08(comm,maxdims,dims,periods,coords,ierror &
           ) BIND(C,name="MPI_Cart_get_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: maxdims
   INTEGER, INTENT(OUT) :: dims(maxdims), coords(maxdims)
   LOGICAL, INTENT(OUT) :: periods(maxdims)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Cart_get_f08
END INTERFACE  MPI_Cart_get

INTERFACE  MPI_Cart_map
SUBROUTINE MPI_Cart_map_f08(comm,ndims,dims,periods,newrank,ierror &
           ) BIND(C,name="MPI_Cart_map_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: ndims, dims(ndims)
   LOGICAL, INTENT(IN) :: periods(ndims)
   INTEGER, INTENT(OUT) :: newrank
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Cart_map_f08
END INTERFACE  MPI_Cart_map

INTERFACE  MPI_Cart_rank
SUBROUTINE MPI_Cart_rank_f08(comm,coords,rank,ierror &
           ) BIND(C,name="MPI_Cart_rank_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: coords(*)
   INTEGER, INTENT(OUT) :: rank
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Cart_rank_f08
END INTERFACE  MPI_Cart_rank

INTERFACE  MPI_Cart_shift
SUBROUTINE MPI_Cart_shift_f08(comm,direction,disp,rank_source,rank_dest,ierror &
           ) BIND(C,name="MPI_Cart_shift_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: direction, disp
   INTEGER, INTENT(OUT) :: rank_source, rank_dest
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Cart_shift_f08
END INTERFACE  MPI_Cart_shift

INTERFACE  MPI_Cart_sub
SUBROUTINE MPI_Cart_sub_f08(comm,remain_dims,newcomm,ierror &
           ) BIND(C,name="MPI_Cart_sub_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   LOGICAL, INTENT(IN) :: remain_dims(*)
   TYPE(MPI_Comm), INTENT(OUT) :: newcomm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Cart_sub_f08
END INTERFACE  MPI_Cart_sub

INTERFACE  MPI_Dims_create
SUBROUTINE MPI_Dims_create_f08(nnodes,ndims,dims,ierror &
           ) BIND(C,name="MPI_Dims_create_f08")
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: nnodes, ndims
   INTEGER, INTENT(INOUT) :: dims(ndims)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Dims_create_f08
END INTERFACE  MPI_Dims_create

INTERFACE  MPI_Dist_graph_create
SUBROUTINE MPI_Dist_graph_create_f08(comm_old,n,sources,degrees,destinations,weights, &
                                     info,reorder,comm_dist_graph,ierror &
           ) BIND(C,name="MPI_Dist_graph_create_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Info
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm_old
   INTEGER, INTENT(IN) :: n, sources(n), degrees(n), destinations(*), weights(*)
   TYPE(MPI_Info), INTENT(IN) :: info
   LOGICAL, INTENT(IN) :: reorder
   TYPE(MPI_Comm), INTENT(OUT) :: comm_dist_graph
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Dist_graph_create_f08
END INTERFACE  MPI_Dist_graph_create

INTERFACE  MPI_Dist_graph_create_adjacent
SUBROUTINE MPI_Dist_graph_create_adjacent_f08(comm_old,indegree,sources,sourceweights, &
                                              outdegree,destinations,destweights,info,reorder, &
                                              comm_dist_graph,ierror &
           ) BIND(C,name="MPI_Dist_graph_create_adjacent_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Info
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm_old
   INTEGER, INTENT(IN) :: indegree, sources(indegree), outdegree, destinations(outdegree)
   INTEGER, INTENT(IN) :: sourceweights(indegree), destweights(outdegree)
   TYPE(MPI_Info), INTENT(IN) :: info
   LOGICAL, INTENT(IN) :: reorder
   TYPE(MPI_Comm), INTENT(OUT) :: comm_dist_graph
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Dist_graph_create_adjacent_f08
END INTERFACE  MPI_Dist_graph_create_adjacent

INTERFACE  MPI_Dist_graph_neighbors
SUBROUTINE MPI_Dist_graph_neighbors_f08(comm,maxindegree,sources,sourceweights, &
                                        maxoutdegree,destinations,destweights,ierror &
           ) BIND(C,name="MPI_Dist_graph_neighbors_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: maxindegree, maxoutdegree
   INTEGER, INTENT(OUT) :: sources(maxindegree), destinations(maxoutdegree)
   INTEGER, INTENT(OUT) :: sourceweights(maxindegree), destweights(maxoutdegree)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Dist_graph_neighbors_f08
END INTERFACE  MPI_Dist_graph_neighbors

INTERFACE  MPI_Dist_graph_neighbors_count
SUBROUTINE MPI_Dist_graph_neighbors_count_f08(comm,indegree,outdegree,weighted,ierror &
           ) BIND(C,name="MPI_Dist_graph_neighbors_count_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(OUT) :: indegree, outdegree
   LOGICAL, INTENT(OUT) :: weighted
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Dist_graph_neighbors_count_f08
END INTERFACE  MPI_Dist_graph_neighbors_count

INTERFACE  MPI_Graphdims_get
SUBROUTINE MPI_Graphdims_get_f08(comm,nnodes,nedges,ierror &
           ) BIND(C,name="MPI_Graphdims_get_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(OUT) :: nnodes, nedges
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Graphdims_get_f08
END INTERFACE  MPI_Graphdims_get

INTERFACE  MPI_Graph_create
SUBROUTINE MPI_Graph_create_f08(comm_old,nnodes,index,edges,reorder,comm_graph, &
                                ierror &
           ) BIND(C,name="MPI_Graph_create_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm_old
   INTEGER, INTENT(IN) :: nnodes, index(nnodes), edges(*)
   LOGICAL, INTENT(IN) :: reorder
   TYPE(MPI_Comm), INTENT(OUT) :: comm_graph
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Graph_create_f08
END INTERFACE  MPI_Graph_create

INTERFACE  MPI_Graph_get
SUBROUTINE MPI_Graph_get_f08(comm,maxindex,maxedges,index,edges,ierror &
           ) BIND(C,name="MPI_Graph_get_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: maxindex, maxedges
   INTEGER, INTENT(OUT) :: index(maxindex), edges(maxedges)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Graph_get_f08
END INTERFACE  MPI_Graph_get

INTERFACE  MPI_Graph_map
SUBROUTINE MPI_Graph_map_f08(comm,nnodes,index,edges,newrank,ierror &
           ) BIND(C,name="MPI_Graph_map_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: nnodes, index(nnodes), edges(*)
   INTEGER, INTENT(OUT) :: newrank
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Graph_map_f08
END INTERFACE  MPI_Graph_map

INTERFACE  MPI_Graph_neighbors
SUBROUTINE MPI_Graph_neighbors_f08(comm,rank,maxneighbors,neighbors,ierror &
           ) BIND(C,name="MPI_Graph_neighbors_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: rank, maxneighbors
   INTEGER, INTENT(OUT) :: neighbors(maxneighbors)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Graph_neighbors_f08
END INTERFACE  MPI_Graph_neighbors

INTERFACE  MPI_Graph_neighbors_count
SUBROUTINE MPI_Graph_neighbors_count_f08(comm,rank,nneighbors,ierror &
           ) BIND(C,name="MPI_Graph_neighbors_count_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: rank
   INTEGER, INTENT(OUT) :: nneighbors
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Graph_neighbors_count_f08
END INTERFACE  MPI_Graph_neighbors_count

INTERFACE  MPI_Topo_test
SUBROUTINE MPI_Topo_test_f08(comm,status,ierror &
           ) BIND(C,name="MPI_Topo_test_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(OUT) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Topo_test_f08
END INTERFACE  MPI_Topo_test

! MPI_Wtick is not a wrapper function
!
INTERFACE MPI_Wtick
FUNCTION  MPI_Wtick_f08( ) BIND(C,name="MPI_Wtick")
   USE, INTRINSIC :: ISO_C_BINDING
   IMPLICIT NONE
   DOUBLE PRECISION :: MPI_Wtick_f08
END FUNCTION MPI_Wtick_f08
END INTERFACE MPI_Wtick

! MPI_Wtime is not a wrapper function
!
INTERFACE MPI_Wtime
FUNCTION  MPI_Wtime_f08( ) BIND(C,name="MPI_Wtime")
   USE, INTRINSIC :: ISO_C_BINDING
   IMPLICIT NONE
   DOUBLE PRECISION :: MPI_Wtime_f08
END FUNCTION MPI_Wtime_f08
END INTERFACE MPI_Wtime

INTERFACE  MPI_Abort
SUBROUTINE MPI_Abort_f08(comm,errorcode,ierror &
           ) BIND(C,name="MPI_Abort_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: errorcode
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Abort_f08
END INTERFACE  MPI_Abort

INTERFACE  MPI_Add_error_class
SUBROUTINE MPI_Add_error_class_f08(errorclass,ierror &
           ) BIND(C,name="MPI_Add_error_class_f08")
   IMPLICIT NONE
   INTEGER, INTENT(OUT) :: errorclass
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Add_error_class_f08
END INTERFACE  MPI_Add_error_class

INTERFACE  MPI_Add_error_code
SUBROUTINE MPI_Add_error_code_f08(errorclass,errorcode,ierror &
           ) BIND(C,name="MPI_Add_error_code_f08")
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: errorclass
   INTEGER, INTENT(OUT) :: errorcode
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Add_error_code_f08
END INTERFACE  MPI_Add_error_code

INTERFACE  MPI_Add_error_string
SUBROUTINE MPI_Add_error_string_f08(errorcode,string,ierror)
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: errorcode
   CHARACTER(LEN=*), INTENT(IN) :: string
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Add_error_string_f08
END INTERFACE  MPI_Add_error_string

INTERFACE  MPI_Alloc_mem
SUBROUTINE MPI_Alloc_mem_f08(size,info,baseptr,ierror &
           ) BIND(C,name="MPI_Alloc_mem_f08")
   USE, INTRINSIC :: ISO_C_BINDING, ONLY : C_PTR
   USE :: mpi_f08_types, ONLY : MPI_Info, MPI_ADDRESS_KIND
   IMPLICIT NONE
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: size
   TYPE(MPI_Info), INTENT(IN) :: info
   TYPE(C_PTR), INTENT(OUT) :: baseptr
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Alloc_mem_f08
END INTERFACE  MPI_Alloc_mem

INTERFACE  MPI_Comm_call_errhandler
SUBROUTINE MPI_Comm_call_errhandler_f08(comm,errorcode,ierror &
           ) BIND(C,name="MPI_Comm_call_errhandler_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: errorcode
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_call_errhandler_f08
END INTERFACE  MPI_Comm_call_errhandler

INTERFACE  MPI_Comm_create_errhandler
SUBROUTINE MPI_Comm_create_errhandler_f08(comm_errhandler_fn,errhandler,ierror &
           ) BIND(C,name="MPI_Comm_create_errhandler_f08")
   USE :: mpi_f08_types, ONLY : MPI_Errhandler
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_Comm_errhandler_function
   IMPLICIT NONE
   PROCEDURE(MPI_Comm_errhandler_function) :: comm_errhandler_fn
   TYPE(MPI_Errhandler), INTENT(OUT) :: errhandler
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_create_errhandler_f08
END INTERFACE  MPI_Comm_create_errhandler

INTERFACE  MPI_Comm_get_errhandler
SUBROUTINE MPI_Comm_get_errhandler_f08(comm,errhandler,ierror &
           ) BIND(C,name="MPI_Comm_get_errhandler_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Errhandler
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Errhandler), INTENT(OUT) :: errhandler
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_get_errhandler_f08
END INTERFACE  MPI_Comm_get_errhandler

INTERFACE  MPI_Comm_set_errhandler
SUBROUTINE MPI_Comm_set_errhandler_f08(comm,errhandler,ierror &
           ) BIND(C,name="MPI_Comm_set_errhandler_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Errhandler
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Errhandler), INTENT(IN) :: errhandler
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_set_errhandler_f08
END INTERFACE  MPI_Comm_set_errhandler

INTERFACE  MPI_Errhandler_free
SUBROUTINE MPI_Errhandler_free_f08(errhandler,ierror &
           ) BIND(C,name="MPI_Errhandler_free_f08")
   USE :: mpi_f08_types, ONLY : MPI_Errhandler
   IMPLICIT NONE
   TYPE(MPI_Errhandler), INTENT(INOUT) :: errhandler
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Errhandler_free_f08
END INTERFACE  MPI_Errhandler_free

INTERFACE  MPI_Error_class
SUBROUTINE MPI_Error_class_f08(errorcode,errorclass,ierror &
           ) BIND(C,name="MPI_Error_class_f08")
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: errorcode
   INTEGER, INTENT(OUT) :: errorclass
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Error_class_f08
END INTERFACE  MPI_Error_class

INTERFACE  MPI_Error_string
SUBROUTINE MPI_Error_string_f08(errorcode,string,resultlen,ierror)
   USE :: mpi_f08_types, ONLY : MPI_MAX_ERROR_STRING
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: errorcode
   CHARACTER(LEN=MPI_MAX_ERROR_STRING), INTENT(OUT) :: string
   INTEGER, INTENT(OUT) :: resultlen
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Error_string_f08
END INTERFACE  MPI_Error_string

!!!!#if OMPI_PROVIDE_MPI_FILE_INTERFACE

INTERFACE  MPI_File_call_errhandler
SUBROUTINE MPI_File_call_errhandler_f08(fh,errorcode,ierror &
           ) BIND(C,name="MPI_File_call_errhandler_f08")
   USE :: mpi_f08_types, ONLY : MPI_File
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER, INTENT(IN) :: errorcode
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_call_errhandler_f08
END INTERFACE  MPI_File_call_errhandler

INTERFACE  MPI_File_create_errhandler
SUBROUTINE MPI_File_create_errhandler_f08(file_errhandler_fn,errhandler,ierror &
           ) BIND(C,name="MPI_File_create_errhandler_f08")
   USE :: mpi_f08_types, ONLY : MPI_Errhandler
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_File_errhandler_function
   IMPLICIT NONE
   PROCEDURE(MPI_File_errhandler_function) :: file_errhandler_fn
   TYPE(MPI_Errhandler), INTENT(OUT) :: errhandler
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_create_errhandler_f08
END INTERFACE  MPI_File_create_errhandler

INTERFACE  MPI_File_get_errhandler
SUBROUTINE MPI_File_get_errhandler_f08(file,errhandler,ierror &
           ) BIND(C,name="MPI_File_get_errhandler_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Errhandler
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: file
   TYPE(MPI_Errhandler), INTENT(OUT) :: errhandler
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_get_errhandler_f08
END INTERFACE  MPI_File_get_errhandler

INTERFACE  MPI_File_set_errhandler
SUBROUTINE MPI_File_set_errhandler_f08(file,errhandler,ierror &
           ) BIND(C,name="MPI_File_set_errhandler_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Errhandler
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: file
   TYPE(MPI_Errhandler), INTENT(IN) :: errhandler
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_set_errhandler_f08
END INTERFACE  MPI_File_set_errhandler

! endif for OMPI_PROVIDE_MPI_FILE_INTERFACE
!!!!#endif

INTERFACE  MPI_Finalize
SUBROUTINE MPI_Finalize_f08(ierror &
           ) BIND(C,name="MPI_Finalize_f08")
   IMPLICIT NONE
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Finalize_f08
END INTERFACE  MPI_Finalize

INTERFACE  MPI_Finalized
SUBROUTINE MPI_Finalized_f08(flag,ierror &
           ) BIND(C,name="MPI_Finalized_f08")
   IMPLICIT NONE
   LOGICAL, INTENT(OUT) :: flag
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Finalized_f08
END INTERFACE  MPI_Finalized

! ASYNCHRONOUS had to removed from the base argument because
! the dummy argument is not an assumed-shape array.  This will
! be okay once the Interop TR is implemented.
!
INTERFACE  MPI_Free_mem
SUBROUTINE MPI_Free_mem_f08(base,ierror &
           ) BIND(C,name="MPI_Free_mem_f08")
   USE :: mpi_f08_types, ONLY : MPI_ADDRESS_KIND
   IMPLICIT NONE
!   INTEGER(MPI_ADDRESS_KIND), DIMENSION(*), ASYNCHRONOUS :: base
   INTEGER(MPI_ADDRESS_KIND), DIMENSION(*) :: base
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Free_mem_f08
END INTERFACE  MPI_Free_mem

INTERFACE  MPI_Get_processor_name
SUBROUTINE MPI_Get_processor_name_f08(name,resultlen,ierror)
   USE :: mpi_f08_types, ONLY : MPI_MAX_PROCESSOR_NAME
   IMPLICIT NONE
   CHARACTER(LEN=MPI_MAX_PROCESSOR_NAME), INTENT(OUT) :: name
   INTEGER, INTENT(OUT) :: resultlen
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Get_processor_name_f08
END INTERFACE  MPI_Get_processor_name

INTERFACE  MPI_Get_version
SUBROUTINE MPI_Get_version_f08(version,subversion,ierror &
           ) BIND(C,name="MPI_Get_version_f08")
   IMPLICIT NONE
   INTEGER, INTENT(OUT) :: version, subversion
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Get_version_f08
END INTERFACE  MPI_Get_version

INTERFACE  MPI_Init
SUBROUTINE MPI_Init_f08(ierror &
           ) BIND(C,name="MPI_Init_f08")
   IMPLICIT NONE
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Init_f08
END INTERFACE  MPI_Init

INTERFACE  MPI_Initialized
SUBROUTINE MPI_Initialized_f08(flag,ierror &
           ) BIND(C,name="MPI_Initialized_f08")
   IMPLICIT NONE
   LOGICAL, INTENT(OUT) :: flag
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Initialized_f08
END INTERFACE  MPI_Initialized

INTERFACE  MPI_Win_call_errhandler
SUBROUTINE MPI_Win_call_errhandler_f08(win,errorcode,ierror &
           ) BIND(C,name="MPI_Win_call_errhandler_f08")
   USE :: mpi_f08_types, ONLY : MPI_Win
   IMPLICIT NONE
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, INTENT(IN) :: errorcode
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_call_errhandler_f08
END INTERFACE  MPI_Win_call_errhandler

INTERFACE  MPI_Win_create_errhandler
SUBROUTINE MPI_Win_create_errhandler_f08(win_errhandler_fn,errhandler,ierror &
           ) BIND(C,name="MPI_Win_create_errhandler_f08")
   USE :: mpi_f08_types, ONLY : MPI_Errhandler
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_Win_errhandler_function
   IMPLICIT NONE
   PROCEDURE(MPI_Win_errhandler_function) :: win_errhandler_fn
   TYPE(MPI_Errhandler), INTENT(OUT) :: errhandler
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_create_errhandler_f08
END INTERFACE  MPI_Win_create_errhandler

INTERFACE  MPI_Win_get_errhandler
SUBROUTINE MPI_Win_get_errhandler_f08(win,errhandler,ierror &
           ) BIND(C,name="MPI_Win_get_errhandler_f08")
   USE :: mpi_f08_types, ONLY : MPI_Win, MPI_Errhandler
   IMPLICIT NONE
   TYPE(MPI_Win), INTENT(IN) :: win
   TYPE(MPI_Errhandler), INTENT(OUT) :: errhandler
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_get_errhandler_f08
END INTERFACE  MPI_Win_get_errhandler

INTERFACE  MPI_Win_set_errhandler
SUBROUTINE MPI_Win_set_errhandler_f08(win,errhandler,ierror &
           ) BIND(C,name="MPI_Win_set_errhandler_f08")
   USE :: mpi_f08_types, ONLY : MPI_Win, MPI_Errhandler
   IMPLICIT NONE
   TYPE(MPI_Win), INTENT(IN) :: win
   TYPE(MPI_Errhandler), INTENT(IN) :: errhandler
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_set_errhandler_f08
END INTERFACE  MPI_Win_set_errhandler

INTERFACE  MPI_Info_create
SUBROUTINE MPI_Info_create_f08(info,ierror &
           ) BIND(C,name="MPI_Info_create_f08")
   USE :: mpi_f08_types, ONLY : MPI_Info
   IMPLICIT NONE
   TYPE(MPI_Info), INTENT(OUT) :: info
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Info_create_f08
END INTERFACE  MPI_Info_create

INTERFACE  MPI_Info_delete
SUBROUTINE MPI_Info_delete_f08(info,key,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Info
   IMPLICIT NONE
   TYPE(MPI_Info), INTENT(IN) :: info
   CHARACTER(LEN=*), INTENT(IN) :: key
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Info_delete_f08
END INTERFACE  MPI_Info_delete

INTERFACE  MPI_Info_dup
SUBROUTINE MPI_Info_dup_f08(info,newinfo,ierror &
           ) BIND(C,name="MPI_Info_dup_f08")
   USE :: mpi_f08_types, ONLY : MPI_Info
   IMPLICIT NONE
   TYPE(MPI_Info), INTENT(IN) :: info
   TYPE(MPI_Info), INTENT(OUT) :: newinfo
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Info_dup_f08
END INTERFACE  MPI_Info_dup

INTERFACE  MPI_Info_free
SUBROUTINE MPI_Info_free_f08(info,ierror &
           ) BIND(C,name="MPI_Info_free_f08")
   USE :: mpi_f08_types, ONLY : MPI_Info
   IMPLICIT NONE
   TYPE(MPI_Info), INTENT(INOUT) :: info
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Info_free_f08
END INTERFACE  MPI_Info_free

INTERFACE  MPI_Info_get
SUBROUTINE MPI_Info_get_f08(info,key,valuelen,value,flag,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Info
   IMPLICIT NONE
   TYPE(MPI_Info), INTENT(IN) :: info
   CHARACTER(LEN=*), INTENT(IN) :: key
   INTEGER, INTENT(IN) :: valuelen
   CHARACTER(LEN=valuelen), INTENT(OUT) :: value
   LOGICAL, INTENT(OUT) :: flag
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Info_get_f08
END INTERFACE  MPI_Info_get

INTERFACE  MPI_Info_get_nkeys
SUBROUTINE MPI_Info_get_nkeys_f08(info,nkeys,ierror &
           ) BIND(C,name="MPI_Info_get_nkeys_f08")
   USE :: mpi_f08_types, ONLY : MPI_Info
   IMPLICIT NONE
   TYPE(MPI_Info), INTENT(IN) :: info
   INTEGER, INTENT(OUT) :: nkeys
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Info_get_nkeys_f08
END INTERFACE  MPI_Info_get_nkeys

INTERFACE  MPI_Info_get_nthkey
SUBROUTINE MPI_Info_get_nthkey_f08(info,n,key,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Info
   IMPLICIT NONE
   TYPE(MPI_Info), INTENT(IN) :: info
   INTEGER, INTENT(IN) :: n
   CHARACTER(lEN=*), INTENT(OUT) :: key
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Info_get_nthkey_f08
END INTERFACE  MPI_Info_get_nthkey

INTERFACE  MPI_Info_get_valuelen
SUBROUTINE MPI_Info_get_valuelen_f08(info,key,valuelen,flag,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Info
   IMPLICIT NONE
   TYPE(MPI_Info), INTENT(IN) :: info
   CHARACTER(LEN=*), INTENT(IN) :: key
   INTEGER, INTENT(OUT) :: valuelen
   LOGICAL, INTENT(OUT) :: flag
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Info_get_valuelen_f08
END INTERFACE  MPI_Info_get_valuelen

INTERFACE  MPI_Info_set
SUBROUTINE MPI_Info_set_f08(info,key,value,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Info
   IMPLICIT NONE
   TYPE(MPI_Info), INTENT(IN) :: info
   CHARACTER(LEN=*), INTENT(IN) :: key, value
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Info_set_f08
END INTERFACE  MPI_Info_set

INTERFACE  MPI_Close_port
SUBROUTINE MPI_Close_port_f08(port_name,ierror)
   IMPLICIT NONE
   CHARACTER(LEN=*), INTENT(IN) :: port_name
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Close_port_f08
END INTERFACE  MPI_Close_port

INTERFACE  MPI_Comm_accept
SUBROUTINE MPI_Comm_accept_f08(port_name,info,root,comm,newcomm,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Info, MPI_Comm
   IMPLICIT NONE
   CHARACTER(LEN=*), INTENT(IN) :: port_name
   TYPE(MPI_Info), INTENT(IN) :: info
   INTEGER, INTENT(IN) :: root
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Comm), INTENT(OUT) :: newcomm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_accept_f08
END INTERFACE  MPI_Comm_accept

INTERFACE  MPI_Comm_connect
SUBROUTINE MPI_Comm_connect_f08(port_name,info,root,comm,newcomm,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Info, MPI_Comm
   IMPLICIT NONE
   CHARACTER(LEN=*), INTENT(IN) :: port_name
   TYPE(MPI_Info), INTENT(IN) :: info
   INTEGER, INTENT(IN) :: root
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Comm), INTENT(OUT) :: newcomm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_connect_f08
END INTERFACE  MPI_Comm_connect

INTERFACE  MPI_Comm_disconnect
SUBROUTINE MPI_Comm_disconnect_f08(comm,ierror &
           ) BIND(C,name="MPI_Comm_disconnect_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(INOUT) :: comm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_disconnect_f08
END INTERFACE  MPI_Comm_disconnect

INTERFACE  MPI_Comm_get_parent
SUBROUTINE MPI_Comm_get_parent_f08(parent,ierror &
           ) BIND(C,name="MPI_Comm_get_parent_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(OUT) :: parent
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_get_parent_f08
END INTERFACE  MPI_Comm_get_parent

INTERFACE  MPI_Comm_join
SUBROUTINE MPI_Comm_join_f08(fd,intercomm,ierror &
           ) BIND(C,name="MPI_Comm_join_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: fd
   TYPE(MPI_Comm), INTENT(OUT) :: intercomm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_join_f08
END INTERFACE  MPI_Comm_join

INTERFACE  MPI_Comm_spawn
SUBROUTINE MPI_Comm_spawn_f08(command,argv,maxprocs,info,root,comm,intercomm, &
                              array_of_errcodes,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Info, MPI_Comm
   IMPLICIT NONE
   CHARACTER(LEN=*), INTENT(IN) :: command, argv(*)
   INTEGER, INTENT(IN) :: maxprocs, root
   TYPE(MPI_Info), INTENT(IN) :: info
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Comm), INTENT(OUT) :: intercomm
   INTEGER :: array_of_errcodes(*)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_spawn_f08
END INTERFACE  MPI_Comm_spawn

INTERFACE  MPI_Comm_spawn_multiple
SUBROUTINE MPI_Comm_spawn_multiple_f08(count,array_of_commands,array_of_argv,array_of_maxprocs, &
                                       array_of_info,root,comm,intercomm, &
                                       array_of_errcodes,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Info, MPI_Comm
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: count, array_of_maxprocs(*), root
   CHARACTER(LEN=*), INTENT(IN) :: array_of_commands(*), array_of_argv(count,*)
   TYPE(MPI_Info), INTENT(IN) :: array_of_info(*)
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Comm), INTENT(OUT) :: intercomm
   INTEGER :: array_of_errcodes(*)
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_spawn_multiple_f08
END INTERFACE  MPI_Comm_spawn_multiple

INTERFACE  MPI_Lookup_name
SUBROUTINE MPI_Lookup_name_f08(service_name,info,port_name,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Info, MPI_MAX_PORT_NAME
   IMPLICIT NONE
   CHARACTER(LEN=*), INTENT(IN) :: service_name
   TYPE(MPI_Info), INTENT(IN) :: info
   CHARACTER(LEN=MPI_MAX_PORT_NAME), INTENT(OUT) :: port_name
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Lookup_name_f08
END INTERFACE  MPI_Lookup_name

INTERFACE  MPI_Open_port
SUBROUTINE MPI_Open_port_f08(info,port_name,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Info, MPI_MAX_PORT_NAME
   IMPLICIT NONE
   TYPE(MPI_Info), INTENT(IN) :: info
   CHARACTER(LEN=MPI_MAX_PORT_NAME), INTENT(OUT) :: port_name
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Open_port_f08
END INTERFACE  MPI_Open_port

INTERFACE  MPI_Publish_name
SUBROUTINE MPI_Publish_name_f08(service_name,info,port_name,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Info
   IMPLICIT NONE
   TYPE(MPI_Info), INTENT(IN) :: info
   CHARACTER(LEN=*), INTENT(IN) :: service_name, port_name
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Publish_name_f08
END INTERFACE  MPI_Publish_name

INTERFACE  MPI_Unpublish_name
SUBROUTINE MPI_Unpublish_name_f08(service_name,info,port_name,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Info
   IMPLICIT NONE
   CHARACTER(LEN=*), INTENT(IN) :: service_name, port_name
   TYPE(MPI_Info), INTENT(IN) :: info
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Unpublish_name_f08
END INTERFACE  MPI_Unpublish_name

INTERFACE  MPI_Accumulate
SUBROUTINE MPI_Accumulate_f08(origin_addr,origin_count,origin_datatype,target_rank, &
                              target_disp,target_count,target_datatype,op,win,ierror &
           ) BIND(C,name="MPI_Accumulate_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Op, MPI_Win, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: origin_addr
   INTEGER, INTENT(IN) :: origin_count, target_rank, target_count
   TYPE(MPI_Datatype), INTENT(IN) :: origin_datatype
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: target_disp
   TYPE(MPI_Datatype), INTENT(IN) :: target_datatype
   TYPE(MPI_Op), INTENT(IN) :: op
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Accumulate_f08
END INTERFACE  MPI_Accumulate

INTERFACE  MPI_Get
SUBROUTINE MPI_Get_f08(origin_addr,origin_count,origin_datatype,target_rank, &
                               target_disp,target_count,target_datatype,win,ierror &
           ) BIND(C,name="MPI_Get_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Win, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: origin_addr
   INTEGER, INTENT(IN) :: origin_count, target_rank, target_count
   TYPE(MPI_Datatype), INTENT(IN) :: origin_datatype
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: target_disp
   TYPE(MPI_Datatype), INTENT(IN) :: target_datatype
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Get_f08
END INTERFACE  MPI_Get

INTERFACE  MPI_Put
SUBROUTINE MPI_Put_f08(origin_addr,origin_count,origin_datatype,target_rank, &
                               target_disp,target_count,target_datatype,win,ierror &
           ) BIND(C,name="MPI_Put_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Win, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: origin_addr
   INTEGER, INTENT(IN) :: origin_count, target_rank, target_count
   TYPE(MPI_Datatype), INTENT(IN) :: origin_datatype
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: target_disp
   TYPE(MPI_Datatype), INTENT(IN) :: target_datatype
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Put_f08
END INTERFACE  MPI_Put

INTERFACE  MPI_Win_complete
SUBROUTINE MPI_Win_complete_f08(win,ierror &
           ) BIND(C,name="MPI_Win_complete_f08")
   USE :: mpi_f08_types, ONLY : MPI_Info, MPI_Comm, MPI_Win, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_complete_f08
END INTERFACE  MPI_Win_complete

INTERFACE  MPI_Win_create
SUBROUTINE MPI_Win_create_f08(base,size,disp_unit,info,comm,win,ierror &
           ) BIND(C,name="MPI_Win_create_f08")
   USE :: mpi_f08_types, ONLY : MPI_Info, MPI_Comm, MPI_Win, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: base
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: size
   INTEGER, INTENT(IN) :: disp_unit
   TYPE(MPI_Info), INTENT(IN) :: info
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Win), INTENT(OUT) :: win
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_create_f08
END INTERFACE  MPI_Win_create

INTERFACE  MPI_Win_fence
SUBROUTINE MPI_Win_fence_f08(assert,win,ierror &
           ) BIND(C,name="MPI_Win_fence_f08")
   USE :: mpi_f08_types, ONLY : MPI_Win
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: assert
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_fence_f08
END INTERFACE  MPI_Win_fence

INTERFACE  MPI_Win_free
SUBROUTINE MPI_Win_free_f08(win,ierror &
           ) BIND(C,name="MPI_Win_free_f08")
   USE :: mpi_f08_types, ONLY : MPI_Win
   IMPLICIT NONE
   TYPE(MPI_Win), INTENT(INOUT) :: win
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_free_f08
END INTERFACE  MPI_Win_free

INTERFACE  MPI_Win_get_group
SUBROUTINE MPI_Win_get_group_f08(win,group,ierror &
           ) BIND(C,name="MPI_Win_get_group_f08")
   USE :: mpi_f08_types, ONLY : MPI_Win, MPI_Group
   IMPLICIT NONE
   TYPE(MPI_Win), INTENT(IN) :: win
   TYPE(MPI_Group), INTENT(OUT) :: group
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_get_group_f08
END INTERFACE  MPI_Win_get_group

INTERFACE  MPI_Win_lock
SUBROUTINE MPI_Win_lock_f08(lock_type,rank,assert,win,ierror &
           ) BIND(C,name="MPI_Win_lock_f08")
   USE :: mpi_f08_types, ONLY : MPI_Win
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: lock_type, rank, assert
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_lock_f08
END INTERFACE  MPI_Win_lock

INTERFACE  MPI_Win_post
SUBROUTINE MPI_Win_post_f08(group,assert,win,ierror &
           ) BIND(C,name="MPI_Win_post_f08")
   USE :: mpi_f08_types, ONLY : MPI_Group, MPI_Win
   IMPLICIT NONE
   TYPE(MPI_Group), INTENT(IN) :: group
   INTEGER, INTENT(IN) :: assert
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_post_f08
END INTERFACE  MPI_Win_post

INTERFACE  MPI_Win_start
SUBROUTINE MPI_Win_start_f08(group,assert,win,ierror &
           ) BIND(C,name="MPI_Win_start_f08")
   USE :: mpi_f08_types, ONLY : MPI_Group, MPI_Win
   IMPLICIT NONE
   TYPE(MPI_Group), INTENT(IN) :: group
   INTEGER, INTENT(IN) :: assert
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_start_f08
END INTERFACE  MPI_Win_start

INTERFACE  MPI_Win_test
SUBROUTINE MPI_Win_test_f08(win,flag,ierror &
           ) BIND(C,name="MPI_Win_test_f08")
   USE :: mpi_f08_types, ONLY : MPI_Win
   IMPLICIT NONE
   LOGICAL, INTENT(OUT) :: flag
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_test_f08
END INTERFACE  MPI_Win_test

INTERFACE  MPI_Win_unlock
SUBROUTINE MPI_Win_unlock_f08(rank,win,ierror &
           ) BIND(C,name="MPI_Win_unlock_f08")
   USE :: mpi_f08_types, ONLY : MPI_Win
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: rank
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_unlock_f08
END INTERFACE  MPI_Win_unlock

INTERFACE  MPI_Win_wait
SUBROUTINE MPI_Win_wait_f08(win,ierror &
           ) BIND(C,name="MPI_Win_wait_f08")
   USE :: mpi_f08_types, ONLY : MPI_Win
   IMPLICIT NONE
   TYPE(MPI_Win), INTENT(IN) :: win
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Win_wait_f08
END INTERFACE  MPI_Win_wait

INTERFACE  MPI_Grequest_complete
SUBROUTINE MPI_Grequest_complete_f08(request,ierror &
           ) BIND(C,name="MPI_Grequest_complete_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request
   IMPLICIT NONE
   TYPE(MPI_Request), INTENT(IN) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Grequest_complete_f08
END INTERFACE  MPI_Grequest_complete

INTERFACE  MPI_Grequest_start
SUBROUTINE MPI_Grequest_start_f08(query_fn,free_fn,cancel_fn,extra_state,request, &
                                  ierror &
           ) BIND(C,name="MPI_Grequest_start_f08")
   USE :: mpi_f08_types, ONLY : MPI_Request, MPI_ADDRESS_KIND
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_Grequest_query_function
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_Grequest_free_function
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_Grequest_cancel_function
   IMPLICIT NONE
   PROCEDURE(MPI_Grequest_query_function) :: query_fn
   PROCEDURE(MPI_Grequest_free_function) :: free_fn
   PROCEDURE(MPI_Grequest_cancel_function) :: cancel_fn
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: extra_state
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Grequest_start_f08
END INTERFACE  MPI_Grequest_start

INTERFACE  MPI_Init_thread
SUBROUTINE MPI_Init_thread_f08(required,provided,ierror &
           ) BIND(C,name="MPI_Init_thread_f08")
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: required
   INTEGER, INTENT(OUT) :: provided
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Init_thread_f08
END INTERFACE  MPI_Init_thread

INTERFACE  MPI_Is_thread_main
SUBROUTINE MPI_Is_thread_main_f08(flag,ierror &
           ) BIND(C,name="MPI_Is_thread_main_f08")
   IMPLICIT NONE
   LOGICAL, INTENT(OUT) :: flag
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Is_thread_main_f08
END INTERFACE  MPI_Is_thread_main

INTERFACE  MPI_Query_thread
SUBROUTINE MPI_Query_thread_f08(provided,ierror &
           ) BIND(C,name="MPI_Query_thread_f08")
   IMPLICIT NONE
   INTEGER, INTENT(OUT) :: provided
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Query_thread_f08
END INTERFACE  MPI_Query_thread

INTERFACE  MPI_Status_set_cancelled
SUBROUTINE MPI_Status_set_cancelled_f08(status,flag,ierror &
           ) BIND(C,name="MPI_Status_set_cancelled_f08")
   USE :: mpi_f08_types, ONLY : MPI_Status
   IMPLICIT NONE
   TYPE(MPI_Status), INTENT(INOUT) :: status
   LOGICAL, INTENT(OUT) :: flag
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Status_set_cancelled_f08
END INTERFACE  MPI_Status_set_cancelled

INTERFACE  MPI_Status_set_elements
SUBROUTINE MPI_Status_set_elements_f08(status,datatype,count,ierror &
           ) BIND(C,name="MPI_Status_set_elements_f08")
   USE :: mpi_f08_types, ONLY : MPI_Status, MPI_Datatype
   IMPLICIT NONE
   TYPE(MPI_Status), INTENT(INOUT) :: status
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, INTENT(IN) :: count
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Status_set_elements_f08
END INTERFACE  MPI_Status_set_elements

!!!!#if OMPI_PROVIDE_MPI_FILE_INTERFACE

INTERFACE  MPI_File_close
SUBROUTINE MPI_File_close_f08(fh,ierror &
           ) BIND(C,name="MPI_File_close_f08")
   USE :: mpi_f08_types, ONLY : MPI_File
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(INOUT) :: fh
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_close_f08
END INTERFACE  MPI_File_close

INTERFACE  MPI_File_delete
SUBROUTINE MPI_File_delete_f08(filename,info,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Info
   IMPLICIT NONE
   CHARACTER(LEN=*), INTENT(IN) :: filename
   TYPE(MPI_Info), INTENT(IN) :: info
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_delete_f08
END INTERFACE  MPI_File_delete

INTERFACE  MPI_File_get_amode
SUBROUTINE MPI_File_get_amode_f08(fh,amode,ierror &
           ) BIND(C,name="MPI_File_get_amode_f08")
   USE :: mpi_f08_types, ONLY : MPI_File
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER, INTENT(OUT) :: amode
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_get_amode_f08
END INTERFACE  MPI_File_get_amode

INTERFACE  MPI_File_get_atomicity
SUBROUTINE MPI_File_get_atomicity_f08(fh,flag,ierror &
           ) BIND(C,name="MPI_File_get_atomicity_f08")
   USE :: mpi_f08_types, ONLY : MPI_File
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   LOGICAL, INTENT(OUT) :: flag
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_get_atomicity_f08
END INTERFACE  MPI_File_get_atomicity

INTERFACE  MPI_File_get_byte_offset
SUBROUTINE MPI_File_get_byte_offset_f08(fh,offset,disp,ierror &
           ) BIND(C,name="MPI_File_get_byte_offset_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(IN) :: offset
   INTEGER(MPI_OFFSET_KIND), INTENT(OUT) :: disp
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_get_byte_offset_f08
END INTERFACE  MPI_File_get_byte_offset

INTERFACE  MPI_File_get_group
SUBROUTINE MPI_File_get_group_f08(fh,group,ierror &
           ) BIND(C,name="MPI_File_get_group_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Group
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(MPI_Group), INTENT(OUT) :: group
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_get_group_f08
END INTERFACE  MPI_File_get_group

INTERFACE  MPI_File_get_info
SUBROUTINE MPI_File_get_info_f08(fh,info_used,ierror &
           ) BIND(C,name="MPI_File_get_info_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Info
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(MPI_Info), INTENT(OUT) :: info_used
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_get_info_f08
END INTERFACE  MPI_File_get_info

INTERFACE  MPI_File_get_position
SUBROUTINE MPI_File_get_position_f08(fh,offset,ierror &
           ) BIND(C,name="MPI_File_get_position_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(OUT) :: offset
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_get_position_f08
END INTERFACE  MPI_File_get_position

INTERFACE  MPI_File_get_position_shared
SUBROUTINE MPI_File_get_position_shared_f08(fh,offset,ierror &
           ) BIND(C,name="MPI_File_get_position_shared_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(OUT) :: offset
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_get_position_shared_f08
END INTERFACE  MPI_File_get_position_shared

INTERFACE  MPI_File_get_size
SUBROUTINE MPI_File_get_size_f08(fh,size,ierror &
           ) BIND(C,name="MPI_File_get_size_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(OUT) :: size
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_get_size_f08
END INTERFACE  MPI_File_get_size

INTERFACE  MPI_File_get_type_extent
SUBROUTINE MPI_File_get_type_extent_f08(fh,datatype,extent,ierror &
           ) BIND(C,name="MPI_File_get_type_extent_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_ADDRESS_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER(MPI_ADDRESS_KIND), INTENT(OUT) :: extent
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_get_type_extent_f08
END INTERFACE  MPI_File_get_type_extent

INTERFACE  MPI_File_get_view
SUBROUTINE MPI_File_get_view_f08(fh,disp,etype,filetype,datarep,ierror)
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(OUT) :: disp
   TYPE(MPI_Datatype), INTENT(OUT) :: etype
   TYPE(MPI_Datatype), INTENT(OUT) :: filetype
   CHARACTER(LEN=*), INTENT(OUT) :: datarep
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_get_view_f08
END INTERFACE  MPI_File_get_view

INTERFACE  MPI_File_iread
SUBROUTINE MPI_File_iread_f08(fh,buf,count,datatype,request,ierror &
           ) BIND(C,name="MPI_File_iread_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Request
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_iread_f08
END INTERFACE  MPI_File_iread

INTERFACE  MPI_File_iread_at
SUBROUTINE MPI_File_iread_at_f08(fh,offset,buf,count,datatype,request,ierror &
           ) BIND(C,name="MPI_File_iread_at_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Request, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(IN) :: offset
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_iread_at_f08
END INTERFACE  MPI_File_iread_at

INTERFACE  MPI_File_iread_shared
SUBROUTINE MPI_File_iread_shared_f08(fh,buf,count,datatype,request,ierror &
           ) BIND(C,name="MPI_File_iread_shared_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Request
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_iread_shared_f08
END INTERFACE  MPI_File_iread_shared

INTERFACE  MPI_File_iwrite
SUBROUTINE MPI_File_iwrite_f08(fh,buf,count,datatype,request,ierror &
           ) BIND(C,name="MPI_File_iwrite_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Request
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_iwrite_f08
END INTERFACE  MPI_File_iwrite

INTERFACE  MPI_File_iwrite_at
SUBROUTINE MPI_File_iwrite_at_f08(fh,offset,buf,count,datatype,request,ierror &
           ) BIND(C,name="MPI_File_iwrite_at_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Request, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(IN) :: offset
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_iwrite_at_f08
END INTERFACE  MPI_File_iwrite_at

INTERFACE  MPI_File_iwrite_shared
SUBROUTINE MPI_File_iwrite_shared_f08(fh,buf,count,datatype,request,ierror &
           ) BIND(C,name="MPI_File_iwrite_shared_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: buf
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_iwrite_shared_f08
END INTERFACE  MPI_File_iwrite_shared

INTERFACE  MPI_File_open
SUBROUTINE MPI_File_open_f08(comm,filename,amode,info,fh,ierror)
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Info, MPI_File
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   CHARACTER(LEN=*), INTENT(IN) :: filename
   INTEGER, INTENT(IN) :: amode
   TYPE(MPI_Info), INTENT(IN) :: info
   TYPE(MPI_File), INTENT(OUT) :: fh
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_open_f08
END INTERFACE  MPI_File_open

INTERFACE  MPI_File_preallocate
SUBROUTINE MPI_File_preallocate_f08(fh,size,ierror &
           ) BIND(C,name="MPI_File_preallocate_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(IN) :: size
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_preallocate_f08
END INTERFACE  MPI_File_preallocate

INTERFACE  MPI_File_read
SUBROUTINE MPI_File_read_f08(fh,buf,count,datatype,status,ierror &
           ) BIND(C,name="MPI_File_read_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_read_f08
END INTERFACE  MPI_File_read

INTERFACE  MPI_File_read_all
SUBROUTINE MPI_File_read_all_f08(fh,buf,count,datatype,status,ierror &
           ) BIND(C,name="MPI_File_read_all_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_read_all_f08
END INTERFACE  MPI_File_read_all

INTERFACE  MPI_File_read_all_begin
SUBROUTINE MPI_File_read_all_begin_f08(fh,buf,count,datatype,ierror &
           ) BIND(C,name="MPI_File_read_all_begin_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_read_all_begin_f08
END INTERFACE  MPI_File_read_all_begin

INTERFACE  MPI_File_read_all_end
SUBROUTINE MPI_File_read_all_end_f08(fh,buf,status,ierror &
           ) BIND(C,name="MPI_File_read_all_end_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_read_all_end_f08
END INTERFACE  MPI_File_read_all_end

INTERFACE  MPI_File_read_at
SUBROUTINE MPI_File_read_at_f08(fh,offset,buf,count,datatype,status,ierror &
           ) BIND(C,name="MPI_File_read_at_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Status, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(IN) :: offset
   TYPE(*), DIMENSION(..) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_read_at_f08
END INTERFACE  MPI_File_read_at

INTERFACE  MPI_File_read_at_all
SUBROUTINE MPI_File_read_at_all_f08(fh,offset,buf,count,datatype,status,ierror &
           ) BIND(C,name="MPI_File_read_at_all_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Status, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(IN) :: offset
   TYPE(*), DIMENSION(..) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_read_at_all_f08
END INTERFACE  MPI_File_read_at_all

INTERFACE  MPI_File_read_at_all_begin
SUBROUTINE MPI_File_read_at_all_begin_f08(fh,offset,buf,count,datatype,ierror &
           ) BIND(C,name="MPI_File_read_at_all_begin_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(IN) :: offset
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_read_at_all_begin_f08
END INTERFACE  MPI_File_read_at_all_begin

INTERFACE  MPI_File_read_at_all_end
SUBROUTINE MPI_File_read_at_all_end_f08(fh,buf,status,ierror &
           ) BIND(C,name="MPI_File_read_at_all_end_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_read_at_all_end_f08
END INTERFACE  MPI_File_read_at_all_end

INTERFACE  MPI_File_read_ordered
SUBROUTINE MPI_File_read_ordered_f08(fh,buf,count,datatype,status,ierror &
           ) BIND(C,name="MPI_File_read_ordered_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_read_ordered_f08
END INTERFACE  MPI_File_read_ordered

INTERFACE  MPI_File_read_ordered_begin
SUBROUTINE MPI_File_read_ordered_begin_f08(fh,buf,count,datatype,ierror &
           ) BIND(C,name="MPI_File_read_ordered_begin_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_read_ordered_begin_f08
END INTERFACE  MPI_File_read_ordered_begin

INTERFACE  MPI_File_read_ordered_end
SUBROUTINE MPI_File_read_ordered_end_f08(fh,buf,status,ierror &
           ) BIND(C,name="MPI_File_read_ordered_end_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_read_ordered_end_f08
END INTERFACE  MPI_File_read_ordered_end

INTERFACE  MPI_File_read_shared
SUBROUTINE MPI_File_read_shared_f08(fh,buf,count,datatype,status,ierror &
           ) BIND(C,name="MPI_File_read_shared_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_read_shared_f08
END INTERFACE  MPI_File_read_shared

INTERFACE  MPI_File_seek
SUBROUTINE MPI_File_seek_f08(fh,offset,whence,ierror &
           ) BIND(C,name="MPI_File_seek_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(IN) :: offset
   INTEGER, INTENT(IN) :: whence
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_seek_f08
END INTERFACE  MPI_File_seek

INTERFACE  MPI_File_seek_shared
SUBROUTINE MPI_File_seek_shared_f08(fh,offset,whence,ierror &
           ) BIND(C,name="MPI_File_seek_shared_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(IN) :: offset
   INTEGER, INTENT(IN) :: whence
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_seek_shared_f08
END INTERFACE  MPI_File_seek_shared

INTERFACE  MPI_File_set_atomicity
SUBROUTINE MPI_File_set_atomicity_f08(fh,flag,ierror &
           ) BIND(C,name="MPI_File_set_atomicity_f08")
   USE :: mpi_f08_types, ONLY : MPI_File
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   LOGICAL, INTENT(IN) :: flag
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_set_atomicity_f08
END INTERFACE  MPI_File_set_atomicity

INTERFACE  MPI_File_set_info
SUBROUTINE MPI_File_set_info_f08(fh,info,ierror &
           ) BIND(C,name="MPI_File_set_info_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Info
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(MPI_Info), INTENT(IN) :: info
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_set_info_f08
END INTERFACE  MPI_File_set_info

INTERFACE  MPI_File_set_size
SUBROUTINE MPI_File_set_size_f08(fh,size,ierror &
           ) BIND(C,name="MPI_File_set_size_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(IN) :: size
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_set_size_f08
END INTERFACE  MPI_File_set_size

INTERFACE  MPI_File_set_view
SUBROUTINE MPI_File_set_view_f08(fh,disp,etype,filetype,datarep,info,ierror)
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Info, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(IN) :: disp
   TYPE(MPI_Datatype), INTENT(IN) :: etype
   TYPE(MPI_Datatype), INTENT(IN) :: filetype
   CHARACTER(LEN=*), INTENT(IN) :: datarep
   TYPE(MPI_Info), INTENT(IN) :: info
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_set_view_f08
END INTERFACE  MPI_File_set_view

INTERFACE  MPI_File_sync
SUBROUTINE MPI_File_sync_f08(fh,ierror &
           ) BIND(C,name="MPI_File_sync_f08")
   USE :: mpi_f08_types, ONLY : MPI_File
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_sync_f08
END INTERFACE  MPI_File_sync

INTERFACE  MPI_File_write
SUBROUTINE MPI_File_write_f08(fh,buf,count,datatype,status,ierror &
           ) BIND(C,name="MPI_File_write_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_write_f08
END INTERFACE  MPI_File_write

INTERFACE  MPI_File_write_all
SUBROUTINE MPI_File_write_all_f08(fh,buf,count,datatype,status,ierror &
           ) BIND(C,name="MPI_File_write_all_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_write_all_f08
END INTERFACE  MPI_File_write_all

INTERFACE  MPI_File_write_all_begin
SUBROUTINE MPI_File_write_all_begin_f08(fh,buf,count,datatype,ierror &
           ) BIND(C,name="MPI_File_write_all_begin_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_write_all_begin_f08
END INTERFACE  MPI_File_write_all_begin

INTERFACE  MPI_File_write_all_end
SUBROUTINE MPI_File_write_all_end_f08(fh,buf,status,ierror &
           ) BIND(C,name="MPI_File_write_all_end_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: buf
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_write_all_end_f08
END INTERFACE  MPI_File_write_all_end

INTERFACE  MPI_File_write_at
SUBROUTINE MPI_File_write_at_f08(fh,offset,buf,count,datatype,status,ierror &
           ) BIND(C,name="MPI_File_write_at_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Status, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(IN) :: offset
   TYPE(*), DIMENSION(..), INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_write_at_f08
END INTERFACE  MPI_File_write_at

INTERFACE  MPI_File_write_at_all
SUBROUTINE MPI_File_write_at_all_f08(fh,offset,buf,count,datatype,status,ierror &
           ) BIND(C,name="MPI_File_write_at_all_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Status, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(IN) :: offset
   TYPE(*), DIMENSION(..) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_write_at_all_f08
END INTERFACE  MPI_File_write_at_all

INTERFACE  MPI_File_write_at_all_begin
SUBROUTINE MPI_File_write_at_all_begin_f08(fh,offset,buf,count,datatype,ierror &
           ) BIND(C,name="MPI_File_write_at_all_begin_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_OFFSET_KIND
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   INTEGER(MPI_OFFSET_KIND), INTENT(IN) :: offset
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_write_at_all_begin_f08
END INTERFACE  MPI_File_write_at_all_begin

INTERFACE  MPI_File_write_at_all_end
SUBROUTINE MPI_File_write_at_all_end_f08(fh,buf,status,ierror &
           ) BIND(C,name="MPI_File_write_at_all_end_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: buf
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_write_at_all_end_f08
END INTERFACE  MPI_File_write_at_all_end

INTERFACE  MPI_File_write_ordered
SUBROUTINE MPI_File_write_ordered_f08(fh,buf,count,datatype,status,ierror &
           ) BIND(C,name="MPI_File_write_ordered_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_write_ordered_f08
END INTERFACE  MPI_File_write_ordered

INTERFACE  MPI_File_write_ordered_begin
SUBROUTINE MPI_File_write_ordered_begin_f08(fh,buf,count,datatype,ierror &
           ) BIND(C,name="MPI_File_write_ordered_begin_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_write_ordered_begin_f08
END INTERFACE  MPI_File_write_ordered_begin

INTERFACE  MPI_File_write_ordered_end
SUBROUTINE MPI_File_write_ordered_end_f08(fh,buf,status,ierror &
           ) BIND(C,name="MPI_File_write_ordered_end_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), ASYNCHRONOUS, INTENT(IN) :: buf
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_write_ordered_end_f08
END INTERFACE  MPI_File_write_ordered_end

INTERFACE  MPI_File_write_shared
SUBROUTINE MPI_File_write_shared_f08(fh,buf,count,datatype,status,ierror &
           ) BIND(C,name="MPI_File_write_shared_f08")
   USE :: mpi_f08_types, ONLY : MPI_File, MPI_Datatype, MPI_Status
   IMPLICIT NONE
   TYPE(MPI_File), INTENT(IN) :: fh
   TYPE(*), DIMENSION(..), INTENT(IN) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_File_write_shared_f08
END INTERFACE  MPI_File_write_shared

! endif for OMPI_PROVIDE_MPI_FILE_INTERFACE
!!!!#endif

INTERFACE  MPI_Register_datarep
SUBROUTINE MPI_Register_datarep_f08(datarep,read_conversion_fn,write_conversion_fn, &
                                            dtype_file_extent_fn,extra_state,ierror)
   USE :: mpi_f08_types, ONLY : MPI_ADDRESS_KIND
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_Datarep_conversion_function
   USE :: mpi_f08_INTERFACEs_callbacks, ONLY : MPI_Datarep_extent_function
   IMPLICIT NONE
   CHARACTER(LEN=*), INTENT(IN) :: datarep
   PROCEDURE(MPI_Datarep_conversion_function) :: read_conversion_fn
   PROCEDURE(MPI_Datarep_conversion_function) :: write_conversion_fn
   PROCEDURE(MPI_Datarep_extent_function) :: dtype_file_extent_fn
   INTEGER(MPI_ADDRESS_KIND), INTENT(IN) :: extra_state
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Register_datarep_f08
END INTERFACE  MPI_Register_datarep

!
! MPI_Sizeof is generic for numeric types.  This ignore TKR INTERFACE
! is replaced by the specific generics.  Implemented in mpi_sizeof_mod.F90.
!
!SUBROUTINE MPI_Sizeof(x,size,ierror &
!           ) BIND(C,name="MPI_Sizeof_f08")
!   USE :: mpi_f08_types
!   IMPLICIT NONE
!   TYPE(*), DIMENSION(..), INTENT(IN) :: x
!   INTEGER, INTENT(OUT) :: size
!   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
!END SUBROUTINE MPI_Sizeof

INTERFACE  MPI_Type_create_f90_complex
SUBROUTINE MPI_Type_create_f90_complex_f08(p,r,newtype,ierror &
           ) BIND(C,name="MPI_Type_create_f90_complex_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: p, r
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_create_f90_complex_f08
END INTERFACE  MPI_Type_create_f90_complex

INTERFACE  MPI_Type_create_f90_integer
SUBROUTINE MPI_Type_create_f90_integer_f08(r,newtype,ierror &
           ) BIND(C,name="MPI_Type_create_f90_integer_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: r
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_create_f90_integer_f08
END INTERFACE  MPI_Type_create_f90_integer

INTERFACE  MPI_Type_create_f90_real
SUBROUTINE MPI_Type_create_f90_real_f08(p,r,newtype,ierror &
           ) BIND(C,name="MPI_Type_create_f90_real_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: p, r
   TYPE(MPI_Datatype), INTENT(OUT) :: newtype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_create_f90_real_f08
END INTERFACE  MPI_Type_create_f90_real

INTERFACE  MPI_Type_match_size
SUBROUTINE MPI_Type_match_size_f08(typeclass,size,datatype,ierror &
           ) BIND(C,name="MPI_Type_match_size_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: typeclass, size
   TYPE(MPI_Datatype), INTENT(OUT) :: datatype
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Type_match_size_f08
END INTERFACE  MPI_Type_match_size

INTERFACE  MPI_Pcontrol
SUBROUTINE MPI_Pcontrol_f08(level &
           ) BIND(C,name="MPI_Pcontrol_f08")
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: level
END SUBROUTINE MPI_Pcontrol_f08
END INTERFACE  MPI_Pcontrol


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! New routines to MPI-3
!

INTERFACE  MPI_Comm_split_type
SUBROUTINE MPI_Comm_split_type_f08(comm,split_type,key,info,newcomm,ierror &
           ) BIND(C,name="MPI_Comm_split_type_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Info
   IMPLICIT NONE
   TYPE(MPI_Comm), INTENT(IN) :: comm
   INTEGER, INTENT(IN) :: split_type
   INTEGER, INTENT(IN) :: key
   TYPE(MPI_Info), INTENT(IN) :: info
   TYPE(MPI_Comm), INTENT(OUT) :: newcomm
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Comm_split_type_f08
END INTERFACE  MPI_Comm_split_type

INTERFACE  MPI_F_sync_reg
SUBROUTINE MPI_F_sync_reg_f08(buf &
           ) BIND(C,name="MPI_F_sync_reg_f08")
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
END SUBROUTINE MPI_F_sync_reg_f08
END INTERFACE  MPI_F_sync_reg

INTERFACE  MPI_Get_library_version
SUBROUTINE MPI_Get_library_version_f08(name,resultlen,ierror)
   USE :: mpi_f08_types, ONLY : MPI_MAX_PROCESSOR_NAME
   IMPLICIT NONE
   CHARACTER(LEN=MPI_MAX_PROCESSOR_NAME), INTENT(OUT) :: name
   INTEGER, INTENT(OUT) :: resultlen
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Get_library_version_f08
END INTERFACE  MPI_Get_library_version

INTERFACE  MPI_Mprobe
SUBROUTINE MPI_Mprobe_f08(source,tag,comm,message,status,ierror &
           ) BIND(C,name="MPI_Mprobe_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Message, MPI_Status
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: source, tag
   TYPE(MPI_Comm), INTENT(IN) :: comm
   TYPE(MPI_Message), INTENT(OUT) :: message
   TYPE(MPI_Status), INTENT(OUT) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Mprobe_f08
END INTERFACE  MPI_Mprobe

INTERFACE  MPI_Improbe
SUBROUTINE MPI_Improbe_f08(source,tag,comm,flag,message,status,ierror &
           ) BIND(C,name="MPI_Improbe_f08")
   USE :: mpi_f08_types, ONLY : MPI_Comm, MPI_Message, MPI_Status
   IMPLICIT NONE
   INTEGER, INTENT(IN) :: source, tag
   TYPE(MPI_Comm), INTENT(IN) :: comm
   LOGICAL, INTENT(OUT) :: flag
   TYPE(MPI_Message), INTENT(OUT) :: message
   TYPE(MPI_Status), INTENT(OUT) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Improbe_f08
END INTERFACE  MPI_Improbe

INTERFACE  MPI_Imrecv
SUBROUTINE MPI_Imrecv_f08(buf,count,datatype,message,request,ierror &
           ) BIND(C,name="MPI_Imrecv_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Message, MPI_Request
   IMPLICIT NONE
   TYPE(*), DIMENSION(..), ASYNCHRONOUS :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Message), INTENT(INOUT) :: message
   TYPE(MPI_Request), INTENT(OUT) :: request
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Imrecv_f08
END INTERFACE  MPI_Imrecv

INTERFACE  MPI_Mrecv
SUBROUTINE MPI_Mrecv_f08(buf,count,datatype,message,status,ierror &
           ) BIND(C,name="MPI_Mrecv_f08")
   USE :: mpi_f08_types, ONLY : MPI_Datatype, MPI_Message, MPI_Status
   IMPLICIT NONE
   TYPE(*), DIMENSION(..) :: buf
   INTEGER, INTENT(IN) :: count
   TYPE(MPI_Datatype), INTENT(IN) :: datatype
   TYPE(MPI_Message), INTENT(INOUT) :: message
   TYPE(MPI_Status) :: status
   INTEGER, OPTIONAL, INTENT(OUT) :: ierror
END SUBROUTINE MPI_Mrecv_f08
END INTERFACE  MPI_Mrecv

END MODULE mpi_f08_interfaces
