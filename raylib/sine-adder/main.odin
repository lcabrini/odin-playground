package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Sine Adder"
MIDX :: WIDTH/2
MIDY :: HEIGHT/2

Curve :: struct {
    amp: f32,
    freq: f32,
    phase: f32,
    color: rl.Color
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.SetTraceLogLevel(.ERROR)
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    curve1 := Curve{amp=50, freq=1.7, phase=1, color=rl.RED}
    curve2 := Curve{amp=60, freq=1, phase=3, color=rl.GREEN}
    curve3 := Curve{amp=100, freq=0.2, phase=-4, color=rl.BLUE}
    start_a: f32 = -1

    for !rl.WindowShouldClose() {
        start_a += 1
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        for a in 0..<f32(WIDTH) {
            y1 := curve1.amp * math.sin(curve1.freq * (a + start_a) * rl.DEG2RAD+curve1.phase)
            y2 := curve2.amp * math.sin(curve2.freq * (a + start_a) * rl.DEG2RAD+curve2.phase)
            y3 := curve3.amp * math.sin(curve3.freq * (a + start_a) * rl.DEG2RAD+curve3.phase)
            yt := y1 + y2 + y3
            rl.DrawCircleV({a, MIDY-y1}, 3, curve1.color)
            rl.DrawCircleV({a, MIDY-y2}, 3, curve2.color)
            rl.DrawCircleV({a, MIDY-y3}, 3, curve3.color)
            rl.DrawCircleV({a, MIDY-yt}, 3, rl.RAYWHITE)
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}
