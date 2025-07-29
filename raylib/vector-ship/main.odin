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

Bullet :: struct {
    pos: rl.Vector2,
    v: rl.Vector2,
    counter: int,
}

main :: proc() {
    rl.SetTraceLogLevel(.ERROR)
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    ship := Ship{}
    ship.pos = {MIDX, MIDY}
    ship.r = 20
    bullets: [dynamic]Bullet

    for !rl.WindowShouldClose() {
        if rl.IsKeyDown(.LEFT) do ship.a -= ROT_SPEED
        if rl.IsKeyDown(.RIGHT) do ship.a += ROT_SPEED
        if rl.IsKeyDown(.UP) {
            x := ACC * math.cos(ship.a*rl.DEG2RAD)
            y := ACC * math.sin(ship.a*rl.DEG2RAD)
            ship.v += {x, y}
        }

        if rl.IsKeyPressed(.SPACE) {
            bullet := Bullet{}
            bullet.pos.x = ship.pos.x + ship.r * math.cos(ship.a*rl.DEG2RAD)
            bullet.pos.y = ship.pos.y + ship.r * math.sin(ship.a*rl.DEG2RAD)
            bullet.v.x = ship.v.x + 5 * math.cos(ship.a*rl.DEG2RAD)
            bullet.v.y = ship.v.y + 5 * math.sin(ship.a*rl.DEG2RAD)
            bullet.counter = 300
            append(&bullets, bullet)
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

        for &bullet, i in bullets {
            bullet.counter -= 1
            if bullet.counter < 0 do unordered_remove(&bullets, i)

            bullet.pos += bullet.v
            if bullet.pos.x > WIDTH do bullet.pos.x = bullet.pos.x - WIDTH
            if bullet.pos.x < 0 do bullet.pos.x = WIDTH + bullet.pos.x
            if bullet.pos.y > HEIGHT do bullet.pos.y = bullet.pos.y - HEIGHT
            if bullet.pos.y < 0 do bullet.pos.y = HEIGHT + bullet.pos.y
        }

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

        for bullet in bullets {
            cv := bullet.counter > 20 ? 255 : u8(bullet.counter * 12)
            rl.DrawCircleV(bullet.pos, 1, {cv, cv, cv, 255})
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}
