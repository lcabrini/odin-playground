package main

import "core:fmt"

main :: proc() {
    fmt.print("    |")
    for h in 1..=12 {
        fmt.printf("% 4d|", h)
    }
    fmt.println()

    for d in 1..=13 {
        fmt.print("----+")
    }
    fmt.println()

    for r in 1..=12 {
        fmt.printf("% 4d|", r)

        for c in 1..=12 {
            fmt.printf("% 4d|", r*c)
        }
        fmt.println()
    }
}