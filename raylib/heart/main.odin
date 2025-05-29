package main

/*
    Found the heart equation here: https://www.intmath.com/trigonometric-graphs/7-lissajous-figures.php
*/

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Heart"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    size := 0

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        size += 1
        t: f32 = 0.0
        for i in 0..<size {
            t += 0.01
            x: f32 = MIDX + 250.0 * math.sin(t) * math.sin(t) * math.sin(t)
            y: f32 = MIDY - (200.0 * math.cos(t) - 65.0 * math.cos(2.0 * t) - 30.0 * math.cos(3.0 * t) - 10.0 * math.cos(4.0 * t))
            if t > math.PI * 2.0 do fmt.println("Done!")
            rl.DrawCircle(i32(x), i32(y), 10, rl.RED)
        }

        rl.EndDrawing()
    }
}