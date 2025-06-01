package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

/*
    Don't know what to call these things. "Bob" is short for blitter object. So bobs that make trails...?
    I wrote something similar using C and SDL2 some years ago.
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Bobtrails"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

TRAIL_SIZE :: 30

Trail :: struct {
    ampx: f32,
    ampy: f32,
    t: f32,
    len: int,
    color: rl.Color,
    adder: rl.Color,
    rot: f32,
    fade: i32,
    fade_val: i32,
    current_color: rl.Color,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    bg := rl.LoadTexture("../../resources/space-bg.png")

    trails: [7]Trail

    trails[0].t = 0
    trails[0].len = 32
    trails[0].color = {31, 31, 0, 0}
    trails[0].adder = {7, 7, 0, 0}
    trails[0].ampx = 500
    trails[0].ampy = 300
    trails[0].rot = 0
    trails[0].fade = 25

    trails[1].t = 3
    trails[1].len = 32
    trails[1].color = {31, 0, 0, 0}
    trails[1].adder = {7, 0, 0, 0}
    trails[1].ampx = 500
    trails[1].ampy = 300

    trails[2].t = 6
    trails[2].len = 32
    trails[2].color = {0, 0, 31, 0}
    trails[2].adder = {0, 0, 7, 0}
    trails[2].ampx = 500
    trails[2].ampy = 300

    trails[3].t = 0
    trails[3].len = 32
    trails[3].color = {31, 0, 31, 0}
    trails[3].adder = {7, 0, 7, 0}
    trails[3].ampx = 500
    trails[3].ampy = 300

    trails[4].t = 3
    trails[4].len = 32
    trails[4].color = {0, 31, 31, 0}
    trails[4].adder = {0, 7, 7, 0}
    trails[4].ampx = 500
    trails[4].ampy = 300

    trails[5].t = 6
    trails[5].len = 32
    trails[5].color = {0, 31, 0, 0}
    trails[5].adder = {0, 7, 0, 0}
    trails[5].ampx = 500
    trails[5].ampy = 300

    trails[6].t = 0
    trails[6].len = 32
    trails[6].color = {31, 31, 31, 0}
    trails[6].adder = {7, 7, 7, 0}
    trails[6].ampx = 500
    trails[6].ampy = 300

    index := 0
    timer := 0

    for !rl.WindowShouldClose() {
        timer += 1
        if timer % 500 == 0 {
            trails[index].fade = -2
            trails[index].fade_val = 255
            index += 1
            if index >= len(trails) do index = 0
            trails[index].fade = 2
            trails[index].fade_val = 0
        }

        rl.BeginDrawing()
        rl.DrawTexture(bg, 0, 0, rl.RAYWHITE)

        for &trail, i in trails {
            if trail.fade == 0 do continue

            trail.current_color = trail.color

            size: f32 = 10
            t := trail.t

            for idx in 0..<trail.len {
                x, y: f32

                switch i {
                    case 0:
                        a: f32 = 3
                        b: f32 = 4
                        delta: f32 = math.PI / math.PI / 1.2
                        x = MIDX + trail.ampx * math.sin(a * f32(t) + delta)
                        y = MIDY + trail.ampy * math.sin(b * f32(t))

                    case 1:
                        k: f32 = 4.3
                        x = MIDX + trail.ampx * math.cos(k * t) * math.cos(t)
                        y = MIDY - trail.ampy * math.cos(k * t) * math.sin(t)

                    case 2:
                        a: f32 = 6
                        b: f32 = 7
                        delta: f32 = 9/8 //math.PI / 2
                        x = MIDX + trail.ampx * math.sin(a * f32(t) + delta)
                        y = MIDY + trail.ampy * math.sin(b * f32(t))

                    case 3:
                        k: f32 = 6.37
                        x = MIDX + trail.ampx * math.cos(k * t) * math.cos(t)
                        y = MIDY - trail.ampy * math.cos(k * t) * math.sin(t)

                    case 4:
                        a: f32 = 3
                        b: f32 = 8
                        delta: f32 = math.PI * 3
                        x = MIDX + trail.ampx * math.sin(a * f32(t) + delta)
                        y = MIDY + trail.ampy * math.sin(b * f32(t))

                    case 5:
                        a: f32 = 6
                        b: f32 = 5
                        delta: f32 = math.PI * 2
                        x = MIDX + trail.ampx * math.sin(a * f32(t) + delta)
                        y = MIDY + trail.ampy * math.sin(b * f32(t))

                     case 6:
                        k: f32 = 7.34
                        x = MIDX + trail.ampx * math.cos(k * t) * math.cos(t)
                        y = MIDY - trail.ampy * math.cos(k * t) * math.sin(t)

                }

                rec := rl.Rectangle{x, y, size, size}
                origin := rl.Vector2{size/2, size/2}
                rl.DrawRectanglePro(rec, origin, trail.rot, trail.current_color)
                trail.current_color += trail.adder

                t += 0.01
                size += 0.7
            }

            trail.rot += 2
            trail.t += 0.01


        }

        rl.EndDrawing()

        for &trail in trails {
            if trail.fade != 0 {
                trail.fade_val += trail.fade
                if trail.fade_val > 255 do trail.fade_val = 255
                if trail.fade_val < 0 do trail.fade_val = 0
                trail.color.a = u8(trail.fade_val)
                fmt.println(trail.fade_val)
                if trail.fade_val < 1 || trail.fade_val > 255 {
                    trail.fade = 0
                }
            }
        }
    }

    rl.UnloadTexture(bg)
    rl.CloseWindow()
}
