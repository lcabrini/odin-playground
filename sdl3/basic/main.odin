package main

import "core:fmt"
import "core:os"
import sdl "vendor:sdl3"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Basic"

main :: proc() {
    if !sdl.Init({.VIDEO}) {
        fmt.eprintfln("Unable to initialize SDL: %s", sdl.GetError())
        os.exit(-1)
    }

    window := sdl.CreateWindow(TITLE, WIDTH, HEIGHT, {.RESIZABLE})
    if window == nil {
        fmt.eprintfln("Unable to create window: %s", sdl.GetError())
        os.exit(-1)
    }

    renderer := sdl.CreateRenderer(window, nil)
    if renderer == nil {
        fmt.eprintfln("Unable create renderer: %s", sdl.GetError())
        os.exit(-1)
    }

    quit := false
    event: sdl.Event

    for !quit {
        for sdl.PollEvent(&event) {
            #partial switch event.type {
                case .QUIT:
                    quit = true
            }
        }

        sdl.RenderClear(renderer)
        sdl.RenderPresent(renderer)
    }

    sdl.DestroyRenderer(renderer)
    sdl.DestroyWindow(window)
    sdl.Quit()
}