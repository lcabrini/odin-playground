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
    left: rl.Vector2,
    right: rl.Vector2,
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
        snake[0].left.x = snake[0].pos.x + snake[0].r * math.cos(snake[0].a-math.PI/2)
        snake[0].left.y = snake[0].pos.y + snake[0].r * math.sin(snake[0].a-math.PI/2)
        snake[0].right.x = snake[0].pos.x + snake[0].r * math.cos(snake[0].a+math.PI/2)
        snake[0].right.y = snake[0].pos.y + snake[0].r * math.sin(snake[0].a+math.PI/2)

        for i := 1; i < len(snake); i += 1 {
            snake[i].a = math.atan2(snake[i-1].pos.y-snake[i].pos.y, snake[i-1].pos.x-snake[i].pos.x)
            d := math.sqrt(math.pow(snake[i-1].pos.y-snake[i].pos.y, 2) + math.pow(snake[i-1].pos.x - snake[i].pos.x, 2))
            if d > 20 {
                delta := d - 20
                snake[i].pos.x += delta * math.cos(snake[i].a)
                snake[i].pos.y += delta * math.sin(snake[i].a)
                snake[i].left.x = snake[i].pos.x + snake[i].r * math.cos(snake[i].a-math.PI/2)
                snake[i].left.y = snake[i].pos.y + snake[i].r * math.sin(snake[i].a-math.PI/2)
                snake[i].right.x = snake[i].pos.x + snake[i].r * math.cos(snake[i].a+math.PI/2)
                snake[i].right.y = snake[i].pos.y + snake[i].r * math.sin(snake[i].a+math.PI/2)
            }
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for joint, i in snake {
            if i == 0 {
                rl.DrawCircleSector(joint.pos, joint.r+1, (joint.a - math.PI/2)*rl.RAD2DEG, (joint.a + math.PI/2)*rl.RAD2DEG, 50, rl.WHITE)
                rl.DrawCircleSector(joint.pos, joint.r+2, (joint.a - math.PI/2)*rl.RAD2DEG, (joint.a + math.PI/2)*rl.RAD2DEG, 50, rl.WHITE)
            }
                
            rl.DrawCircleV(joint.pos, joint.r, rl.GREEN)

            /* TODO: must be a better way to do this. */
            if i > 1 {
                x := snake[i-1].pos.x + snake[i-1].r * math.cos(snake[i-1].a)
                y := snake[i-1].pos.y + snake[i-1].r * math.sin(snake[i-1].a) 
                rl.DrawLineEx(joint.pos, {x, y}, joint.r*2-1, rl.GREEN)
            }

            if i > 0 {
                rl.DrawLineEx({snake[i-1].left.x, snake[i-1].left.y}, {joint.left.x, joint.left.y}, 2, rl.WHITE)
                rl.DrawLineEx({snake[i-1].right.x, snake[i-1].right.y}, {joint.right.x, joint.right.y}, 2, rl.WHITE)
            }

        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}
