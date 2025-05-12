package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Plot"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    image := rl.LoadImageFromScreen()
    should_plot := false
    size: i32 = 1

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.UP) {
            size += 1
        }

        if rl.IsKeyPressed(.DOWN) {
            size -= 1
        }

        should_plot = rl.IsMouseButtonDown(rl.MouseButton.LEFT)

        if should_plot {
            pos := rl.GetMousePosition()
            rl.ImageDrawCircleV(&image, pos, size, rl.RAYWHITE)
        }

        rl.BeginDrawing()
        texture := rl.LoadTextureFromImage(image)
        rl.DrawTexture(texture, 0, 0, rl.RAYWHITE)
        rl.EndDrawing()

        rl.UnloadTexture(texture)
    }

    rl.CloseWindow()
}