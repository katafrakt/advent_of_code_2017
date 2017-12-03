program Advent3
implicit none

integer, parameter :: number = 289326
integer :: i, rounded_root, current_value = 0, current_max = 2, current_min = 1
integer :: direction = 1
logical :: one_after_root = .false.
real :: root

do i = 2, number, 1
    root = sqrt(real(i))
    rounded_root = int(root)
    current_value = current_value + (1 * direction)

    if (one_after_root) then
        one_after_root = .false.
        direction = -1
    end if

    if ((root .eq. rounded_root) .and. (modulo(rounded_root, 2) .eq. 1)) then
        current_max = current_value + 2
        current_min = (rounded_root + 1)/2 ! idk lol
        one_after_root = .true.
        direction = 1
    else if ((direction .eq. 1) .and. (current_value .eq. current_max)) then
        direction = -1
    else if ((direction .eq. -1) .and. (current_value .eq. current_min)) then
        direction = 1
    end if
end do
print*,current_value

end program Advent3