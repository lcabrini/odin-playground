package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Image Stripes"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    fn := strings.clone_to_cstring(os.args[1])
    texture := rl.LoadTexture(fn)

    d: i32 = 0
    a := f32(2*texture.width)

    for !rl.WindowShouldClose() {
        d += 2
        if d % 180 == 0 {
            a *= 0.8
            if a < 2 do a = 0
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for y: i32 = 0; y < texture.height; y += 8 {
            r: f32 = (f32(d + (y % 16 == 0 ? 0 : 180))) * rl.DEG2RAD
            x := f32(MIDX - texture.width/2) + a * math.sin(r)

            rl.DrawTexturePro(texture, {0, f32(y), f32(texture.width), 8}, {x, MIDY - f32(texture.height / 2) + f32(y), f32(texture.width), 8}, 0, 0, rl.WHITE)
        }

        rl.EndDrawing()
    }

    rl.UnloadTexture(texture)
    rl.CloseWindow()
}