package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Circle Play"
MIDX :: WIDTH/2
MIDY :: HEIGHT/2
STEP :: 20

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
        color := rl.ORANGE

        for i: f32 = 0; i < 300; i += STEP {
            color = color == rl.RED ? rl.ORANGE : rl.RED
            rl.DrawCircleV({x, y}, 300-i, color)
            x = x + (i+STEP - i)/2 * math.cos(a * rl.DEG2RAD)
            y = y + (i+STEP - i)/2 * math.sin(a * rl.DEG2RAD)
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}
