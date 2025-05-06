package main

import "core:fmt"
import rl "vendor:raylib"

/*
    Based on a program I wrote in C, using SDL.
    Inspired by the AmigaBASIC "Music" demo.
*/

WB_RED :: 0
WB_GREEN :: 85
WB_BLUE :: 169
WB_BACKGROUND :: rl.Color{WB_RED, WB_GREEN, WB_BLUE, 255}

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Music"

LINES_PER_QUADRANT :: 30
LINE_STEP :: 10
LINE_COUNT :: LINES_PER_QUADRANT * 2

LEFT :: 0
TOP :: 0
RIGHT :: WIDTH - 1
BOTTOM :: HEIGHT - 1

R_STEP :: (255 - 0) / LINE_COUNT
G_STEP :: (255 - 85) / LINE_COUNT
B_STEP :: (255 - 169) / LINE_COUNT

Line :: struct {
    x1: int,
    y1: int,
    x2: int,
    y2: int,
    next: ^Line,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    head := init_lines()
    current := head

    rl.InitAudioDevice()
    music := rl.LoadMusicStream("jesu-joy-of-mans-desiring.mp3")
    rl.PlayMusicStream(music)

    paused := false

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.P) {
            paused = !paused
            if paused {
                rl.PauseMusicStream(music)
            } else {
                rl.ResumeMusicStream(music)
            }
        }

        if rl.IsKeyPressed(.R) {
            rl.StopMusicStream(music)
            rl.PlayMusicStream(music)
            current = head
        }

        rl.UpdateMusicStream(music)

        rl.BeginDrawing()
        rl.ClearBackground(WB_BACKGROUND)

        red := u8(WB_RED)
        green := u8(WB_GREEN)
        blue := u8(WB_BLUE)

        line := current
        for i in 0..<LINE_COUNT {
            red += R_STEP
            green += G_STEP
            blue += B_STEP
            rl.DrawLine(i32(line.x1), i32(line.y1), i32(line.x2), i32(line.y2), {red, green, blue, 255})
            line = line.next
        }

        rl.EndDrawing()
        if !paused do current = current.next
    }

    rl.UnloadAudioStream(music)
    rl.CloseAudioDevice()
    rl.CloseWindow()

    free_lines(head)
}

init_lines :: proc() -> ^Line {
    head, current, tail: ^Line

    for q in 0..<LINES_PER_QUADRANT {
        current = new(Line)
        current.x1 = LEFT
        current.y1 = LINE_STEP * (LINES_PER_QUADRANT - q)
        current.x2 = LINE_STEP * q
        current.y2 = TOP
        if (head == nil) do head = current
        if (tail != nil) do tail.next = current
        tail = current
    }

    for q in 0..<LINES_PER_QUADRANT {
        current = new(Line)
        current.x1 = RIGHT - LINE_STEP * (LINES_PER_QUADRANT - q)
        current.y1 = TOP
        current.x2 = RIGHT
        current.y2 = LINE_STEP * q
        tail.next = current
        tail = current
    }

    for q in 0..<LINES_PER_QUADRANT {
        current = new(Line)
        current.x1 = RIGHT
        current.y1 = BOTTOM - LINE_STEP * (LINES_PER_QUADRANT - q)
        current.x2 = RIGHT - LINE_STEP * q
        current.y2 = BOTTOM
        tail.next = current
        tail = current
    }

    for q in 0..<LINES_PER_QUADRANT {
        current = new(Line)
        current.x1 = LEFT + LINE_STEP * (LINES_PER_QUADRANT - q)
        current.y1 = BOTTOM
        current.x2 = LEFT
        current.y2 = BOTTOM - LINE_STEP * q
        tail.next = current
        tail = current
    }

    tail.next = head
    return head
}

free_lines :: proc(head: ^Line) {
    current := head

    for {
        previous := current
        current = current.next
        previous.next = nil
        if current == nil do break
        if previous != nil do free(previous)
    }
}