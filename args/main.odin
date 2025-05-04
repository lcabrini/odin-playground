package main

import "core:fmt"
import "core:os"

main :: proc() {
    fmt.printfln("Name of the executable: %s", os.args[0])

    for a, i in os.args[1:] {
        fmt.printfln("% 2d. %s", i, a)
    }
}