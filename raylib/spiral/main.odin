package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Spiral"
MIDX :: WIDTH/2
MIDY :: HEIGHT/2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    counter := 1
    start_color := 1

    for !rl.WindowShouldClose() {
        counter += 1
        //start_color += 1
        if counter > 3000 do counter = 3000
        color_counter := start_color
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
    
        for i := 0; i < counter; i += 1 {
            angle := f32(i)/2
            amp := f32(i)/6
            x: f32 = MIDX + amp * math.cos(angle * rl.DEG2RAD)
            y: f32 = MIDY + amp * math.sin(angle * rl.DEG2RAD)
            origin := rl.Vector2{20, 20}
            color: rl.Color = color_counter % 2 == 0 ? {0, 0, 255, 255} : {0, 255, 255, 255}
            rl.DrawRectanglePro({x, y, 40, 40}, origin, 0, color)
            if i % 50 == 0 do color_counter += 1
        }

        rl.EndDrawing()
    }   

    rl.CloseWindow()
}
