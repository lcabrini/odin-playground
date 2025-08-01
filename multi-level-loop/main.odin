package main

import "core:fmt"

main :: proc() {
    // A simple way to do a multi-level loop.
    for row in 0..<5 do for col in 0..<5 {
        fmt.printfln("row: %d, col: %d", row, col)
    }
}
