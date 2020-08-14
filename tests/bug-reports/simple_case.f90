program test_case
    INTEGER :: x
    SELECT CASE (x)
        case (0)
        case (1:3)
        case (4,7)
    END SELECT
end program
