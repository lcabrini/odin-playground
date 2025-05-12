package main

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Fade"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)
    image := rl.LoadImage("../../resources/odin-logo.png")
    texture := rl.LoadTextureFromImage(image)

    tint := 0.0
    fade_dir := 1.0
    is_fading := true
    fade_v := 0.1
    fade_a := 1.08

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.SPACE) && !is_fading {
            is_fading = true
            fade_dir *= -1
        }

        if is_fading {
            fade_v *= fade_a
            tint += fade_v * fade_dir

            if tint < 0 {
                tint = 0
                is_fading = false
                fade_v = 0.8
            } else if tint > 255 {
                tint = 255
                is_fading = false
                fade_v = 0.8
            }
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        x := WIDTH / 2 - image.width / 2
        y := HEIGHT / 2 - image.height / 2
        rl.DrawTexture(texture, x, y, {u8(tint), u8(tint), u8(tint), 255})
        rl.EndDrawing()
    }

    rl.UnloadTexture(texture)
    rl.UnloadImage(image)
    rl.CloseWindow()
}