package main

import "core:os"
import "core:strings"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Color filter"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    fn := strings.clone_to_cstring(os.args[1])

    image := rl.LoadImage(fn)
    colors := rl.LoadImageColors(image)

    for y in 0..<image.height {
        for x in 0..<image.width {
            idx := y * image.width + x
            color := colors[idx]
            color.g = 0
            color.b = 0
            rl.ImageDrawPixel(&image, x, y, color)
        }
    }

    texture := rl.LoadTextureFromImage(image)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawTexture(texture, 100, 100, rl.RAYWHITE)
        rl.EndDrawing()
    }

    rl.UnloadTexture(texture)
    rl.CloseWindow()
}