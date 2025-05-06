package main

import "core:fmt"
import "core:os"
import "core:strconv"

Range :: struct {
    min: int,
    max: int,
}

ValidatorData :: union {
    int,
    Range,
}

Validator :: struct {
    p: proc(int, ValidatorData) -> bool,
    data: ValidatorData,
}

main :: proc() {
    n := readint("Enter any integer:")
    fmt.printfln("I got: %d", n)

    max100 := Validator{p = max_validator, data = 100}
    even := Validator{p = even_validator}
    between50and70 := Validator{p = range_validator, data = Range{50, 70}}

    n = readint("Enter an integer less than or equal to 100:", []Validator{max100})
    fmt.printfln("I got: %d", n)
    n = readint("Enter an even integer:", []Validator{even})
    fmt.printfln("I got: %d", n)
    n = readint("Enter an even integer less than or equal to 100:", []Validator{even, max100})
    fmt.printfln("I got: %d", n)
    n = readint("Enter an integer between 50 and 70:", []Validator{between50and70})
    fmt.printfln("I got: %d", n)
}

readint :: proc(prompt: string, validators: []Validator = nil) -> int  {
    buf: [64]byte

    input: for {
        fmt.printf("%s ", prompt)
        bytes_read, err := os.read(os.stdin, buf[:])
        if err != nil {
            fmt.eprintln("Could not read from stdin: ", err)
            return 0
        }

        s := string(buf[:bytes_read-1])
        n, ok := strconv.parse_int(s)
        if !ok {
            fmt.printfln("'%s' not a valid integer. Try again", s)
            continue
        }

        if validators != nil {
            for v in validators {
                if !v.p(n, v.data) do continue input
            }
        }

        return n
    }
}

max_validator :: proc(n: int, data: ValidatorData) -> bool {
    if n <= data.(int) do return true
    fmt.printfln("The value %d is larger than %d. Try again", n, data)
    return false
}

even_validator :: proc(n: int, data: ValidatorData) -> bool {
    if n % 2 == 0 do return true
    fmt.printfln("The value %d is not even. Try again.", n)
    return false
}

range_validator :: proc(n: int, data: ValidatorData) -> bool {
    range := data.(Range)
    if n >= range.min && n <= range.max do return true
    fmt.printfln("The valued %d is outside of the range %d-%d", n, range.min, range.max)
    return false
}