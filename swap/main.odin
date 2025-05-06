package main

import "core:fmt"

main :: proc() {
    a := 5
    b := 7

    fmt.printfln("before swap, a = %d, b = %d", a, b)
    swap(&a, &b)
    fmt.printfln("after swap, a = %d, b = %d", a, b)
}

swap :: proc(i, j: ^int) {
    i^, j^ = j^, i^
}