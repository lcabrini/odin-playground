package main

import "core:fmt"
import "core:math"
import "core:math/rand"
import rl "vendor:raylib"


/* 
    Adapted from the Metablob effect on https://seancode.com/demofx/
*/

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

    target := rl.LoadRenderTexture(WIDTH, HEIGHT)
    blobs: [5]Blob
    for i := 0; i < len(blobs); i += 1 {
        blob := Blob{}
        blob.scale.x = rand.float32() * 0.3
        blob.scale.y = rand.float32() * 0.3
        blob.speed = rand.float32() * math.PI * 16 - math.PI * 8
        blob.pos = {0, 0}
        blobs[i] = blob
    }
    
    use_r := true
    use_g := true
    use_b := true
    paused := false
    time: f32 = 0

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.P) {
            paused = !paused
        }

        if rl.IsKeyPressed(.S) {
            rl.TakeScreenshot("screenshot.png")
        }

        if !paused {
            if rl.IsKeyPressed(.R) {
                use_r = !use_r
            }

            if rl.IsKeyPressed(.G) {
                use_g = !use_g
            }

            if rl.IsKeyPressed(.B) {
                use_b = !use_b
            }

            shift: f32 = 0
            time += rl.GetFrameTime() * 0.04

            for &b in blobs {
                b.pos.x = math.sin((time+shift) * math.PI * b.speed) * WIDTH * b.scale.x + MIDX
                b.pos.y = math.cos((time+shift) * math.PI * b.speed) * HEIGHT * b.scale.y + MIDY
                shift += 0.5
            }

            rl.BeginTextureMode(target)
            rl.ClearBackground(rl.BLACK)
            for y: i32 = 0; y < HEIGHT; y += 1 {
                for x: i32 = 0; x < WIDTH; x += 1 {
                    dsq: f32 = 1

                    for &b in blobs {
                        xsq: f32 = (f32(x) - b.pos.x) * (f32(x) - b.pos.x)
                        ysq: f32 = (f32(y) - b.pos.y) * (f32(y) - b.pos.y)
                        dsq *= math.sqrt(xsq + ysq)
                    }

                    col := u8(math.max(math.min(math.floor(1024 - (dsq / 3e8)), 255), 0))
                    r := use_r ? col : 0
                    g := use_g ? col : 0
                    b := use_b ? col : 0
                    rl.DrawPixel(x, y, {r, g, b, 255}) 
                }
            }

            rl.EndTextureMode()
        }

        rl.BeginDrawing()
        rl.DrawTextureRec(target.texture, {0, 0, WIDTH, -HEIGHT}, {0, 0} , rl.WHITE)
        rl.EndDrawing()
    }

    rl.UnloadRenderTexture(target)
    rl.CloseWindow()
}
