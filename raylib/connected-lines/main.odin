package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Connected Lines"


main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    image := rl.LoadImageFromScreen()
    rl.SetTargetFPS(30)

    endpoint_x := i32(0)
    endpoint_y := i32(0)
    line_drawn := false
    should_clear := true

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.C) {
            should_clear = true
        }

        x1 := line_drawn ? endpoint_x : rl.GetRandomValue(0, WIDTH-1)
        y1 := line_drawn ? endpoint_y : rl.GetRandomValue(0, HEIGHT-1)
        x2 := rl.GetRandomValue(0, WIDTH-1)
        y2 := rl.GetRandomValue(0, HEIGHT-1)
        r := u8(rl.GetRandomValue(0, 255))
        g := u8(rl.GetRandomValue(0, 255))
        b := u8(rl.GetRandomValue(0, 255))

        rl.BeginDrawing()
        if should_clear {
            rl.ImageClearBackground(&image, rl.BLACK)
            should_clear = false
        }

        rl.ImageDrawLine(&image, x1, y1, x2, y2, {r, g, b, 255})
        texture := rl.LoadTextureFromImage(image)
        rl.DrawTexture(texture, 0, 0, rl.RAYWHITE)
        rl.EndDrawing()

        rl.UnloadTexture(texture)
        line_drawn = true
        endpoint_x = x2
        endpoint_y = y2
    }

    rl.UnloadImage(image)
    rl.WindowShouldClose()
}