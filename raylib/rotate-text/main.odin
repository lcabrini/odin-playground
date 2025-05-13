package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Rotate Text"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

FONT_SIZE :: 72
FONT_SPACING :: 1

main :: proc() {
    text := cstring("Hellope!")

    if len(os.args[1:]) > 1 {
        fmt.eprintfln("usage: %s [text]", os.args[0])
        os.exit(1)
    }

    if len(os.args[1:]) == 1 {
        text = strings.clone_to_cstring(os.args[1])
    }

    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    font := rl.LoadFontEx("../../resources/Orbitron-Black.ttf", FONT_SIZE, nil, 0)
    rot: f32 = 0.0

    //text := cstring("Hellope!")

    spacing := f32(2)
    ts := rl.MeasureTextEx(font, text, FONT_SIZE, FONT_SPACING)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        x := MIDX + MIDX * math.sin(rot * rl.DEG2RAD)

        for trail_rot := f32(15); trail_rot > 0; trail_rot -= 1 {
            c := u8(150 - trail_rot * 10)
            rl.DrawTextPro(font, text, {x, MIDY}, {ts.x/2, ts.y/2}, rot+trail_rot, FONT_SIZE, FONT_SPACING, {c, c, c, 255})
        }

        rl.DrawTextPro(font, text, {x, MIDY}, {ts.x/2, ts.y/2}, rot, FONT_SIZE, FONT_SPACING, rl.RAYWHITE)

        rl.EndDrawing()

        rot -= 2
    }

    rl.UnloadFont(font)
    rl.CloseWindow()
}