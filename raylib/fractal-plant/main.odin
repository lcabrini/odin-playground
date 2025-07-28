/*
   Implementation of Example 7:Fractal plant from https://en.wikipedia.org/wiki/L-system
   I used https://www.youtube.com/watch?v=3Mu0--aGfqg as a basis for my own implementation.
*/

package main

import "core:fmt"
import "core:math"
import "core:strings"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Plant"
MIDX :: WIDTH/2
MIDY :: HEIGHT/2
LEN :: 2
ANGLE :: 25 * rl.DEG2RAD

F :: "FF"
X :: "F+[[X]-X]-F[-FX]+X"

State :: struct {
    pos: rl.Vector2,
    a: f32,
}

Node :: struct {
    state: State,
    next: ^Node,
}

Stack :: struct {
    top: ^Node,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.SetTraceLogLevel(.ERROR)
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    stack := Stack{}
    word := "X"

    for !rl.WindowShouldClose() {
        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
            word = generate(word)
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        draw(word, &stack)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}

draw ::proc(word: string, stack: ^Stack) {
    state := State{}
    state.pos = {MIDX, HEIGHT}
    state.a = (90-25) * rl.DEG2RAD

    for r in word {
        switch r {
        case 'F':
            x := state.pos.x + LEN * math.cos(state.a)
            y := state.pos.y - LEN * math.sin(state.a)
            rl.DrawLineV(state.pos, {x, y}, rl.BROWN)
            state.pos = {x, y}
        case '-':
            state.a -= ANGLE
        case '+':
            state.a += ANGLE
        case '[':
            push(stack, state)
        case ']':
            rl.DrawEllipse(i32(state.pos.x), i32(state.pos.y), 2, 5, rl.GREEN)
            state = pop(stack)
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
        case 'X':
            strings.write_string(&b, X)
        case:
            strings.write_rune(&b, r)
        }
    }

    return strings.to_string(b)
}

push :: proc(stack: ^Stack, state: State) {
    node := new(Node)
    node.state = state
    node.next = stack.top
    stack.top = node
}

pop :: proc(stack: ^Stack) -> State {
    state: State

    top := stack.top
    if top != nil {
        state = top.state
        stack.top = top.next
        free(top)
    }

    return state
}
