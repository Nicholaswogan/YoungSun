module sunflux
  implicit none

contains
  include "Youngsun.f90"
  include "inter1.f90"
  include "Spline.f90"

  subroutine youngsun_c(n, timega, grid, rootdir_c, fluxmult) bind(c)
    use iso_c_binding
    integer(c_int), value, intent(in) :: n
    real(c_double), value, intent(in) :: timega
    real(c_double), intent(in) :: grid(n)
    character(kind=c_char), intent(in) :: rootdir_c(*)
    real(c_double), intent(out) :: fluxmult(n)

    character(:), allocatable :: rootdir

    allocate(character(len=len_cstring(rootdir_c))::rootdir)
    call copy_string_ctof(rootdir_c, rootdir)

    call youngsun(n, timega, grid, rootdir, fluxmult)

  end subroutine

  subroutine solarflux(timega, rootdir_c, x3, y3) bind(c)
    use iso_c_binding, only: c_double, c_char
    real(c_double), value, intent(in) :: timega
    character(kind=c_char), intent(in) :: rootdir_c(*)
    integer, parameter :: n = 26650
    real(c_double), intent(out) :: x3(n)
    real(c_double), intent(out) :: y3(n)

    integer i , l, kin
    real*8, dimension(n) :: x1,y1,x2,y2
    character(:), allocatable :: rootdir

    allocate(character(len=len_cstring(rootdir_c))::rootdir)
    call copy_string_ctof(rootdir_c, rootdir)

    open(unit=2,file=trim(rootdir)//'data/composite.atl1_1_BB_append', status='old')
    do i = 1, n
      read(2,*) x1(i), y1(i)  !this flux in mw/m2/nm, but is sampled at subangstom resolution
      x1(i)=x1(i)*10e0   !convert wavelength from nm to Angstoms
      x2(i)=x1(i)      ! x2 also angstroms
      x3(i)=x1(i)/10e0    ! x3 also nm
      y3(i)=y1(i)/10e0   ! for y3, convert thuillier flux to mw/m2/A
    enddo
    close(2)

    call youngsun(n, timega, x1, rootdir, y2)

    do L=1,n
    y3(L)=y3(L)*y2(L)*10e0  !add in youngsun correction convert back to mw/m2/nm
    enddo
  end subroutine

  function len_cstring(stringc) result (length)
    use iso_c_binding
    ! DOES NOT include the null character terminating c string
    character(kind=c_char), intent(in) :: stringc(*)
    integer(c_int) :: length
    integer, parameter :: max_len = 10000
    integer :: j  
    j = 1
    do
      if (stringc(j)==c_null_char) then
        length = j - 1
        exit
      endif
      if (j == max_len) then
        print*,"'len_cstring' tried to determine the length of an invalid C string"
        stop 1
      endif
      j = j + 1
    end do
  end function
  
  subroutine copy_string_ctof(stringc,stringf)
    use iso_c_binding
    ! utility function to convert c string to fortran string
    character(len=*), intent(out) :: stringf
    character(c_char), intent(in) :: stringc(*)
    integer j
    stringf = ''
    char_loop: do j=1,len(stringf)
       if (stringc(j)==c_null_char) exit char_loop
       stringf(j:j) = stringc(j)
    end do char_loop
  end subroutine copy_string_ctof

end module
