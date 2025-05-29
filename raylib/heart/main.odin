package main

/*
    Found the heart equation here: https://www.intmath.com/trigonometric-graphs/7-lissajous-figures.php
*/

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Heart"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    image := rl.LoadImageFromScreen()

    for a: f32 = 70; a > 1; a -= 1 {
        for t: f32 = 0.0; t <= math.PI * 2; t += 0.01 {
            x: f32 = MIDX + a * 5.0 * math.sin(t) * math.sin(t) * math.sin(t)
            y: f32 = MIDY - (a * 4.0 * math.cos(t) - a * 1.3 * math.cos(2.0 * t) - a * 0.6 * math.cos(3.0 * t) - a * 0.2 * math.cos(4.0 * t))
            rl.ImageDrawCircle(&image, i32(x), i32(y), 5, rl.RED)
        }
    }

    texture := rl.LoadTextureFromImage(image)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        x := MIDX - texture.width / 2
        y := MIDY - texture.height / 2
        rl.DrawTexture(texture, x, y, rl.WHITE)

        rl.EndDrawing()
    }

    rl.UnloadTexture(texture)
    rl.UnloadImage(image)
    rl.CloseWindow()
}
