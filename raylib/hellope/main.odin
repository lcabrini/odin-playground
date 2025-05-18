package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Hellope"
MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2
FONT_SIZE :: 30
MESSAGE :: "Hellope!"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.P) {
            rl.TakeScreenshot("screenshot.png")
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        tw := rl.MeasureText(MESSAGE, FONT_SIZE)
        x := i32(MIDX - tw/2)
        y := i32(MIDY - FONT_SIZE/2)
        rl.DrawText(MESSAGE, x, y, FONT_SIZE, rl.RAYWHITE)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}