package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Trig Plot"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    amp:f32 = MIDY - 10

    for !rl.WindowShouldClose() {
        if rl.IsKeyDown(.UP) {
            amp += 1
        }

        if rl.IsKeyDown(.DOWN) {
            amp -= 1
        }

        if amp > MIDY - 10 {
            amp = MIDY - 10
        }

        if amp < -(MIDY - 10) {
            amp = -(MIDY - 10)
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        rl.DrawLine(0, MIDY, WIDTH, MIDY, rl.RED)
        rl.DrawLine(MIDX, 0, MIDX, HEIGHT, rl.RED)

        for tick := i32(0); tick < WIDTH / 2; tick += 90 {
            rl.DrawLine(MIDX + tick, MIDY - 10, MIDX + tick, MIDY + 10, rl.RED)
            rl.DrawLine(MIDX - tick, MIDY - 10, MIDX - tick, MIDY + 10, rl.RED)
        }

        a: f32 = 0 - MIDX
        py_sin: f32 = 0
        py_cos: f32 = 0

        for x := f32(0); x < WIDTH; x += 1 {
            r := a * rl.DEG2RAD
            y_sin := MIDY - amp * math.sin(r)
            //rl.DrawPixelV({f32(x), y}, rl.RAYWHITE)
            rl.DrawLineV({x-1, py_sin}, {x, y_sin}, rl.BLUE)
            py_sin = y_sin

            y_cos := MIDY - amp * math.cos(r)
            rl.DrawLineV({x-1, py_cos}, {x, y_cos}, rl.YELLOW)
            py_cos = y_cos

            a += 1
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}