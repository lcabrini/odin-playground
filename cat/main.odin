package main

import "core:fmt"
import "core:os"
import "core:strings"

main :: proc() {
    if len(os.args[1:]) < 1 {
        print_stdin()
        os.exit(0)
    }

    for a in os.args[1:] {
        print_file(a)
    }
}

print_file :: proc(fp: string) {
    data, err := os.read_entire_file_or_err(fp, context.allocator)
    if err != nil {
        fmt.eprintfln("%s: %s: %v", os.args[0], fp, err)
        return
    }
    defer delete(data, context.allocator)

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        fmt.println(line)
    }
}

print_stdin :: proc() {
    for {
        buf: [1024]byte

        br, err := os.read(os.stdin, buf[:])
        if err != nil {
            fmt.eprintfln("%s: %s", os.args[0], err)
            continue
        }

        if br == 0 do break

        s := string(buf[:br-1])
        fmt.println(s)
    }
}