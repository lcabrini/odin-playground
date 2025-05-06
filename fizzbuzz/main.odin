package main

import "core:fmt"
import "core:os"
import "core:strconv"

main :: proc() {
    upto := 100
    fizz := 3
    buzz := 5
    ok: bool

    if len(os.args) > 1 {
        if upto, ok = strconv.parse_int(os.args[1]); !ok {
            fmt.printfln("Invalid value for upto: %s", os.args[1])
            return
        }
    }

    if len(os.args) > 2 {
        if fizz, ok = strconv.parse_int(os.args[2]); !ok {
            fmt.printfln("Invalid value for fizz: %s", os.args[2])
        }
    }

    if len(os.args) > 3 {
        if buzz, ok = strconv.parse_int(os.args[3]); !ok {
            fmt.printfln("Invalid value for buzz %s", os.args[3])
        }
    }

    if fizz == buzz {
        fmt.printfln("Fizz and buzz are both %d", fizz)
        return
    }

    if fizz > buzz {
        fmt.printfln("Fizz (%d) is greater than buzz (%d)", fizz, buzz)
        return
    }

    if fizz > upto {
        fmt.println("No fizzes, buzzes or fizzbuzzes will be printed.")
        fmt.println("Might I recommend `seq 100` instead?")
        return
    }

    for i in 1..=upto {
        switch {
            case i % fizz == 0 && i % buzz == 0:
                fmt.println("fizz buzz")
            case i % buzz == 0:
                fmt.println("buzz")
            case i % fizz == 0:
                fmt.println("fizz")
            case:
                fmt.println(i)
        }
    }
}