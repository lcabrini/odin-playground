package main

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 600
HEIGHT :: 600
TITLE :: "Color Cycle"
TILE_SIZE :: 100

Palette :: struct {
    head: ^PaletteEntry,
    tail: ^PaletteEntry,
}

PaletteEntry :: struct {
    color: rl.Color,
    next: ^PaletteEntry,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    palette := Palette{}
    init_palette(&palette)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        entry := palette.head
        for i in 10..=490 {
            x := i32(WIDTH - 100 - i)
            y := i32(i)

            rl.DrawRectangle(x, y, TILE_SIZE, TILE_SIZE, entry.color)
            entry = entry.next
        }

        rl.EndDrawing()
        palette.head = palette.head.next
    }
}

init_palette :: proc(palette: ^Palette) {
    r := 100
    dir := 1

    for i in 10..=490 {
        add_palette_entry(palette, {u8(r), 0, 0, 255})
        r += dir
        if r == 100 || r == 255 do dir *= -1
    }
}

add_palette_entry :: proc(palette: ^Palette, color: rl.Color) {
    entry := new(PaletteEntry)
    entry.color = color

    if palette.head == nil {
        palette.head = entry
        palette.tail = entry
    }

    palette.tail.next = entry
    entry.next = palette.head
    palette.tail = entry
}