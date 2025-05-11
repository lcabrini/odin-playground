package main

import "core:fmt"
import rl "vendor:raylib"

/*
    Emulation of the palette cycling programs we used write do in Turbo Pascal.
*/

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

    destroy_palette(&palette)
    rl.CloseWindow()
}

init_palette :: proc(palette: ^Palette) {
    cv := 0
    dir := 1
    c := 0
    color: rl.Color

    for {
        switch c {
            case 0:
                color = {u8(cv), 0, 0, 255}
            case 1:
                color = {0, u8(cv), 0, 255}
            case 2:
                color = {0, 0, u8(cv), 255}
            case 3:
                color = {0, u8(cv), u8(cv), 255}
            case 4:
                color = {u8(cv), u8(cv), 0, 255}
            case 5:
                color = {u8(cv), 0, u8(cv), 255}
            case:
                color = {u8(cv), u8(cv), u8(cv), 255}
        }

        add_palette_entry(palette, color)
        cv += dir
        if cv == 255 do dir *= -1
        if cv == 0 {
            if c < 6 {
                c += 1
                dir *= -1
            } else {
                break
            }
        }
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

destroy_palette :: proc(palette: ^Palette) {
    first := palette.head
    current := palette.head

    for {
        previous := current
        current = current.next
        free(previous)
        if current == first do break
    }
}