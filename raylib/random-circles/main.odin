package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Random Circles"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)
    
    image := rl.LoadImageFromScreen()
    paused := false
    clear := true

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.P) {
            paused = !paused
        }

        if !paused {
            if rl.IsKeyPressed(.C) {
                clear = true
            }

            if clear {
                rl.ImageClearBackground(&image, rl.BLACK)
                clear = false
            }

            x := rl.GetRandomValue(1, WIDTH-2)
            y := rl.GetRandomValue(1, HEIGHT-2)
            max_radius := x
            if WIDTH - x < x do max_radius = WIDTH - x
            if y < max_radius do max_radius = y
            if HEIGHT - y < max_radius do max_radius = HEIGHT - y
            radius := rl.GetRandomValue(1, max_radius)
            r := u8(rl.GetRandomValue(1, 255))
            g := u8(rl.GetRandomValue(1, 255))
            b := u8(rl.GetRandomValue(1, 255))
            rl.ImageDrawCircle(&image, x, y, radius, {r, g, b, 255})
        }

        texture := rl.LoadTextureFromImage(image)
        rl.BeginDrawing()
        rl.DrawTexture(texture, 0, 0, rl.WHITE)
        rl.EndDrawing()

        rl.UnloadTexture(texture)
    }

    rl.CloseWindow()
}
