package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 786
TITLE :: "Camera"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    texture := rl.LoadTexture("../../resources/blue-galaxy.jpg")
    pos := rl.Vector2{MIDX, MIDY}
    v := rl.Vector2{1, 2}

    rl.InitAudioDevice()
    music := rl.LoadMusicStream("../../resources/calm-space.mp3")
    rl.PlayAudioStream(music)

    for !rl.WindowShouldClose() {
        rl.UpdateMusicStream(music)
        t := f32(rl.GetTime())
        pos += v

        x_offset: f32 = WIDTH / 2
        if pos.x < WIDTH / 2 {
            v.x *= -1
            x_offset = pos.x
        }
        if pos.x > f32(texture.width) - WIDTH / 2 {
            v.x *= -1
            x_offset = pos.x - f32(texture.width) + WIDTH
        }

        y_offset: f32 = HEIGHT / 2
        if pos.y < HEIGHT / 2 {
            v.y *= -1
            y_offset = pos.y
        }
        if pos.y > f32(texture.height) - HEIGHT / 2 {
            v.y *= -1
            y_offset = pos.y - f32(texture.height) + HEIGHT
        }


        camera := rl.Camera2D{}
        camera.zoom = 1
        camera.offset = {x_offset, y_offset}
        camera.target = pos

        rl.BeginDrawing()
        rl.BeginMode2D(camera)
        rl.DrawTexture(texture, 0, 0, rl.WHITE)

        for i: f32 = -5; i <= 5; i += 1 {
            x := pos.x + f32(i * 50)
            y := math.sin(t+(i+2)*0.3) * 300 +  pos.y
            rl.DrawCircleV({x, y}, 32, {150, 100, 0, 100})
            rl.DrawCircleV({x, y}, 30, {255, 150 + u8(i) * 10, 0, 100})
        }

        rl.EndMode2D()
        rl.EndDrawing()
    }

    rl.UnloadTexture(texture)
    rl.UnloadMusicStream(music)
    rl.CloseAudioDevice()
    rl.CloseWindow()
}

