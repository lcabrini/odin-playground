package main

import "core:fmt"

WIDTH :: 1024
HEIGHT :: 768

Pixel :: struct {
    color: [4]u8,
}

main :: proc() {
    screen: [][]Pixel
    screen = make([][]Pixel, HEIGHT)
    for y in 0..<HEIGHT do screen[y] = make([]Pixel, WIDTH)

    fmt.printfln("Size of screen: %d", len(screen))
    fmt.printfln("Size of screen[20]: %d", len(screen[20]))

    for y in 0..<HEIGHT do delete(screen[y])
    delete(screen)
}
