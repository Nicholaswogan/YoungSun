      module sunflux
        implicit none

        character(len=500) :: fileloc

      contains
        include "Youngsun.f90"
        include "inter1.f90"
        include "Spline.f90"


        subroutine solarflux(timega,x3,y3)
          real*8, intent(in) :: timega
          integer,parameter :: n = 26150
          real*8, dimension(n), intent(out) :: x3
          real*8, dimension(n), intent(out) :: y3


          integer nhead, i , l, kin
          real*8, dimension(n) :: x1,y1,x2,y2

          nhead = 0

          OPEN(UNIT=kin,file=trim(fileloc)//'data/composite.atl1_1', &
                          STATUS='old')
          DO i = 1, nhead
            READ(kin,*)
          ENDDO
          DO i = 1, n
            READ(kin,*) x1(i), y1(i)  !this flux in mw/m2/nm, but is sampled at subangstom resolution
            x1(i)=x1(i)*10e0   !convert wavelength from nm to Angstoms
            x2(i)=x1(i)      ! x2 also angstroms
            x3(i)=x1(i)/10e0    ! x3 also nm
            y3(i)=y1(i)/10e0   ! for y3, convert thuillier flux to mw/m2/A
          ENDDO
          CLOSE (kin)

          CALL youngsun(n,timega,x1,y2)

          do L=1,n
            y3(L)=y3(L)*y2(L)*10e0  !add in youngsun correction convert back to mw/m2/nm
          enddo
        end subroutine

      end module
