package main

import "core:fmt"
import "core:math/rand"

main :: proc() {
    numbers := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    rand.shuffle(numbers[:])
    fmt.printfln("Before sort: %v", numbers)
    selection_sort(numbers[:])
    fmt.printfln("After sort: %v", numbers)
}

selection_sort :: proc(na: []int) {
    for i := 0; i < len(na) - 1; i += 1 {
        min_index := i
        for j := i+1; j < len(na); j += 1 {
            if na[j] < na[min_index] do min_index = j
        }

        na[i], na[min_index] = na[min_index], na[i]
        fmt.printfln("    Pass #%d: %v", i+1, na)
    }
}