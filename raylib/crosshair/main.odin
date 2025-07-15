package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Crosshair"
RADIUS :: 30
INNER_RADIUS :: 5

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        mp := rl.GetMousePosition()

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        rl.DrawCircleLinesV(mp, RADIUS, rl.WHITE)
        rl.DrawCircleLinesV(mp, INNER_RADIUS, rl.WHITE)
        rl.DrawLineV({mp.x, mp.y-RADIUS-4}, {mp.x, mp.y+RADIUS+4}, rl.WHITE)
        rl.DrawLineV({mp.x-RADIUS-4, mp.y}, {mp.x+RADIUS+4, mp.y}, rl.WHITE)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
