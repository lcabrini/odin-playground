package main

/*
    Simple copperbar effect, like in C64 and Amiga demos a different era.

    I hadn't written one of these in an awful long time, so I took the following and adapted it to Odin:
    https://canvasmania.net/article/4/rasterbars
*/

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Copperbars"

BAR_HEIGHT :: HEIGHT / 4
SPEED :: 3
STEP :: 12
COLOR_STEP :: 5

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    colors: []rl.Color = {
        {100, 0, 0, 255},
        {100, 100, 0, 255},
        {0, 100, 0, 255},
        {0, 0, 100, 255},
        {100, 0, 100, 255},
        {0, 100, 100, 255},
        {100, 100, 100, 255},
    }

    spiner: f32 = 0.0
    cl := len(colors)

    for !rl.WindowShouldClose() {
        spiner += SPEED

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for i in 0..<20 {
            y := HEIGHT/2 + math.floor(math.sin((spiner + STEP * f32(i)) * math.PI / 360.0) * BAR_HEIGHT)
            draw_bar(int(y), colors[i%cl])
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}

draw_bar :: proc(y: int, color: rl.Color) {
    for i := 0; i < 11; i += 1 {
        r := color.r + u8(i*COLOR_STEP)
        g := color.g + u8(i*COLOR_STEP)
        b := color.b + u8(i*COLOR_STEP)

        rl.DrawLine(0, i32(y+i), WIDTH, i32(y+i), {r,g,b,255})
        rl.DrawLine(0, i32(y+21-i), WIDTH, i32(y+21-i), {r,g,b,255})
    }
}