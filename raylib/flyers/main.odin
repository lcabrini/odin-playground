package main

import "core:math"
import "core:math/rand"
import rl "vendor:raylib"

/*
    Adapted from https://happycoding.io/tutorials/processing/creating-classes/flyers
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Flyers"

TWO_PI :: 2 * math.PI

Flyer :: struct {
    x: f32,
    y: f32,
    heading: f32,
    speed: f32,
    radius: f32,
    fill: rl.Color,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    flyers: [10]Flyer
    for &flyer in flyers {
        flyer.x = f32(rl.GetRandomValue(0, WIDTH))
        flyer.y = f32(rl.GetRandomValue(0, HEIGHT))
        flyer.heading = rand.float32_range(-math.PI, math.PI)
        flyer.speed = f32(rl.GetRandomValue(3, 6))
        flyer.radius = f32(rl.GetRandomValue(5, 20))
        flyer.fill = rl.Color{u8(rl.GetRandomValue(0, 255)), u8(rl.GetRandomValue(0, 255)), u8(rl.GetRandomValue(0, 255)), 255}
    }

    for !rl.WindowShouldClose() {
        mp := rl.GetMousePosition()
        for i := 0; i < len(flyers); i += 1 {
            angleToMouse := math.atan2(mp.y-flyers[i].y, mp.x-flyers[i].x)

            if flyers[i].heading - angleToMouse > math.PI {
                angleToMouse += TWO_PI
            } else if angleToMouse - flyers[i].heading > math.PI {
                angleToMouse -= TWO_PI
            }

            if flyers[i].heading < angleToMouse {
                flyers[i].heading += math.PI/50
            } else {
                flyers[i].heading -= math.PI/50
            }

            flyers[i].x += math.cos(flyers[i].heading) * flyers[i].speed
            flyers[i].y += math.sin(flyers[i].heading) * flyers[i].speed

            if flyers[i].x < 0 do flyers[i].x = WIDTH
            if flyers[i].x > WIDTH do flyers[i].x = 0
            if flyers[i].y < 0 do flyers[i].y = HEIGHT
            if flyers[i].y > HEIGHT do flyers[i].y = 0
        }



        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for flyer in flyers {
            rl.DrawCircleV({flyer.x, flyer.y}, flyer.radius+2, rl.RAYWHITE)
            rl.DrawCircleV({flyer.x, flyer.y}, flyer.radius, flyer.fill)
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}