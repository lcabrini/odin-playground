package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Spiral"
MIDX :: WIDTH/2
MIDY :: HEIGHT/2
RADIUS :: 50

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    counter := 0
    start_color := 0
    start_idx := 0
    colors := []rl.Color {
        {0, 0, 255, 255},
        {0, 255, 255, 255},
    }

    for !rl.WindowShouldClose() {
        counter += 1
        if counter > 3000 {
            counter = 3000
            start_color += 1
            if start_color % 50 == 0 do start_idx = 1 - start_idx
        }

        color_counter := start_color
        color_idx := start_idx

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
    
        for i := 0; i < counter; i += 1 {
            angle := f32(i)/2
            amp := f32(i)/6
            x: f32 = MIDX + amp * math.cos(angle * rl.DEG2RAD)
            y: f32 = MIDY + amp * math.sin(angle * rl.DEG2RAD)
            rl.DrawCircleV({x, y}, RADIUS, colors[color_idx])
            color_counter += 1
            if color_counter % 50 == 0 do color_idx = 1 - color_idx
        }

        rl.EndDrawing()
    }   

    rl.CloseWindow()
}
