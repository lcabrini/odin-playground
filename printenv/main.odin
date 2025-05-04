package main

import "core:fmt"
import "core:os"
import "core:strings"

main :: proc() {
    for key, i in os.args[1:] {
        val := os.get_env(key)
        is_empty := strings.compare(val, "") == 0
        if is_empty do val = "<NOT SET>"
        fmt.printfln("%s: %s", key, val)
    }
}