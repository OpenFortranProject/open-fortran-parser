module netcdf

 implicit none
 private

 ! Dimension routines
 public :: nf90_def_dim

 ! Dimension routines   nf_inq_dim
 integer,              external :: nf_def_dim

contains

!
! The following include file is not handled properly in the lexical prepass.
! The len parameter to nf90_def_dim is not converted to a identifier.
!
 include "bug-3053141_inc.f90"

!
! A copy of the included file for reference
!
! function nf90_def_dim(ncid, name, len, dimid)
!   integer,             intent( in) :: ncid
!   character (len = *), intent( in) :: name
!   integer,             intent( in) :: len
!   integer,             intent(out) :: dimid
!   integer                          :: nf90_def_dim
!
!   nf90_def_dim = nf_def_dim(ncid, name, len, dimid)
! end function nf90_def_dim
!

end module netcdf
