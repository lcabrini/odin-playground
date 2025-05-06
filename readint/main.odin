package main

import "core:fmt"
import "core:os"
import "core:strconv"

main :: proc() {
    n := readint("Enter an integer:")
    fmt.printfln("I got: %d", n)
}

readint :: proc(prompt: string) -> int  {
    buf: [64]byte

    for {
        fmt.printf("%s ", prompt)
        bytes_read, err := os.read(os.stdin, buf[:])
        if err != nil {
            fmt.eprintln("Could not read from stdin: ", err)
            return 0
        }

        s := string(buf[:bytes_read-1])
        n, ok := strconv.parse_int(s)
        if !ok {
            fmt.printfln("'%s' not a valid integer. Try again", s)
            continue
        }

        return n
    }
}

