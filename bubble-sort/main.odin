package main

import "core:fmt"
import "core:math/rand"

main :: proc() {
    numbers := [10]int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

    rand.shuffle(numbers[:])
    fmt.printfln("Before sort: %v", numbers)
    bubble_sort(numbers[:])
    fmt.printfln("After sort: %v", numbers)
}

bubble_sort :: proc(na: []int) {
    for i := 0; i < len(na) - 1; i+= 1 {
        swapped := false
        for j := i+1; j < len(na); j += 1 {
            if na[i] > na[j] {
                na[i], na[j] = na[j], na[i]
                swapped = true
            }
        }

        if !swapped {
            return
        }
    }
}