package main

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Toggles"

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

    toggles := [10]Toggle{}
    gap := 10

    for &t, i in toggles {
        t.rec = {f32(100 + i * (TOGGLE_WIDTH + gap)), 100, TOGGLE_WIDTH, TOGGLE_HEIGHT}
        t.button_pos = {t.rec.x + TOGGLE_GAP, t.rec.y + TOGGLE_GAP, t.rec.width - TOGGLE_GAP*2, BUTTON_HEIGHT}
        t.dir = -1
    }

    for !rl.WindowShouldClose() {
        hindex := mouse_over(toggles[:])

        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) && hindex != -1 {
            toggles[hindex].changing = true
            toggles[hindex].value = !toggles[hindex].value
            toggles[hindex].dir *= -1
        }

        if rl.IsKeyPressed(.P) {
            for t, i in toggles {
                fmt.printfln("Toggle #%d. %v", i, t.value)
            }
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

mouse_over :: proc(toggles: []Toggle) -> int {
    mp := rl.GetMousePosition()

    for t, i  in toggles {
        if mp.x >= t.rec.x && mp.x <= t.rec.x + t.rec.width {
            if mp.y > t.rec.y && mp.y < t.rec.y + t.rec.height {
                return i
            }
        }
    }

    return -1
}