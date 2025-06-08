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
    if len(os.args[1:]) != 1 {
        fmt.eprintfln("usage: %s IMAGE", prog)
        os.exit(1)
    }

    if !os.is_file(os.args[1]) {
        fmt.eprintfln("%s: file not found: %s", prog, os.args[1])
        os.exit(1)
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
            color.g = 0
            color.b = 0
            rl.ImageDrawPixel(&image, x, y, color)
        }
    }

    texture := rl.LoadTextureFromImage(image)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        if image.data != nil {
            rl.DrawTexture(texture, 100, 100, rl.RAYWHITE)
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