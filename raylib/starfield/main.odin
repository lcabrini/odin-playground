package main

import rl "vendor:raylib"

/*
    This version is based off https://github.com/GeorgeGally/creative_coding/blob/master/part9c.html
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Starfield"
MIDX :: WIDTH/2
MIDY :: HEIGHT/2
FOV :: 250

Star :: struct {
    pos: rl.Vector3,
    pos3d: rl.Vector2,
    scale: f32,
    speed: f32,
    color: f32,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.SetTraceLogLevel(.ERROR)
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    stars: [dynamic]Star

    for !rl.WindowShouldClose() {
        for i in 0..<10 {
            append(&stars, init_star())
        }

        for &star, i in stars {
            star.color += 1.5
            if star.color > 255 do star.color = 255
            star.pos.z -= star.speed
            star.scale = FOV / (star.pos.z+FOV)
            star.pos3d.x = star.pos.x * star.scale
            star.pos3d.y = star.pos.y * star.scale
            if (star.pos.z < -FOV) do unordered_remove(&stars, i)
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        for star in stars {
            rl.DrawCircleV({star.pos3d.x + MIDX, star.pos3d.y + MIDY}, star.scale/4, {u8(star.color), u8(star.color), u8(star.color), 255})
        }
        rl.EndDrawing()
    }

    rl.CloseWindow()
}

init_star :: proc() -> Star {
    star := Star{}
    star.pos.x = f32(rl.GetRandomValue(-100, 100))
    star.pos.y = f32(rl.GetRandomValue(-100, 100))
    star.pos.z = 10 
    star.pos3d = {0, 0}
    star.scale = 1
    star.speed = 2
    star.color = 0
    return star
}
