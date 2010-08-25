 function nf90_def_dim(ncid, name, len, dimid)
   integer,             intent( in) :: ncid
   character (len = *), intent( in) :: name
   integer,             intent( in) :: len
   integer,             intent(out) :: dimid
   integer                          :: nf90_def_dim

   nf90_def_dim = nf_def_dim(ncid, name, len, dimid)
 end function nf90_def_dim
