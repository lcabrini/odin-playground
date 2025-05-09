package main

import "core:fmt"
import "core:time"

main :: proc() {
    h, _, _ := time.clock_from_time(time.now())

    switch {
        case h >= 4 && h < 12:
            fmt.println("Good morning!")
        case h >= 12 && h < 17:
            fmt.println("Good afternoon!")
        case h >= 17 && h < 23:
            fmt.println("Good evening!")
        case:
            fmt.println("Good night!")
    }
}