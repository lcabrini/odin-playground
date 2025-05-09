package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Mousepos"
FONT_SIZE :: 30

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        mousepos := rl.GetMousePosition()
        msg := rl.TextFormat("Mouse position: (%04d, %03d)", int(mousepos.x), int(mousepos.y))
        rl.DrawText(msg, 10, 10, FONT_SIZE, rl.RAYWHITE)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}