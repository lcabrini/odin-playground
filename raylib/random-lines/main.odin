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
    clear := true
    pause := false
    use_r := true
    use_g := true
    use_b := true

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.P) do pause = !pause

        if !pause {
            if rl.IsKeyPressed(.C) do clear = true
            if rl.IsKeyPressed(.R) do use_r = !use_r
            if rl.IsKeyPressed(.G) do use_g = !use_g
            if rl.IsKeyPressed(.B) do use_b = !use_b

            x1 := f32(rl.GetRandomValue(0, WIDTH))
            y1 := f32(rl.GetRandomValue(0, HEIGHT))
            x2 := f32(rl.GetRandomValue(0, WIDTH))
            y2 := f32(rl.GetRandomValue(0, HEIGHT))
            r := use_r ? u8(rl.GetRandomValue(0, 255)) : 0
            g := use_g ? u8(rl.GetRandomValue(0, 255)) : 0
            b := use_b ? u8(rl.GetRandomValue(0, 255)) : 0
            rl.ImageDrawLineV(&image, {x1, y1}, {x2, y2}, {r, g, b, 255})

            if clear {
                rl.ImageClearBackground(&image, rl.BLACK)
                clear = false
            }
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        texture := rl.LoadTextureFromImage(image)
        rl.DrawTexture(texture, 0, 0, rl.WHITE)
        rl.EndDrawing()
        rl.UnloadTexture(texture)
    }

    rl.CloseWindow()
}