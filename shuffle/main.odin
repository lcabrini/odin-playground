package main

import "core:fmt"
import "core:math/rand"

main :: proc() {
    numbers: [10]int = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

    fmt.printfln("Before shuffle: %v", numbers)
    rand.shuffle(numbers[:])
    fmt.printfln("After shuffle: %v", numbers)
}
