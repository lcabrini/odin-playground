package main

import rl "vendor:raylib"

/*
    Inspired by a program that demonstrated the Turbo Pascal graph unit
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Random Rectangles"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    image := rl.LoadImageFromScreen()
    rectangles_per_frame := 1

    for !rl.WindowShouldClose() {
        for i in 0..=rectangles_per_frame {
            x := rl.GetRandomValue(0, WIDTH-1)
            y := rl.GetRandomValue(0, HEIGHT-1)
            w := rl.GetRandomValue(1, WIDTH-x)
            h := rl.GetRandomValue(1, HEIGHT-y)
            r := u8(rl.GetRandomValue(0, 255))
            g := u8(rl.GetRandomValue(0, 255))
            b := u8(rl.GetRandomValue(0, 255))
            rl.ImageDrawRectangle(&image, x, y, w, h, {r, g, b, 255})
        }

        rl.BeginDrawing()
        texture := rl.LoadTextureFromImage(image)
        rl.DrawTexture(texture, 0, 0, rl.WHITE)
        rl.EndDrawing()

        rl.UnloadTexture(texture)
    }

    rl.UnloadImage(image)
    rl.CloseWindow()
}