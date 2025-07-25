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

    show_1 := true
    show_2 := true
    show_3 := true
    paused := false

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.ONE) do show_1 = !show_1
        if rl.IsKeyPressed(.TWO) do show_2 = !show_2
        if rl.IsKeyPressed(.THREE) do show_3 = !show_3
        if rl.IsKeyPressed(.P) do paused = !paused

        if !paused do start_a += 1

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        for a in 0..<f32(WIDTH) {
            y1 := curve1.amp * math.sin(curve1.freq * (a + start_a) * rl.DEG2RAD+curve1.phase)
            y2 := curve2.amp * math.sin(curve2.freq * (a + start_a) * rl.DEG2RAD+curve2.phase)
            y3 := curve3.amp * math.sin(curve3.freq * (a + start_a) * rl.DEG2RAD+curve3.phase)
            yt: f32 = 0
            
            if show_1 {
                rl.DrawCircleV({a, MIDY-y1}, 3, curve1.color)
                yt += y1
            }

            if show_2 {
                rl.DrawCircleV({a, MIDY-y2}, 3, curve2.color)
                yt += y2
            }

            if show_3 {
                rl.DrawCircleV({a, MIDY-y3}, 3, curve3.color)
                yt += y3
            }

            rl.DrawCircleV({a, MIDY-yt}, 3, rl.RAYWHITE)
        }

        if show_1 {
            rl.DrawRectangle(40, 580, 300, 120, {255, 0, 0, 100})
            rl.GuiSlider({100, 600, 200, 20}, "Amp 1", rl.TextFormat("%.2f", curve1.amp), &curve1.amp, 0, 120)
            rl.GuiSlider({100, 630, 200, 20}, "Freq 1", rl.TextFormat("%.2f", curve1.freq), &curve1.freq, 0.05, 5)
            rl.GuiSlider({100, 660, 200, 20}, "Phase 1", rl.TextFormat("%.2f", curve1.phase), &curve1.phase, 0, 2*math.PI)
        }

        if show_2 {
            rl.DrawRectangle(340, 580, 300, 120, {0, 255, 0, 100})
            rl.GuiSlider({400, 600, 200, 20}, "Amp 2", rl.TextFormat("%.2f", curve2.amp), &curve2.amp, 0, 120)
            rl.GuiSlider({400, 630, 200, 20}, "Freq 2", rl.TextFormat("%.2f", curve2.freq), &curve2.freq, 0.05, 5)
            rl.GuiSlider({400, 660, 200, 20}, "Phase 2", rl.TextFormat("%.2f", curve2.phase), &curve2.phase, 0, 2*math.PI)
        }

        if show_3 {
            rl.DrawRectangle(640, 580, 300, 120, {0, 0, 255, 100})
            rl.GuiSlider({700, 600, 200, 20}, "Amp 3", rl.TextFormat("%.2f", curve3.amp), &curve3.amp, 0, 120)
            rl.GuiSlider({700, 630, 200, 20}, "Freq 3", rl.TextFormat("%.2f", curve3.freq), &curve3.freq, 0.05, 5)
            rl.GuiSlider({700, 660, 200, 20}, "Phase 3", rl.TextFormat("%.2f", curve3.phase), &curve3.phase, 0, 2*math.PI)
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}
