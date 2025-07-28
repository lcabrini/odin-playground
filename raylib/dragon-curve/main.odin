/*
    Described on https://en.wikipedia.org/wiki/L-system
*/

package main

import "core:math"
import "core:strings"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Dragon Curve"
MIDX :: WIDTH/2
MIDY :: HEIGHT/2

F :: "F+G"
G :: "F-G"
ANGLE :: math.PI/2
LEN :: 3
START :: "F"

State :: struct {
    pos: rl.Vector2,
    a: f32,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.SetTraceLogLevel(.ERROR)
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    word := START

    for !rl.WindowShouldClose() {
        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) do word = generate(word)

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        draw(word)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}

draw :: proc(word: string) {
    state := State{}    
    state.pos = {MIDX, MIDY}
    state.a = 0

    for r in word {
        switch r {
        case 'F':
            x := state.pos.x + LEN * math.cos(state.a)
            y := state.pos.y + LEN * math.sin(state.a)
            rl.DrawLineV(state.pos, {x, y}, rl.WHITE)
            state.pos = {x, y}
        case 'G':
            x := state.pos.x + LEN * math.cos(state.a)
            y := state.pos.y + LEN * math.sin(state.a)
            rl.DrawLineV(state.pos, {x, y}, rl.WHITE)
            state.pos = {x, y}
        case '+':
            state.a += ANGLE
        case '-':
            state.a -= ANGLE
        }
    }
}

generate :: proc(word: string) -> string {
    b: strings.Builder
    strings.builder_init(&b, 0, len(word))

    for r in word {
        switch r {
        case 'F':
            strings.write_string(&b, F)
        case 'G':
            strings.write_string(&b, G)
        case:
            strings.write_rune(&b, r)
        }
    }

    return strings.to_string(b)
}
