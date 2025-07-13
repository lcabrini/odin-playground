package main

import "core:math"
import rl "vendor:raylib"

/*
   Adapted from the plasma effect on https://seancode.com/demofx/
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Plasma"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)
    image := rl.LoadImageFromScreen()

    for !rl.WindowShouldClose() {
        t := f32(rl.GetTime())

        for y: i32 = 0; y < HEIGHT; y += 1 {
            dy := f32(y) / HEIGHT - 0.5
            for x: i32 = 0; x < WIDTH; x += 1 {
                dx := f32(x) / WIDTH - 0.5
                v := math.sin(dx * 10 + t)
                cx := dx + 0.5 * math.sin(t/5)
                cy := dy + 0.5 * math.cos(t/3)
                v += math.sin(math.sqrt(50 * (cx*cx + cy*cy) + 1 + t))
                v += math.cos(math.sqrt(dx*dx + dy*dy) - t)
                g := u8(math.sin(v*math.PI) * 255)
                b := u8(math.cos(v*math.PI) * 255)
                rl.ImageDrawPixel(&image, x, y, {0, g, b, 255})
            }
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
