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
    clear := true
    fill := false
    use_r := true
    use_g := true
    use_b := true

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.P) {
            paused = !paused
        }

        if !paused {
            if rl.IsKeyPressed(.C) {
                clear = true
            }

            if rl.IsKeyPressed(.F) {
                fill = !fill
            }

            if rl.IsKeyPressed(.R) {
                use_r = !use_r
            }

            if rl.IsKeyPressed(.G) {
                use_g = !use_g
            }

            if rl.IsKeyPressed(.B) {
                use_b = !use_b
            }

            if clear {
                rl.ImageClearBackground(&image, rl.BLACK)
                clear = false
            }

            x1 := f32(rl.GetRandomValue(0, WIDTH))
            y1 := f32(rl.GetRandomValue(0, HEIGHT))
            x2 := f32(rl.GetRandomValue(0, WIDTH))
            y2 := f32(rl.GetRandomValue(0, HEIGHT))
            x3 := f32(rl.GetRandomValue(0, WIDTH))
            y3 := f32(rl.GetRandomValue(0, HEIGHT))
            r := use_r ? u8(rl.GetRandomValue(0, 255)) : 0
            g := use_g ? u8(rl.GetRandomValue(0, 255)) : 0
            b := use_b ? u8(rl.GetRandomValue(0, 255)) : 0

            if fill {
                rl.ImageDrawTriangle(&image, {x1, y1}, {x2, y2}, {x3, y3}, {r, g, b, 255})
            } else {
                rl.ImageDrawTriangleLines(&image, {x1, y1}, {x2, y2}, {x3, y3}, {r, g, b, 255})
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
