package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Line Play"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

SHADOW_X :: 100
SHADOW_Y :: 100
SHADOW_THICKNESS :: 10

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    texture := rl.LoadTexture("../../resources/texture-bg.jpg")
    a: f32 = 1.1
    b: f32 = 2.3
    c: f32 = 1.5
    d: f32 = 0.7

    for !rl.WindowShouldClose() {
        t : = f32(rl.GetTime() * 0.8)

        rl.BeginDrawing()
        rl.DrawTexture(texture, 0, 0, rl.WHITE)

         for i: f32 = 0; i < 30; i += 1 {
            x1 := MIDX + 500 * math.sin(t/a + i*0.07)
            y1 := MIDY + 300 * math.sin(t/b + i*0.07)
            x2 := MIDX + 500 * math.cos(t/c + i*0.07)
            y2 := MIDY + 300 * math.cos(t/d + i*0.07)

            rl.DrawLineEx({x1+SHADOW_X, y1+SHADOW_Y}, {x2+SHADOW_X, y2+SHADOW_Y}, SHADOW_THICKNESS, {0, 0, 0, 100})
        }

        for i: f32 = 0; i < 30; i += 1 {
            x1 := MIDX + 500 * math.sin(t/a + i*0.07)
            y1 := MIDY + 300 * math.sin(t/b + i*0.07)
            x2 := MIDX + 500 * math.cos(t/c + i*0.07)
            y2 := MIDY + 300 * math.cos(t/d + i*0.07)

            rl.DrawLineV({x1, y1}, {x2, y2}, rl.YELLOW)
        }

        rl.EndDrawing()
    }

    rl.UnloadTexture(texture)
    rl.CloseWindow()
}