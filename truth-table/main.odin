package main

import "core:fmt"

main :: proc() {
    inputs := [][]bool{
        {false, false},
        {false, true},
        {true, false},
        {true, true}
    }

    fmt.printfln("%8s |%8s |%8s |%8s |%8s", "A", "B", "NOT A", "A AND B", "A OR B")
    for i in 0..<5 {
        fmt.print("---------")
        fmt.print("+")
    }
    fmt.println()

    for i in inputs {
        fmt.printfln(\
            "%8t |%8t |%8t |%8t |%8t", i[0], i[1], !i[0], i[0] && i[1], i[0] || i[1])
    }
}