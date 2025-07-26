package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

/*
   I was inspired by this: https://jason.today/falling-sand
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Falling Sand"
ACCEL :: 1.09
MAX_V :: 20

Grain :: struct {
    v: rl.Vector2,
    color: rl.Color,
}

Empty :: struct {}

Position :: union {
    Grain,
    Empty,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.SetTraceLogLevel(.ERROR)
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    empty := Empty{}

    screen := make([]Position, WIDTH*HEIGHT)    
    for y in 0..<HEIGHT {
        for x in 0..<WIDTH {
            screen[y*WIDTH+x] = empty
        }
    }

    for !rl.WindowShouldClose() {
        if rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
            mp := rl.GetMousePosition()

            for i in 0..<f32(20) {
                inner: for a in 0..<f32(360) {
                    r := rl.GetRandomValue(0, 9)
                    if r > 0 do continue inner
                    x := int(mp.x + i*math.cos(a*rl.DEG2RAD))
                    y := int(mp.y + i*math.sin(a*rl.DEG2RAD))

                    //x := i32(mp.x) + rl.GetRandomValue(-10, 10)
                    //y := i32(mp.y) + rl.GetRandomValue(-10, 10)

                    if y < 0 || y > HEIGHT -1 do continue
                    if x < 0 || x > WIDTH - 1 do continue
                    grain := Grain{}
                    grain.v = {0, f32(rl.GetRandomValue(1,4))}
                    grain.color = {0xdc, 0xb1, 0x59, 0xff}
                    screen[y*WIDTH+x] = grain
                }
            }
        }

        for y := HEIGHT-2; y > 0; y -= 1 {
            for x in 0..<WIDTH {
                #partial switch &pt in screen[y*WIDTH+x] {
                case Grain:
                    if screen[(y+1)*WIDTH+x] != empty {
                        if screen[(y+1)*WIDTH+x-1] == empty && screen[(y+1)*WIDTH+x+1] == empty {
                            side := rl.GetRandomValue(0, 1)
                            if side == 0 {
                                if x-1 >= 0 {
                                    screen[(y+1)*WIDTH+x-1] = pt
                                    screen[y*WIDTH+x] = empty
                                } else {
                                    screen[y*WIDTH+x] = empty
                                }
                            } else {
                                if x+1 < WIDTH-1 {
                                    screen[(y+1)*WIDTH+x+1] = pt
                                    screen[y*WIDTH+x] = empty
                                } else {
                                    screen[y*WIDTH+x] = empty
                                }
                            }
                        } else if screen[(y+1)*WIDTH+x-1] == empty {
                            if x-1 >= 0 {
                                screen[(y+1)*WIDTH+x-1] = pt
                                screen[y*WIDTH+x] = empty
                            } else {
                                screen[y*WIDTH+x] = empty
                            }
                        } else if screen[(y+1)*WIDTH+x+1] == empty {
                            if x+1 < WIDTH-1 {
                                screen[(y+1)*WIDTH+x+1] = pt
                                screen[y*WIDTH+x] = empty
                            } else {
                                screen[y*WIDTH+x] = empty
                            }
                        }

                        continue
                    }

                    pt.v.y *= ACCEL
                    if pt.v.y > MAX_V do pt.v.y = MAX_V
                    y1 := y + int(pt.v.y)
                    if y1 >= HEIGHT {
                        for {
                            y1 -= 1
                            if y1 >= HEIGHT do continue
                            if screen[y1*WIDTH+x] == empty do break
                        }
                    }

                    screen[y1*WIDTH+x] = pt
                    screen[y*WIDTH+x] = empty
                }
            }
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for y in 0..<HEIGHT {
            for x in 0..<WIDTH {
                #partial switch pt in screen[y*WIDTH+x] {
                case Grain:
                    rl.DrawPixel(i32(x), i32(y), pt.color)
                }
            }
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}

