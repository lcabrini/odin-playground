package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Ellipses"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

STEP :: 10

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    end_radius: f32 = 1

    for !rl.WindowShouldClose() {
        end_radius += STEP
        if end_radius > 350 do end_radius = 350

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for r: f32 = 0; r < 350; r += 1 {
            rl.DrawEllipse(MIDX, MIDY, r, 350-r, rl.RED)
        }

        for r: f32 = 0; r <= end_radius; r += STEP {
            rl.DrawEllipseLines(MIDX, MIDY, r, 350-r, rl.WHITE)
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}