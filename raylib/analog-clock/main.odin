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
    rl.SetTraceLogLevel(.ERROR)
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

        a := f32(s * 6) - 90
        x1 := MIDX + math.cos(a * rl.DEG2RAD) * 280
        y1 := MIDY + math.sin(a * rl.DEG2RAD) * 280
        x2 := MIDX + math.cos((a + 180) * rl.DEG2RAD) * 30
        y2 := MIDY + math.sin((a + 180) * rl.DEG2RAD) * 30
        rl.DrawLineEx({x1, y1}, {x2, y2}, 2, rl.BLACK)

        a = f32((m * 60 + s) / 10) - 90
        x1 = MIDX + math.cos(a * rl.DEG2RAD) * 280
        y1 = MIDY + math.sin(a * rl.DEG2RAD) * 280
        x2 = MIDX + math.cos((a + 180) * rl.DEG2RAD) * 30
        y2 = MIDY + math.sin((a + 180) * rl.DEG2RAD) * 30
        rl.DrawLineEx({x1, y1}, {x2, y2}, 5, rl.BLACK)

        a = (f32(h % 12 * 3600) + f32(m * 60 + s)) / 120 - 90
        x1 = MIDX + math.cos(a * rl.DEG2RAD) * 200
        y1 = MIDY + math.sin(a * rl.DEG2RAD) * 200
        x2 = MIDX + math.cos((a + 180) * rl.DEG2RAD) * 30
        y2 = MIDY + math.sin((a + 180) * rl.DEG2RAD) * 30
        rl.DrawLineEx({x1, y1}, {x2, y2}, 10, rl.BLACK)

        rl.DrawCircle(MIDX, MIDY, 10, rl.BLACK)
        rl.DrawCircle(MIDX, MIDY, 5, rl.RAYWHITE)

        rl.EndDrawing()
    }

    rl.CloseWindow()
}
