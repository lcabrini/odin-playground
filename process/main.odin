package main

import "core:fmt"
import os "core:os/os2"

/*
    This example uses functionality that is not stable yet (May 5, 2025).

    https://github.com/odin-lang/Odin/issues/3325#issuecomment-2307611060
*/

main ::  proc() {
    if err := run_process(os.args[1:]); err != nil {
        fmt.eprintln("Failed to run subprocess: ", err)
    }
}

run_process :: proc(cmd: []string) -> (err: os.Error) {
    r, w := os.pipe() or_return
    defer os.close(r)

    p: os.Process; {
        defer os.close(w)

        p = os.process_start({
            command = cmd,
            stdout = w,
        }) or_return
    }

    output := os.read_entire_file(r, context.temp_allocator) or_return
    _ = os.process_wait(p) or_return

    fmt.println(string(output))
    return
}