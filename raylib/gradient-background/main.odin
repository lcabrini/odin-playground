package main

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Gradient Background"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    inc: f32 = 255.0 / HEIGHT

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for y: f32 = 0; y < HEIGHT; y += 1 {
            red := u8(y * inc)
            rl.DrawLineV({0, y}, {WIDTH, y}, {red, 0, 0, 255})
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}