package main

import "core:fmt"
import "core:os"
import "core:strconv"

main :: proc() {
    if len(os.args) != 3 {
        fmt.printfln("usage: %s row col", os.args[0])
        return
    }

    row, col: int
    ok: bool

    if row, ok = strconv.parse_int(os.args[1]); !ok {
        fmt.printfln("Invalid row: %s", os.args[1])
        return
    }

    if col, ok = strconv.parse_int(os.args[2]); !ok {
        fmt.printfln("Invalid column: %s", os.args[2])
        return
    }

    if row < 1 {
        fmt.printfln("Row cannot be less than 1")
        return
    }

    if col < 1 {
        fmt.println("Column cannot be less than 1")
        return
    }

    if col > row {
        fmt.println("Column cannot be greater than row")
        return
    }

    fmt.println(pascal_at(row, col))
}

pascal_at :: proc(row, col: int) -> int {
    switch {
        case col == 1 || col == row:
            return 1
        case:
            return pascal_at(row-1, col-1) + pascal_at(row-1, col)
    }
}

//1
//1 1
//1 2 1
//1 3 3 1
//1 4 6 4 1