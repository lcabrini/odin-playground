/*
    Inspired by a program that demonstrated the Turbo Pascal graph unit
*/

package main

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Random Rectangles"
MAX_RECTS_PER_FRAME :: 200
SMALL_CHANGE :: 1
BIG_CHANGE :: 10

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.SetTraceLogLevel(.ERROR)
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    target := rl.LoadRenderTexture(WIDTH, HEIGHT)

    rectangles_per_frame := 1
    paused := false
    clear := true
    fill := false
    use_red := true
    use_green := true
    use_blue := true

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.P) {
            paused = !paused
        }

        if !paused {
            if rl.IsKeyPressed(.LEFT) do rectangles_per_frame -= SMALL_CHANGE
            if rl.IsKeyPressed(.RIGHT) do rectangles_per_frame += SMALL_CHANGE
            if rl.IsKeyPressed(.UP) do rectangles_per_frame += BIG_CHANGE
            if rl.IsKeyPressed(.DOWN) do rectangles_per_frame -= BIG_CHANGE

            if rectangles_per_frame < 1 do rectangles_per_frame = 1
            if rectangles_per_frame > MAX_RECTS_PER_FRAME do rectangles_per_frame = MAX_RECTS_PER_FRAME

            if rl.IsKeyPressed(.C) {
                clear = true
            }

            if rl.IsKeyPressed(.F) {
                fill = !fill
            }

            if rl.IsKeyPressed(.R) {
                use_red = !use_red
            }

            if rl.IsKeyPressed(.G) {
                use_green = !use_green
            }

            if rl.IsKeyPressed(.B) {
                use_blue = !use_blue
            }

            rl.BeginTextureMode(target)
            x := rl.GetRandomValue(0, WIDTH-1)
            y := rl.GetRandomValue(0, HEIGHT-1)
            w := rl.GetRandomValue(1, WIDTH-x)
            h := rl.GetRandomValue(1, HEIGHT-y)
            r := use_red ? u8(rl.GetRandomValue(0, 255)) : 0
            g := use_green ? u8(rl.GetRandomValue(0, 255)) : 0
            b := use_blue ? u8(rl.GetRandomValue(0, 255)) : 0

            for i in 0..<rectangles_per_frame {
                if fill {
                    rl.DrawRectangle(x, y, w, h, {r, g, b, 255})
                } else {
                    rl.DrawRectangleLines(x, y, w, h, {r, g, b, 255})
                }
            }

            if clear {
                rl.ClearBackground(rl.BLACK)
                clear = false
            }

            rl.EndTextureMode()
        }

        rl.BeginDrawing()
        rl.DrawTexture(target.texture, 0, 0, rl.WHITE)
        rl.EndDrawing()
    }

    rl.UnloadRenderTexture(target)
    rl.CloseWindow()
}
