package main

import "core:fmt"
import "core:os"
import "core:strconv"

main :: proc() {
    upto := 100
    ok: bool

    if len(os.args) > 1 {
        if upto, ok = strconv.parse_int(os.args[1]); !ok {
            fmt.printfln("Invalid value for upto: %s", os.args[1])
            return
        }
    }

    for i in 1..=upto {
        switch {
            case i % 15 == 0:
                fmt.println("fizz buzz")
            case i % 5 == 0:
                fmt.println("buzz")
            case i % 3 == 0:
                fmt.println("fizz")
            case:
                fmt.println(i)
        }
    }
}