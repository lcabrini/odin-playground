package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

/*
   Implementation of https://www.youtube.com/watch?v=-kvel_C28aI using Odin+Raylib
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Fractal Tree"
MIDX :: WIDTH/2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.SetTraceLogLevel(.ERROR)
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        a := math.abs(rl.GetMousePosition().x - MIDX) / 10
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        draw_branch({MIDX, HEIGHT-1}, 200, 0, a)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}

draw_branch :: proc(origin: rl.Vector2, length, dir, da: f32) {
    x := origin.x + length * math.sin(dir*rl.DEG2RAD)
    y := origin.y - length * math.cos(dir*rl.DEG2RAD)
    thickness := length / 10
    color := length > 3 ? rl.BROWN : rl.GREEN
    rl.DrawLineEx(origin, {x, y}, thickness, color)
    if length > 2 {
        draw_branch({x, y}, length*3/4, dir+da, da)
        draw_branch({x, y}, length*3/4, dir-da, da)
    }
}
