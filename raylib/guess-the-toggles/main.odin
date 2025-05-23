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
SWITCH_HEIGHT :: TOGGLE_HEIGHT / 2
TOGGLE_SPEED :: 3

COMPONENT_GAP :: 10
BUTTON_X :: 100
BUTTON_Y :: 100 + TOGGLE_HEIGHT + 20
BUTTON_WIDTH :: TOGGLE_WIDTH * 8 + COMPONENT_GAP * 7
BUTTON_HEIGHT :: 40
BUTTON_REC :: rl.Rectangle{BUTTON_X, BUTTON_Y, BUTTON_WIDTH, BUTTON_HEIGHT}

MESSAGE_X :: 100
MESSAGE_Y :: BUTTON_Y +BUTTON_HEIGHT + 20

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
    for &t, i in toggles {
        t.rec = {f32(100 + i * (TOGGLE_WIDTH + COMPONENT_GAP)), 100, TOGGLE_WIDTH, TOGGLE_HEIGHT}
        t.button_pos = {t.rec.x + TOGGLE_GAP, t.rec.y + TOGGLE_GAP, t.rec.width - TOGGLE_GAP*2, SWITCH_HEIGHT}
        t.dir = -1
    }

    secret := u8(rl.GetRandomValue(0, 255))

    if len(os.args[1:]) > 0 && os.args[1] == "cheat" {
        fmt.printfln("CHEAT MODE: SECRET: %s", to_binary(secret))
    }

    label_width := rl.MeasureText("Check", 20)
    label_x := i32(BUTTON_X + BUTTON_WIDTH / 2 - label_width / 2)
    label_y := i32(BUTTON_Y + BUTTON_HEIGHT / 2 - 20 / 2)

    message := "Guess the toggles"
    guesses := 0

    for !rl.WindowShouldClose() {
        label_color := rl.RAYWHITE
        hindex := mouse_over(toggles[:])

        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) && hindex != -1 {
            toggles[hindex].changing = true
            toggles[hindex].value = !toggles[hindex].value
            toggles[hindex].dir *= -1
        }

        if mouse_over_button() {
            label_color = rl.YELLOW

            if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
                guesses += 1
                guess := toggles_to_u8(toggles[:])
                secret_s := to_binary(secret)
                guess_s := to_binary(guess)
                correct := check_toggles(secret_s, guess_s)
                if correct == 8 {
                    message = fmt.tprintf("You did it! You needed %d guess%s", guesses, guesses == 1 ? "" : "es")
                } else {
                    message = fmt.tprintf("%d/8 correct", correct)
                }
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

        msg, _ := strings.clone_to_cstring(message)

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for t, i in toggles {
            rl.DrawRectangleLinesEx(t.rec, 1, t.color)
            rl.DrawRectangleRec(t.button_pos, t.color)
            rl.DrawRectangleRec(BUTTON_REC, rl.GREEN)
            rl.DrawText("Check", label_x, label_y, 20, label_color)
            rl.DrawText(msg, MESSAGE_X, MESSAGE_Y, 20, rl.GREEN)
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

mouse_over_button :: proc() -> bool {
    mp := rl.GetMousePosition()

    if mp.x >= BUTTON_X && mp.x <= BUTTON_X + BUTTON_WIDTH {
        if mp.y >= BUTTON_Y && mp.y <= BUTTON_Y + BUTTON_HEIGHT {
            return true
        }
    }

    return false
}

check_toggles :: proc(secret, guess: string) -> int {
    total := 0

    for i := 0; i < len(guess); i += 1 {
        if secret[i] == guess[i] do total += 1
    }

    return total
}

