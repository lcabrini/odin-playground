package main

import "core:fmt"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Rotozoom"

main :: proc() {
    fname := cstring("../../resources/odin-logo.png")

    switch len(os.args[1:]) {
        case 0:
        case 1:
            fname = strings.clone_to_cstring(os.args[1])
        case 2:
            fmt.eprintfln("usage: %s [image file]", os.args[0])
            os.exit(-1)
    }

    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    image := rl.LoadImage(fname)
    texture := rl.LoadTextureFromImage(image)
    rot: f32 = 0.0
    zoom: f32 = 0.1
    dir: f32 = 1.02

    for !rl.WindowShouldClose() {
        rot += 2
        zoom *= dir

        if zoom < 0.1 || zoom > 5 {
            dir = 1 / dir
            if zoom > 5 do zoom = 5
            if zoom < 0.1 do zoom = 0.1
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        x := f32(WIDTH / 2)
        y := f32(HEIGHT / 2)
        w := f32(image.width) * zoom
        h := f32(image.height) * zoom
        src := rl.Rectangle{0, 0, f32(image.width), f32(image.height)}
        dest := rl.Rectangle{x, y, w, h}
        origin := rl.Vector2{w/2, h/2}
        rl.DrawTexturePro(texture, src, dest, origin, rot, rl.RAYWHITE)

        rl.EndDrawing()
    }

    rl.UnloadTexture(texture)
    rl.UnloadImage(image)
    rl.CloseWindow()

}