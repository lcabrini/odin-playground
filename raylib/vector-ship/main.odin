package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Vector Ship"
MIDX :: WIDTH/2
MIDY :: HEIGHT/2

ACC :: 0.1
ROT_SPEED :: 5
MAX_SPEED :: 20

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
        if rl.IsKeyDown(.LEFT) do ship.a -= ROT_SPEED
        if rl.IsKeyDown(.RIGHT) do ship.a += ROT_SPEED
        if rl.IsKeyDown(.UP) {
            x := ACC * math.cos(ship.a*rl.DEG2RAD)
            y := ACC * math.sin(ship.a*rl.DEG2RAD)
            ship.v += {x, y}
        }

        if ship.v.x > MAX_SPEED do ship.v.x = MAX_SPEED
        if ship.v.y > MAX_SPEED do ship.v.y = MAX_SPEED
        if ship.v.x < -MAX_SPEED do ship.v.x = -MAX_SPEED
        if ship.v.y < -MAX_SPEED do ship.v.y = -MAX_SPEED

        ship.pos += ship.v

        if ship.pos.x > WIDTH do ship.pos.x = ship.pos.x - WIDTH
        if ship.pos.x < 0 do ship.pos.x = WIDTH + ship.pos.x
        if ship.pos.y > HEIGHT do ship.pos.y = ship.pos.y - HEIGHT
        if ship.pos.y < 0 do ship.pos.y = HEIGHT + ship.pos.y

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
