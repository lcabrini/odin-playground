package main

import "core:fmt"
import "core:math/rand"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Melting Screen"

main :: proc() {
    bg_fn := strings.clone_to_cstring(os.args[1])
    fg_fn := strings.clone_to_cstring(os.args[2])

    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    bg_image := rl.LoadImage(bg_fn)
    fg_image := rl.LoadImage(fg_fn)

    scale_image(&bg_image)
    scale_image(&fg_image)

    bg_texture := rl.LoadTextureFromImage(bg_image)
    fg_texture := rl.LoadTextureFromImage(fg_image)

    rl.UnloadImage(bg_image)
    rl.UnloadImage(fg_image)

    offsets: [WIDTH]i32
    offsets[0] = -rl.GetRandomValue(0, 255) % 16
    for i := 1; i < WIDTH/2; i += 1 {
        r := rl.GetRandomValue(0, 255) % 3 - 1
        offsets[i] = offsets[i-1] + r
    }

    for !rl.WindowShouldClose() {
        for i := 0; i < WIDTH; i += 1 {
            offsets[i] += offsets[i] <= 0 ? 1 : 8
            if offsets[i] > HEIGHT do offsets[i] = HEIGHT
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawTexture(bg_texture, 0, 0, rl.WHITE)

        for x: f32 = 0; x < WIDTH; x += 1 {
            y := offsets[int(x)] > 0 ? f32(offsets[int(x)]) : 0
            h := f32(fg_texture.height)
            src := rl.Rectangle{x, 0, x, h}
            dest := rl.Rectangle{x, y, x, h}
            rl.DrawTexturePro(fg_texture, src, dest, 0, 0, rl.WHITE)
        }

        rl.EndDrawing()
    }

    rl.UnloadTexture(bg_texture)
    rl.UnloadTexture(fg_texture)
    rl.CloseWindow()
}

scale_image :: proc(image: ^rl.Image) {
    iw := f32(image.width)
    ih := f32(image.height)

    scale := WIDTH / f32(iw)
    rl.ImageResize(image, i32(iw*scale), i32(ih*scale))
}
