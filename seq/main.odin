package main

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strconv"
import "core:strings"

progname: string

main :: proc() {
    start, end, step: f64
    progname = filepath.base(os.args[0])

    switch len(os.args[1:]) {
        case 0:
            fmt.eprintfln("%s: missing operand", progname)
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
            fmt.eprintfln("%s: extra operand: %s", progname, os.args[4])
            os.exit(-1)
    }

    if start > end && step > 0 {
        os.exit(0)
    }

    if start < end && step < 0 {
        os.exit(0)
    }

    precision := get_max_precision(os.args[1:])
    for i := start; (start < end && i <= end) || (start > end && i >= end); i += step {
        fmt.printfln("%.*f", precision, i)
    }
}

to_float_or_fail :: proc(s: string) -> f64 {
    if f, ok := strconv.parse_f64(s); !ok {
        fmt.eprintfln("%s: invalid floating point argument: '%s'", progname, s)
        os.exit(-1)
    } else {
        return f
    }
}

get_max_precision :: proc(fps: []string) -> int {
    max := 0

    for f in fps {
        parts, err := strings.split(f, ".")
        if err != nil {
            fmt.eprintln("Memory allocation error:", err)
            os.exit(-1)
        }

        if len(parts) > 1 && len(parts[1]) > max {
            max = len(parts[1])
        }
    }

    return max
}
