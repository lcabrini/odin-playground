package main

import "core:fmt"
import "core:math"
import "core:time"
import rl "vendor:raylib"

/*
    Adapted for Odin from: https://observablehq.com/@tom/moire-effect?collection=@tom/demo-effects
*/


WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Moire"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    image := rl.LoadImageFromScreen()

    t: f32 = 0
    a: f32 = 1
    b: f32 = 2
    c: f32 = 1.5
    d: f32 = 0.5
    e: u32 = 5

    palette := []rl.Color{rl.RED, rl.BLACK}

    for !rl.WindowShouldClose() {

        t += 0.3 * rl.GetFrameTime()

        cx1 := math.sin(t / a) * WIDTH/3 + MIDX
        cy1 := math.sin(t / b) * HEIGHT/2 + MIDY
        cx2 := math.cos(t / c) * WIDTH/3 + MIDX
        cy2 := math.cos(t / d) * HEIGHT/2 + MIDY

        for y: f32 = 0; y < HEIGHT; y += 1 {
            dy1 := math.pow(y - cy1, 2)
            dy2 := math.pow(y - cy2, 2)

            for x: f32 = 0; x < WIDTH; x += 1 {
                dx1 := math.pow(x - cx1, 2)
                dx2 := math.pow(x - cx2, 2)
                hy1 := math.sqrt(dx1 + dy1)
                hy2 := math.sqrt(dx2 + dy2)
                col := ((i32(hy1) | i32(hy2)) & ~(i32(hy1) & i32(hy2))) >> e & 1
                rl.ImageDrawPixelV(&image, {x, y}, palette[col])
            }
        }

        texture := rl.LoadTextureFromImage(image)

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawTexture(texture, 0, 0, rl.WHITE)
        rl.EndDrawing()
        rl.UnloadTexture(texture)
    }

    rl.UnloadImage(image)
    rl.CloseWindow()
}
