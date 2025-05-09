package main

import "core:fmt"
import "core:os"

main :: proc() {
    if len(os.args[1:]) < 1 {
        fmt.fprintfln(os.stderr, "%s: missing operand", os.args[0])
        os.exit(-1)
    }

    for dir in os.args[1:] {
        if err := os.make_directory(dir); err != nil {
            fmt.fprintfln(os.stderr, "%s: cannot create directory '%s': %s", os.args[0], dir, err)
        }
    }
}