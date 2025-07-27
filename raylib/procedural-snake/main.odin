package main

import "core:math"
import rl "vendor:raylib"

/*
   Based off https://www.youtube.com/watch?v=wFqSKHLb0lo and https://www.youtube.com/watch?v=qlfh_rv6khY
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Procedural Snake"
MIDX :: WIDTH/2
MIDY:: HEIGHT/2

Joint :: struct {
    pos: rl.Vector2,
    r: f32,
    a: f32,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.SetTraceLogLevel(.ERROR)
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    snake: [48]Joint
    for i := 0; i < len(snake); i += 1 {
        snake[i].pos = {20+20*f32(i), MIDY}
        snake[i].a = 0
        switch i {
        case 0: snake[i].r = 20
        case 1: snake[i].r = 22
        case: snake[i].r = 20 - f32(i)*(20/f32(len(snake)-1))
        }
    }

    for !rl.WindowShouldClose() {
        mp := rl.GetMousePosition()
        snake[0].a = math.atan2(mp.y-snake[0].pos.y, mp.x-snake[0].pos.x)
        snake[0].pos.x += 10 * math.cos(snake[0].a)
        snake[0].pos.y += 10 * math.sin(snake[0].a)
        for i := 1; i < len(snake); i += 1 {
            snake[i].a = math.atan2(snake[i-1].pos.y-snake[i].pos.y, snake[i-1].pos.x-snake[i].pos.x)
            d := math.sqrt(math.pow(snake[i-1].pos.y-snake[i].pos.y, 2) + math.pow(snake[i-1].pos.x - snake[i].pos.x, 2))
            if d > 20 {
                delta := d - 20
                snake[i].pos.x += delta * math.cos(snake[i].a)
                snake[i].pos.y += delta * math.sin(snake[i].a)
            }
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for joint in snake {
            rl.DrawCircleLinesV(joint.pos, joint.r, rl.WHITE)
            x := joint.pos.x + joint.r * math.cos(joint.a)
            y := joint.pos.y + joint.r * math.sin(joint.a)
            rl.DrawLineV(joint.pos, {x, y}, rl.GREEN)
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}
