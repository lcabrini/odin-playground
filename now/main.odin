package main

import "core:fmt"
import "core:time"

main :: proc() {
    now := time.now()
    s, ok := time.time_to_rfc3339(now, 0, false)
    fmt.println(s)
}