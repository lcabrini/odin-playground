package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Distort"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    fn := cstring("../../resources/odin-logo.png")

    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    texture := rl.LoadTexture(fn)
    tw, th := texture.width, texture.height
    start_a: f32 = 0.0
    sx := MIDX - tw/2
    xdir: i32 = 2

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        a := start_a

        start_a += 2

        sx += xdir
        if sx < 0 || sx > WIDTH - tw {
            xdir *= -1
        }

        for x in 0..=tw {
            y := f32(MIDY - th/2) - 100 * math.sin(a * rl.DEG2RAD)
            src := rl.Rectangle{f32(x), 0, 1, f32(th)}
            dest := rl.Rectangle{f32(sx + x), y, 1, f32(th)}
            rl.DrawTexturePro(texture, src, dest, {0, 0}, 0, rl.RAYWHITE)
            a += 1
        }

        rl.EndDrawing()
    }

    rl.UnloadTexture(texture)
    rl.CloseWindow()
}