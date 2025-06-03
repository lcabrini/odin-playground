package main

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strconv"

main :: proc() {
    progname := filepath.base(os.args[0])

    if len(os.args[1:]) < 1 {
        fmt.eprintfln("usage: %s NUM...", progname)
        os.exit(1)
    }

    for a in os.args[1:] {
        num, ok := strconv.parse_int(a)
        if !ok {
            fmt.eprintfln("%s: skipping '%s': not a valid integer", progname, a)
            continue
        }

        steps := 0
        n := num
        outer: for {
            switch {
                case n == 1:
                    break outer
                case n % 2 == 0:
                    n /= 2
                    steps += 1
                case:
                    n = 3 * n + 1
                    steps += 1
            }

            // Printing this to stderr so that it can be discarded
            fmt.eprintfln("      after step #%d: %d", steps, n)
        }

        fmt.printfln("%d requires %d step%s", num, steps, steps == 1 ? "" : "s")
    }
}