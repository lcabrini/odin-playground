package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Random Triangles"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    image := rl.LoadImageFromScreen()
    paused := false

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.P) {
            paused = !paused
        }

        if !paused {
            x1 := f32(rl.GetRandomValue(0, WIDTH))
            y1 := f32(rl.GetRandomValue(0, HEIGHT))
            x2 := f32(rl.GetRandomValue(0, WIDTH))
            y2 := f32(rl.GetRandomValue(0, HEIGHT))
            x3 := f32(rl.GetRandomValue(0, WIDTH))
            y3 := f32(rl.GetRandomValue(0, HEIGHT))
            r := u8(rl.GetRandomValue(0, 255))
            g := u8(rl.GetRandomValue(0, 255))
            b := u8(rl.GetRandomValue(0, 255))
            rl.ImageDrawTriangleLines(&image, {x1, y1}, {x2, y2}, {x3, y3}, {r, g, b, 255})
        }

        texture := rl.LoadTextureFromImage(image)
        rl.BeginDrawing()
        rl.DrawTexture(texture, 0, 0, rl.WHITE)
        rl.EndDrawing()
        rl.UnloadTexture(texture)
    }

    rl.UnloadImage(image)
    rl.CloseWindow()
}
