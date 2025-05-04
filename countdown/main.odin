package main

import "core:fmt"

main :: proc() {
    counter: [10]int

    for &c, i in counter {
        c = i+1
    }

    #reverse for c in counter {
        fmt.println(c)
    }

    fmt.println("BLAST OFF!")
}