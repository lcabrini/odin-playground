package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Circle Play"
MIDX :: WIDTH/2
MIDY :: HEIGHT/2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.SetTraceLogLevel(.ERROR)
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    a: f32 = 0

    for !rl.WindowShouldClose() {
        a += 1
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        x: f32 = MIDX + (MIDX-300) * math.cos(a * rl.DEG2RAD)
        y: f32 = MIDY + (MIDY-300) * math.sin(a * rl.DEG2RAD)

        for i: f32 = 0; i < 300; i += 50 {
            rl.DrawCircleLinesV({x, y}, 300-i, rl.BLUE)
            x = x + (300 - i) * math.cos((a + i) * rl.DEG2RAD)
            y = y + (300 - i) * math.sin((a + i) * rl.DEG2RAD)
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}
