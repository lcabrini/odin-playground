package main

import "core:fmt"
import "core:math/rand"

main :: proc() {
    numbers: [10]int = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

    fmt.println("Using rand.shuffle:")
    fmt.printfln(" Before shuffle: %v", numbers)
    rand.shuffle(numbers[:])
    fmt.printfln(" After shuffle: %v", numbers)

    numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    fmt.println("Using my own shuffle proc:")
    fmt.printfln(" Before shuffle: %v", numbers)
    shuffle(numbers[:])
    fmt.printfln(" After shuffle: %v", numbers)
}

shuffle :: proc(array: $T/[]$E) {
    for i in 0..<len(array) {
        j: int
        for {
            j = rand.int_max(len(array))
            if j != i do break
        }

        array[i], array[j] = array[j], array[i]
    }
}