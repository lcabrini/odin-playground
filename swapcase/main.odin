package main

import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"
import "core:unicode"

main :: proc() {
    buf: [512]byte

    fmt.print("Type something: ")
    num_bytes, err := os.read(os.stdin, buf[:])
    if err != nil {
        fmt.eprintln("Error reading from stdin: ", err)
        return
    }

    s := string(buf[:num_bytes-1])
    cs := swapcase(s)

    fmt.printfln("Case swapped: %s", cs)

}

swapcase :: proc(s: string) -> (res: string, err: mem.Allocator_Error) #optional_allocator_error {
    b: strings.Builder

    allocator := context.allocator
    strings.builder_init(&b, 0, len(s), allocator) or_return

    for r in s {
        if r >= 'a' && r <= 'z' {
            strings.write_rune(&b, unicode.to_upper(r))
        } else if r >= 'A' && r <= 'Z' {
            strings.write_rune(&b, unicode.to_lower(r))
        } else {
            strings.write_rune(&b, r)
        }
    }

    return strings.to_string(b), nil
}