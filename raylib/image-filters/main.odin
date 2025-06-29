package main

import "core:fmt"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Image filters"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    fn := strings.clone_to_cstring(os.args[1])
    src := rl.LoadImage(fn)
    dest := rl.LoadImageFromScreen()
    colors := rl.LoadImageColors(src)
    idx: i32 = 0

    w: i32 = src.width
    h: i32 = src.height

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        if idx < src.height * src.width {
            for x in 0..<w {
                pixel := colors[idx]
                pixel = invert_pixel(&pixel, true, true, true)
                y: i32 = i32(idx) / src.width
                rl.ImageDrawPixel(&dest, x, y, pixel)
                idx += 1
            }
        }

        texture := rl.LoadTextureFromImage(dest)
        rl.DrawTexture(texture, 0, 0, rl.WHITE)
        rl.EndDrawing()
        rl.UnloadTexture(texture)
    }

    rl.UnloadImage(src)
    rl.UnloadImage(dest)
    rl.CloseWindow()
}

invert_pixel :: proc(color: ^rl.Color, filter_r := false, filter_g := false, filter_b := false) -> rl.Color {
    if filter_r do color.r = 255 - color.r
    if filter_g do color.g = 255 - color.g
    if filter_b do color.b = 255 - color.b
    return color^
}