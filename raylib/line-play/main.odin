package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Line Play"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        t : = f32(rl.GetTime() * 0.5)

        rl.BeginDrawing()

        for i: f32 = 0; i < 30; i += 1 {
            x1 := MIDX + 500 * math.sin(4*t + i*0.08)
            y1 := MIDY + 300 * math.sin(5*t + i*0.08)
            x2 := MIDX + 500 * math.cos(6*t + i*0.08)
            y2 := MIDY + 300 * math.cos(3*t + i*0.08)

            rl.DrawLineV({x1, y1}, {x2, y2}, rl.GREEN)
        }

        rl.ClearBackground(rl.BLACK)

        rl.EndDrawing()
    }

    rl.CloseWindow()
}