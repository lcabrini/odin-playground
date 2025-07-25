package main

import "core:math/rand"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Teleport"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

Pixel :: struct {
    pos: rl.Vector2,
    dest: rl.Vector2,
    color: rl.Color,
    speed: f32,
}

main :: proc() {
    rl.SetConfigFlags(({.VSYNC_HINT}))
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    fn := strings.clone_to_cstring(os.args[1])
    image := rl.LoadImage(fn)
    colors := rl.LoadImageColors(image)
    pixels: [dynamic]Pixel
    iw := image.width
    ih := image.height

    for i: i32 = 0; i < iw*ih; i += 1 {
        if colors[i] == rl.BLACK do continue

        pixel := Pixel{}
        pixel.pos = {f32(i % iw) + 50, f32(i / iw) + 50}
        pixel.dest = {f32(WIDTH - iw - 100) + pixel.pos.x, pixel.pos.y}
        pixel.color = colors[i]
        pixel.speed = 30
        append(&pixels, pixel)
    }

    rl.UnloadImageColors(colors)
    rl.UnloadImage(image)
    target := rl.LoadRenderTexture(WIDTH, HEIGHT)

    rand.shuffle(pixels[:])
    last_idx := 0
    index_incr: f32 = 2

    for !rl.WindowShouldClose() {
        last_idx += int(index_incr)
        if last_idx > len(pixels) {
            last_idx = len(pixels)
            index_incr = 0
        }
        index_incr *= 1.9

        for &pixel in pixels [:last_idx] {
            pixel.pos.x += pixel.speed
            if pixel.pos.x > pixel.dest.x do pixel.pos.x = pixel.dest.x
        }

        rl.BeginTextureMode(target)
        rl.ClearBackground(rl.BLACK)
        for pixel in pixels {
            rl.DrawPixelV(pixel.pos, pixel.color)
        }
        rl.EndTextureMode()

        rl.BeginDrawing()
        rl.DrawTextureRec(target.texture, {0, 0, WIDTH, -HEIGHT}, {0, 0}, rl.WHITE)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
