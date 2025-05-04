package main

import "core:fmt"

main :: proc() {
    counter: [10]int

    // We could of course have used a c-style for loop, but this is more fun...
    for &c, i in counter {
        c = i+1
    }

    // ... because now we can use #reverse! Yay!
    #reverse for c in counter {
        fmt.println(c)
    }

    fmt.println("BLAST OFF!")
}