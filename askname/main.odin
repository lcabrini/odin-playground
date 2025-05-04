package main

import "core:fmt"
import "core:os"
import "core:strings"

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

    is_empty := strings.compare(name, "") == 0
    if is_empty {
        fmt.println("Coward!")
    } else {
        fmt.printfln("Hi, %s and welcome to Odin!", name)
    }
}