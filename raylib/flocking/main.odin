package main

import "core:fmt"
import "core:math"
import "core:math/rand"
import rl "vendor:raylib"

/*
    Adapted from https://happycoding.io/tutorials/processing/creating-classes/flocking
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Flocking"

TWO_PI :: 2 * math.PI

Flocker :: struct {
    x: f32,
    y: f32,
    heading: f32,
    speed: f32,
    radius: f32,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    flockers: [10]Flocker
    for &flocker in flockers {
        flocker.x = f32(rl.GetRandomValue(0, WIDTH))
        flocker.y = f32(rl.GetRandomValue(0, HEIGHT))
        flocker.heading = rand.float32_range(-math.PI , math.PI)
        flocker.speed = f32(rl.GetRandomValue(1, 5))
        flocker.radius = f32(rl.GetRandomValue(10, 20))
    }

    for !rl.WindowShouldClose() {
        for i := 0; i < len(flockers); i += 1 {
            closest_distance: f32 = 10000000.0;
            closest_flocker: Flocker

            for j := 0; j < len(flockers); j += 1 {
                if i == j do continue

                distance := math.sqrt(math.pow(flockers[i].x - flockers[j].x, 2) + math.pow(flockers[i].y - flockers[j].y, 2))
                if distance < closest_distance {
                    closest_distance = distance
                    closest_flocker = flockers[j]
                }
            }

            angle_to_closest := math.atan2(closest_flocker.y - flockers[i].y, closest_flocker.x - flockers[i].x)

            if flockers[i].heading - angle_to_closest > math.PI {
                angle_to_closest += TWO_PI
            } else if angle_to_closest - flockers[i].heading > math.PI {
                angle_to_closest -= TWO_PI
            }

            if flockers[i].heading < angle_to_closest {
                flockers[i].heading += math.PI / 40
            } else {
                flockers[i].heading -= math.PI / 40
            }

            flockers[i].x += math.cos(flockers[i].heading) * flockers[i].speed
            flockers[i].y += math.sin(flockers[i].heading) * flockers[i].speed

            if flockers[i].x < 0 do flockers[i].x = WIDTH
            if flockers[i].x > WIDTH do flockers[i].x = 0
            if flockers[i].y < 0 do flockers[i].y = HEIGHT
            if flockers[i].y > HEIGHT do flockers[i].y = 0
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for flocker in flockers {
            rl.DrawCircleV({flocker.x, flocker.y}, flocker.radius+1, rl.WHITE)
            rl.DrawCircleV({flocker.x, flocker.y}, flocker.radius, rl.BLUE)
        }
        rl.EndDrawing()
    }

    rl.CloseWindow()
}