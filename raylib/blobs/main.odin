package main

import "core:fmt"
import "core:math"
import "core:math/rand"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Blob"
MIDX :: WIDTH/2
MIDY :: HEIGHT/2

Blob :: struct {
    scale: rl.Vector2,
    speed: f32,
    pos: rl.Vector2,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    image := rl.LoadImageFromScreen()
    blobs: [5]Blob
    for i := 0; i < len(blobs); i += 1 {
        blob := Blob{}
        blob.scale.x = rand.float32() * 0.3
        blob.scale.y = rand.float32() * 0.3
        blob.speed = rand.float32() * math.PI * 16 - math.PI * 8
        blob.pos = {0, 0}
        blobs[i] = blob
    }

    for !rl.WindowShouldClose() {
        shift: f32 = 0
        time := f32(rl.GetTime()) * 0.03

        for &b in blobs {
            b.pos.x = math.sin((time+shift) * math.PI * b.speed) * WIDTH * b.scale.x + MIDX
            b.pos.y = math.cos((time+shift) * math.PI * b.speed) * HEIGHT * b.scale.y + MIDY
            shift += 0.5
        }

        for y: i32 = 0; y < HEIGHT; y += 1 {
            for x: i32 = 0; x < WIDTH; x += 1 {
                dsq: f32 = 1

                for &b in blobs {
                    xsq: f32 = (f32(x) - b.pos.x) * (f32(x) - b.pos.x)
                    ysq: f32 = (f32(y) - b.pos.y) * (f32(y) - b.pos.y)
                    dsq *= math.sqrt(xsq + ysq)
                }

                col := u8(math.max(math.min(math.floor(1024 - (dsq / 3e8)), 255), 0))
                rl.ImageDrawPixel(&image, x, y, {col, col, col, 255}) 
            }
        }

        texture := rl.LoadTextureFromImage(image)
        rl.BeginDrawing()
        rl.DrawTexture(texture, 0, 0, rl.WHITE)
        rl.EndDrawing()
        rl.UnloadTexture(texture)
    }

    rl.UnloadImage(image)
    rl.CloseWindow()
}
