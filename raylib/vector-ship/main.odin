package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Vector Ship"
MIDX :: WIDTH/2
MIDY :: HEIGHT/2

Ship :: struct {
    pos: rl.Vector2,
    v: rl.Vector2,
    a: f32,
    r: f32,
}

main :: proc() {
    rl.SetTraceLogLevel(.ERROR)
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    ship := Ship{}
    ship.pos = {MIDX, MIDY}
    ship.r = 20

    for !rl.WindowShouldClose() {
        if rl.IsKeyDown(.LEFT) do ship.a -= 1
        if rl.IsKeyDown(.RIGHT) do ship.a += 1
        
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        {
            x1 := ship.pos.x + ship.r * math.cos(ship.a*rl.DEG2RAD)
            y1 := ship.pos.y + ship.r * math.sin(ship.a*rl.DEG2RAD)
            x2 := ship.pos.x + ship.r * math.cos((ship.a-150)*rl.DEG2RAD)
            y2 := ship.pos.y + ship.r * math.sin((ship.a-150)*rl.DEG2RAD)
            x3 := ship.pos.x + ship.r * math.cos((ship.a-210)*rl.DEG2RAD)
            y3 := ship.pos.y + ship.r * math.sin((ship.a-210)*rl.DEG2RAD)
            rl.DrawTriangleLines({x1, y1}, {x2, y2}, {x3, y3}, rl.WHITE)
        }
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
