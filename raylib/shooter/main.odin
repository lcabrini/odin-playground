package main

import rl "vendor:raylib"

/*
    I wrote this to solve some offset issues I had with my zombie shooter game.
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Shooter"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

SPEED :: 300
ROT_SPEED :: 250
BULLET_SPEED :: 500
HEAD_MIDX :: 16

Player :: struct {
    pos: rl.Vector2,
    rot: f32,
    barrel_offset: rl.Vector2,
}

Bullet :: struct {
    pos: rl.Vector2,
    v: rl.Vector2,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)

    player_texture := rl.LoadTexture("../../resources/soldier1_gun.png")
    pw, ph := f32(player_texture.width), f32(player_texture.height)
    bullet_texture := rl.LoadTexture("../../resources/bullet.png")
    bw, bh := f32(bullet_texture.width), f32(bullet_texture.height)

    player: Player
    player.pos = {MIDX, MIDY}
    player.rot = 0.0
    player.barrel_offset = {30, 9.5}

    bullet: Bullet
    bullet_fired := false

    for !rl.WindowShouldClose() {
        rot_speed: f32 = 0.0

        if rl.IsKeyDown(.LEFT) {
            rot_speed = -ROT_SPEED
        }

        if rl.IsKeyDown(.RIGHT) {
            rot_speed = ROT_SPEED
        }

        if rl.IsKeyDown(.SPACE) && !bullet_fired {
            bullet_fired = true
            bullet.pos = player.pos + rl.Vector2Rotate(player.barrel_offset, player.rot * rl.DEG2RAD)
            bullet.v = rl.Vector2Rotate({BULLET_SPEED, 0}, player.rot * rl.DEG2RAD)
        }

        player.rot += rot_speed * rl.GetFrameTime()
        if player.rot > 360 {
            player.rot -= 360
        }

        if player.rot < -360 {
            player.rot += 360
        }

        if bullet_fired {
            bullet.pos += bullet.v * rl.GetFrameTime()

            if bullet.pos.x < 0 || bullet.pos.x > WIDTH {
                bullet_fired = false
            } else if bullet.pos.y < 0 || bullet.pos.y > HEIGHT {
                bullet_fired = false
            }

        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        rl.DrawCircle(MIDX, MIDY, 50, rl.BLUE)

        if bullet_fired {
            src := rl.Rectangle{0, 0, bw, bh}
            dest := rl.Rectangle{bullet.pos.x, bullet.pos.y, bw, bh}
            origin := rl.Vector2{bw / 2, bh / 2}
            rl.DrawTexturePro(bullet_texture, src, dest, origin, 0, rl.RAYWHITE)
        }

        src := rl.Rectangle{0, 0, pw, ph}
        dest := rl.Rectangle{MIDX, MIDY, pw, ph}
        origin := rl.Vector2{16, ph / 2}
        rl.DrawTexturePro(player_texture, src, dest, origin, player.rot, rl.RAYWHITE)

        rl.EndDrawing()
    }

    rl.UnloadTexture(player_texture)
    rl.UnloadTexture(bullet_texture)
    rl.CloseWindow()
}