package main

import "core:fmt"
import "core:math"
import "core:time"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Analog Clock"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        t := time.now()
        h, m, s := time.clock_from_time(t)

        rl.ClearBackground(rl.BLACK)

        rl.DrawCircle(MIDX, MIDY, 350, rl.DARKBROWN)
        rl.DrawCircle(MIDX, MIDY, 330, rl.RAYWHITE)

        for a := -90; a < 270; a += 6 {
            r := f32(a) * rl.DEG2RAD
            tick_end: f32 = a % 90 == 0 ? 300 : 320

            x1 := MIDX + i32(math.cos(r) * 330)
            y1 := MIDY + i32(math.sin(r) * 330)
            x2 := MIDX + i32(math.cos(r) * tick_end)
            y2 := MIDY + i32(math.sin(r) * tick_end)

            rl.DrawLine(x1, y1, x2, y2, rl.BLACK)
        }

        sa := f32(s * 6) - 90
        sx := MIDX + math.cos(sa * rl.DEG2RAD) * 320
        sy := MIDY + math.sin(f32(s*6-90) * rl.DEG2RAD) * 320
        rl.DrawLineEx({MIDX, MIDY}, {sx, sy}, 2, rl.BLACK)

        ma := f32((m * 60 + s) / 10) - 90
        mx := MIDX + math.cos(ma * rl.DEG2RAD) * 280
        my := MIDY + math.sin(ma * rl.DEG2RAD) * 280
        rl.DrawLineEx({MIDX, MIDY}, {mx, my}, 5, rl.BLACK)

        ha := (f32(h % 12 * 3600) + f32(m * 60 + s)) / 120 - 90
        hx := MIDX + math.cos(ha * rl.DEG2RAD) * 200
        hy := MIDY + math.sin(ha * rl.DEG2RAD) * 200
        rl.DrawLineEx({MIDX, MIDY}, {hx, hy}, 10, rl.BLACK)

        rl.DrawCircle(MIDX, MIDY, 10, rl.BLACK)
        rl.DrawCircle(MIDX, MIDY, 5, rl.RAYWHITE)

        rl.EndDrawing()
    }

    rl.CloseWindow()
}