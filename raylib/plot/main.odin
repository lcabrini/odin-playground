package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Plot"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    //image := rl.LoadImageFromScreen()
    target := rl.LoadRenderTexture(WIDTH, HEIGHT)
    should_plot := false
    size: f32 = 1

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.UP) {
            size += 1
        }

        if rl.IsKeyPressed(.DOWN) {
            size -= 1
        }

        should_plot = rl.IsMouseButtonDown(rl.MouseButton.LEFT)

        rl.BeginTextureMode(target)
        if should_plot {
            pos := rl.GetMousePosition()
            rl.DrawCircleV(pos, size, rl.RAYWHITE)
        }
        rl.EndTextureMode()

        rl.BeginDrawing()
        //texture := rl.LoadTextureFromImage(image)
        rl.DrawTextureRec(target.texture, {0, 0, WIDTH, -HEIGHT}, {0, 0}, rl.RAYWHITE)
        rl.EndDrawing()

        //rl.UnloadTexture(texture)
    }

    rl.UnloadRenderTexture(target)
    rl.CloseWindow()
}
