package main

import "core:fmt"
import "core:math/rand"

main :: proc() {
    numbers := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

    rand.shuffle(numbers[:])
    fmt.printfln("Before sort: %v", numbers)
    insertion_sort(numbers)
    fmt.printfln("After sort: %v", numbers)
}

insertion_sort :: proc(na: []int) {
    for i := 1; i < len(na); i += 1 {
        key := na[i]
        j := i
        for j > 0 && key < na[j-1] {
            na[j] = na[j-1]
            j -= 1
        }

        na[j] = key
        fmt.printfln("    Pass #%d: %v", i, na)
    }
}