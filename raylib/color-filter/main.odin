package main

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Color filter"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    prog := filepath.base(os.args[0])
    if len(os.args[1:]) != 2 {
        fmt.eprintfln("usage: %s IMAGE FILTER", prog)
        os.exit(1)
    }

    if !os.is_file(os.args[1]) {
        fmt.eprintfln("%s: file not found: %s", prog, os.args[1])
        os.exit(1)
    }

    red_filter := false
    green_filter := false
    blue_filter := false
    for r in os.args[2] {
        switch r {
            case 'r':
                red_filter = true
            case 'g':
                green_filter = true
            case 'b':
                blue_filter = true
            case:
                fmt.eprintfln("%s: invalid filter: %c", prog, r)
                os.exit(1)
        }
    }

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
            color.r = red_filter ? color.r : 0
            color.g = green_filter ? color.g : 0
            color.b = blue_filter ? color.b : 0
            rl.ImageDrawPixel(&image, x, y, color)
        }
    }

    texture := rl.LoadTextureFromImage(image)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        if image.data != nil {
            scale: f32 = 1.0
            w := f32(texture.width)
            h := f32(texture.height)
            if texture.height > HEIGHT {
                scale_x := f32(HEIGHT - 20) / f32(texture.height)
                scale_y := f32(WIDTH - 20) / f32(texture.width)

                scale = scale_x > scale_y ? scale_y : scale_x
                w *= scale
                h *= scale
            }

            rl.DrawTextureEx(texture, {f32(MIDX - w / 2), f32(MIDY - h / 2)}, 0, scale, rl.RAYWHITE)
        } else {
            msg: cstring = "Unsupported image format"
            tw := rl.MeasureText(msg, 40)
            rl.DrawText(msg, MIDX - tw / 2, MIDY - 40 / 2, 40, rl.RED)
        }
        rl.EndDrawing()
    }

    rl.UnloadTexture(texture)
    rl.CloseWindow()
}