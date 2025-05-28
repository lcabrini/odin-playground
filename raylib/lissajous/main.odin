package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Lissajous Curve"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)
    end := 0

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        a: f32 = 3
        b: f32 = 4
        delta: f32 = math.PI / 2
        t: f32 = 0.0
        end += 1

        for i in 0..<end {
            t += 0.01
            x := MIDX + 500 * math.sin(a * f32(t) + delta)
            y := MIDY + 300 * math.sin(b * f32(t))

            rl.DrawCircle(i32(x), i32(y), 10, rl.BLUE)
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}