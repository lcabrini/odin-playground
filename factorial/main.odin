package main

import "core:fmt"

main :: proc() {
    fmt.printfln("%10s | %10s | %10s", "i", "fact(i)", "fact_rec(i)")
    divider := "----------"
    fmt.printfln("%s + %s + %s", divider, divider, divider)
    for i in 0..=10 {
        fmt.printfln("% 10d | % 10d | % 10d", i, fact(i), fact_rec(i))
    }
}

fact :: proc(n: int) -> int {
    if n == 0 || n == 1 {
        return 1
    }

    f := 1
    for i in 2..=n {
        f *= i
    }

    return f
}

fact_rec :: proc(n: int) -> int {
    if n == 0 || n == 1 {
        return 1
    }

    return n * fact_rec(n-1)
}
