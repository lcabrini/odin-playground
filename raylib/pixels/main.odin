package main

import rl "vendor:raylib"

/*
    Lightly inspired by graphdemo that demonstrated the graph unit which came
    with Turbo Pascal back in the days when the world was young.
*/

WORKBENCH_BLUE :: rl.Color{0, 85, 169, 255}

WIDTH :: 1024
HEIGHT :: 748
TITLE :: "Pixels"

HUD_HEIGHT :: 100
HUD_SPEED :: 3

SMALL_CHANGE :: 1
MEDIUM_CHANGE :: 10
LARGE_CHANGE :: 30
MAX_PIXELS_PER_FRAME :: 500

FONT_SIZE :: 20
BLINK_CYCLE :: 140

Hud :: struct {
    draw: bool,
    current_height: i32,
    color: rl.Color,
    image: rl.Image
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    image := rl.LoadImageFromScreen()
    rl.SetTargetFPS(60)

    hud := Hud{false, 0, WORKBENCH_BLUE, rl.GenImageColor(WIDTH, HUD_HEIGHT, WORKBENCH_BLUE)}
    pixels_per_frame := 1
    should_clear_screen := true
    paused := false
    pause_blink_counter := 0
    use_red := true
    use_green := true
    use_blue := true

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.H) {
            hud.draw = !hud.draw
        }

        if rl.IsKeyPressed(.UP) {
            inc := SMALL_CHANGE
            if rl.IsKeyDown(.LEFT_SHIFT) {
                inc = MEDIUM_CHANGE
            } else if rl.IsKeyDown(.LEFT_CONTROL) {
                inc = LARGE_CHANGE
            }

            pixels_per_frame += inc
        }

        if rl.IsKeyPressed(.DOWN) {
            dec := SMALL_CHANGE
            if rl.IsKeyDown(.LEFT_SHIFT) {
                dec = MEDIUM_CHANGE
            } else if rl.IsKeyDown(.LEFT_CONTROL) {
                dec = LARGE_CHANGE
            }

            pixels_per_frame -= dec
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

        if rl.IsKeyPressed(.C) {
            should_clear_screen = true
        }

        if rl.IsKeyPressed(.P) {
            paused = !paused
        }

        if pixels_per_frame < 1 do pixels_per_frame = 1
        if pixels_per_frame > MAX_PIXELS_PER_FRAME do pixels_per_frame = MAX_PIXELS_PER_FRAME

        if hud.draw && hud.current_height < HUD_HEIGHT {
            hud.current_height += HUD_SPEED
        }

        if !hud.draw && hud.current_height > 0 {
            hud.current_height -= HUD_SPEED
        }

        if hud.current_height > HUD_HEIGHT do hud.current_height = HUD_HEIGHT

        if paused {
            pause_blink_counter += 1
            if pause_blink_counter > BLINK_CYCLE do pause_blink_counter = 0
        }

        rl.BeginDrawing()

        if should_clear_screen {
            rl.ImageClearBackground(&image, rl.BLACK)
            should_clear_screen = false
        }

        if !paused {
            for i in 0..<pixels_per_frame {
                x := rl.GetRandomValue(0, WIDTH-1)
                y := rl.GetRandomValue(0, HEIGHT-1)
                r := use_red ? rl.GetRandomValue(0, 255) : 0
                g := use_green ? rl.GetRandomValue(0, 255) : 0
                b := use_blue ? rl.GetRandomValue(0, 255) : 0
                rl.ImageDrawPixel(&image, x, y, {u8(r), u8(g), u8(b), 255})
            }
        }

        rl.ImageClearBackground(&hud.image, WORKBENCH_BLUE)
        text := rl.TextFormat("Pixels per frame: %03d", pixels_per_frame)
        rl.ImageDrawText(&hud.image, text, 10, 10, FONT_SIZE, rl.RAYWHITE)

        if paused && pause_blink_counter < BLINK_CYCLE / 2 {
            x := WIDTH / 2 - rl.MeasureText("PAUSED", FONT_SIZE)
            rl.ImageDrawText(&hud.image, "PAUSED", x, 10, FONT_SIZE, rl.RAYWHITE)
        }

        rl.ImageDrawRectangle(&hud.image, WIDTH - 66, 10, 56, 20, rl.RAYWHITE)
        if use_red do rl.ImageDrawRectangle(&hud.image, WIDTH - 64, 12, 16, 16, rl.RED)
        if use_green do rl.ImageDrawRectangle(&hud.image, WIDTH - 46, 12, 16, 16, rl.GREEN)
        if use_blue do rl.ImageDrawRectangle(&hud.image, WIDTH - 28, 12, 16, 16, rl.BLUE)
        texture := rl.LoadTextureFromImage(image)
        rl.DrawTexture(texture, 0, 0, rl.RAYWHITE)

        hud_texture: rl.Texture
        loaded_hud_texture := false
        if hud.draw || (!hud.draw && hud.current_height > 0) {
            loaded_hud_texture = true
            hud_texture = rl.LoadTextureFromImage(hud.image)
            src_rect := rl.Rectangle{0, f32(HUD_HEIGHT-hud.current_height), WIDTH, f32(hud.current_height)}
            dest_rect := rl.Rectangle{0, 0, WIDTH, f32(hud.current_height)}
            rl.DrawTexturePro(hud_texture, src_rect, dest_rect, {0, 0}, 0.0, rl.RAYWHITE )
        }

        rl.EndDrawing()
        rl.UnloadTexture(texture)
        if loaded_hud_texture do rl.UnloadTexture(hud_texture)
    }

    rl.UnloadImage(image)
    rl.CloseWindow()
}