package main

import rl "vendor:raylib"

/*
    Inspired by graphdemo, a demonstration of the Turbo Pascal graph unit.
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Random Lines"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    image := rl.LoadImageFromScreen()

    for !rl.WindowShouldClose() {
        x1 := f32(rl.GetRandomValue(0, WIDTH))
        y1 := f32(rl.GetRandomValue(0, HEIGHT))
        x2 := f32(rl.GetRandomValue(0, WIDTH))
        y2 := f32(rl.GetRandomValue(0, HEIGHT))
        r := u8(rl.GetRandomValue(0, 255))
        g := u8(rl.GetRandomValue(0, 255))
        b := u8(rl.GetRandomValue(0, 255))
        rl.ImageDrawLineV(&image, {x1, y1}, {x2, y2}, {r, g, b, 255})

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        texture := rl.LoadTextureFromImage(image)
        rl.DrawTexture(texture, 0, 0, rl.WHITE)
        rl.EndDrawing()
        rl.UnloadTexture(texture)
    }

    rl.CloseWindow()
}