package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Crosshair"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        mp := rl.GetMousePosition()

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        rl.DrawCircleLinesV(mp, 30, rl.WHITE)
        rl.DrawCircleLinesV(mp, 5, rl.WHITE)
        rl.DrawLineV({mp.x, mp.y-34}, {mp.x, mp.y+34}, rl.WHITE)
        //rl.DrawLineV({mp.x, mp.y+33}, {mp.x, mp.y+27}, rl.WHITE)
        //rl.DrawLineV({mp.x-33, mp.y}, {mp.x-27, mp.y}, rl.WHITE)
        rl.DrawLineV({mp.x-34, mp.y}, {mp.x+34, mp.y}, rl.WHITE)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
