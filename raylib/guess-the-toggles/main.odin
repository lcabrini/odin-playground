package main

import "core:fmt"
import "core:math/rand"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Guess the Toggles"

TOGGLE_WIDTH :: 50
TOGGLE_HEIGHT :: 100
TOGGLE_GAP :: 3
BUTTON_HEIGHT :: TOGGLE_HEIGHT / 2
TOGGLE_SPEED :: 3

Toggle :: struct {
    rec: rl.Rectangle,
    button_pos: rl.Rectangle,
    changing: bool,
    value: bool,
    color: rl.Color,
    dir: f32,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    toggles := [8]Toggle{}
    gap := 10
    for &t, i in toggles {
        t.rec = {f32(100 + i * (TOGGLE_WIDTH + gap)), 100, TOGGLE_WIDTH, TOGGLE_HEIGHT}
        t.button_pos = {t.rec.x + TOGGLE_GAP, t.rec.y + TOGGLE_GAP, t.rec.width - TOGGLE_GAP*2, BUTTON_HEIGHT}
        t.dir = -1
    }

    secret := u8(rl.GetRandomValue(0, 255))

    if len(os.args[1:]) > 0 && os.args[1] == "cheat" {
        fmt.printfln("CHEAT MODE: SECRET: %s", to_binary(secret))
    }

    for !rl.WindowShouldClose() {
        hindex := mouse_over(toggles[:])

        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) && hindex != -1 {
            toggles[hindex].changing = true
            toggles[hindex].value = !toggles[hindex].value
            toggles[hindex].dir *= -1
        }

        if rl.IsKeyPressed(.P) {
            guess := toggles_to_u8(toggles[:])
            if guess == secret {
                fmt.println("You did it")
            }
            fmt.println(guess)
        }

        for &t, i in toggles {
            t.color = i == hindex ? rl.BLUE : rl.RAYWHITE
            if t.changing {
                t.button_pos.y += t.dir * TOGGLE_SPEED
                if t.button_pos.y <= t.rec.y + TOGGLE_GAP || t.button_pos.y >= t.rec.y + t.rec.height - t.button_pos.height - TOGGLE_GAP {
                    t.changing = false
                }
            }
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for t, i in toggles {
            rl.DrawRectangleLinesEx(t.rec, 1, t.color)
            rl.DrawRectangleRec(t.button_pos, t.color)

        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}

to_binary :: proc(n: u8) -> string {
    s := ""

    for g := u8(128); g > 0; g >>= 1 {
        s = fmt.tprintf("%s%s", s, g & n == 0 ? "0" : "1")
    }

    return s
}

toggles_to_u8 :: proc(toggles: []Toggle) -> u8 {
    val: u8

    for t, i in toggles {
        val += t.value ? 1 << u8(7-i) : 0
    }

    return val
}

mouse_over :: proc(toggles: []Toggle) -> int {
    mp := rl.GetMousePosition()

    for t, i in toggles {
        if mp.x >= t.rec.x && mp.x <= t.rec.x + t.rec.width {
            if mp.y >= t.rec.y && mp.y <= t.rec.y + t.rec.height {
                return i
            }
        }
    }

    return -1
}
