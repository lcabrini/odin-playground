package main

import "core:math"
import rl "vendor:raylib"

/*
    Adapted from https://www.geeksforgeeks.org/python/turtle-programming-python/
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Rainbow Benzene"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    colors := []rl.Color{
        rl.RED,
        rl.PURPLE,
        rl.BLUE,
        rl.GREEN,
        rl.ORANGE,
        rl.YELLOW,
    }

    total := 0
    start_angle: f32 = 0

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        start_pos := rl.Vector2{MIDX, MIDY}
        a: f32 = start_angle
        l := 0

        for i in 0..<total {
            c := colors[i%6]
            w := f32(i) / 100 + 1
            end_x := start_pos.x + math.cos(a * rl.DEG2RAD) * f32(l)
            end_y := start_pos.y + math.sin(a * rl.DEG2RAD) * f32(l)
            rl.DrawLineEx(start_pos, {end_x, end_y}, w, c)
            start_pos = {end_x, end_y}
            l += 1
            a -= 59
        }

        rl.EndDrawing()

        if total < 600 {
            total += 1
        } else {
            start_angle -= 1
        }
    }

    rl.CloseWindow()
}