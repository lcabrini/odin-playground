package main

import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"
import "core:unicode"

main :: proc() {
    buf: [512]byte

    fmt.print("What is your name? ")
    num_bytes, err := os.read(os.stdin, buf[:])
    if err != nil {
        fmt.eprintln("Error reading from stdin: ", err)
        return
    }

    name := string(buf[:num_bytes-1])
    name = strings.trim_space(name)
    name = capitalize_names(name)

    is_empty := strings.compare(name, "") == 0
    if is_empty {
        fmt.println("Coward!")
    } else {
        fmt.printfln("Hi, %s and welcome to Odin!", name)
    }
}

capitalize_names :: proc(name: string) -> (res: string, err: mem.Allocator_Error) #optional_allocator_error {
    b: strings.Builder
    allocator := context.allocator
    strings.builder_init(&b, 0, len(name), allocator)
    capitalize_next := true
    for r in name {
        if capitalize_next {
            strings.write_rune(&b, unicode.to_upper(r))
            capitalize_next = false
        } else {
            strings.write_rune(&b, unicode.to_lower(r))
        }

        if r == ' ' {
            capitalize_next = true
        }
    }
    return strings.to_string(b), nil
}