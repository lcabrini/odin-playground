package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"

main :: proc() {
    start, end, step: f64

    switch len(os.args[1:]) {
        case 0:
            fmt.eprintfln("%s: missing operand", os.args[0])
            os.exit(-1)
        case 1:
            start = 1
            step = 1
            end = to_float_or_fail(os.args[1])
        case 2:
            start = to_float_or_fail(os.args[1])
            step = 1
            end = to_float_or_fail(os.args[2])
        case 3:
            start = to_float_or_fail(os.args[1])
            step = to_float_or_fail(os.args[2])
            end = to_float_or_fail(os.args[3])
        case:
            fmt.eprintfln("%s: extra operand: %s", os.args[0], os.args[4])
            os.exit(-1)
    }

    if start > end && step > 0 {
        os.exit(-1)
    }

    if start < end && step < 0 {
        os.exit(-1)
    }

    for i := start; (start < end && i <= end) || (start > end && i >= end); i += step {
        fmt.printfln("%.f", i)
    }
}

to_float_or_fail :: proc(s: string) -> f64 {
    if f, ok := strconv.parse_f64(s); !ok {
        fmt.eprintfln("%s: invalid flaoting point argument: '%s'", os.args[0], s)
        os.exit(-1)
    } else {
        return f
    }
}
