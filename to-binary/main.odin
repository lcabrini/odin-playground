package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
    for a in os.args[1:] {
        n, ok := strconv.parse_uint(a);
        if !ok {
            fmt.eprintfln("Unable to convert '%s': not a valid positive integer", a)
            continue
        }

        fmt.printfln("% 20d is %72s in binary", n, to_binary(n))
        fmt.printfln("% 20d is % 72b in binary (using %%b)", n, n)
    }
}

to_binary :: proc(n: uint) -> string {
    start: uint = 0
    switch {
        case n >= 1 << 32:
            start = 63
        case n >= 1 << 16:
            start = 31
        case n >= 1 << 8:
            start = 15
        case:
            start = 7
    }

    s := ""
    i := 1
    for g := uint(1 << start); g > 0; g >>= 1 {
        s = fmt.tprintf("%s%s%s", s, g & n == 0 ? "0" : "1", i % 8 == 0 ? " " : "")
        i += 1
    }

    return strings.trim_space(s)
}