program Advent3
implicit none

integer, dimension(-500:500, -500:500) :: array
integer :: dir_x = 0, dir_y = 1, x = 1, y = 0
integer :: temp_sum, i = 1
array(0,0) = 1
array(1,0) = 1

do
    x = x + (dir_x * 1)
    y = y + (dir_y * 1)

    temp_sum = array(x,y-1) + array(x-1,y-1) + array(x-1,y) + array(x-1,y+1)
    temp_sum = temp_sum + array(x,y+1) + array(x+1,y+1) + array(x+1,y)
    temp_sum = temp_sum + array(x+1,y-1)
    
    if (temp_sum .gt. 289326) then
        print*,temp_sum
        EXIT
    end if

    array(x,y) = temp_sum

    if ((x .eq. y) .and. (x .gt. 0)) then
        dir_x = -1
        dir_y = 0
    else if ((y .lt. 0) .and. ((y * (-1) + 1) .eq. x)) then
        dir_x = 0
        dir_y = 1
    else if (x .eq. y) then
        dir_x = 1
        dir_y = 0
    else if ((x .lt. 0) .and. (y * (-1) .eq. x)) then
        dir_x = 0
        dir_y = -1
    end if

    i = i + 1
end do

end program Advent3