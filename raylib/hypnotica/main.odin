package main

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Rotated Shapes"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    start_rot: f32 = 0.0

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()

        rl.ClearBackground(rl.BLACK)

        rot := start_rot


        color := rl.RED
        for size := f32(500); size > 10; size /= 1.01 {
            color = color == rl.BLUE ? rl.RED : rl.BLUE
            rec := rl.Rectangle{MIDX, MIDY, size, size}
            origin := rl.Vector2{rec.width/2, rec.height/2}
            rl.DrawRectanglePro(rec, origin, rot, color)

            rot += 10
        }

        rl.EndDrawing()
        start_rot += 1
    }
    rl.CloseWindow()
}