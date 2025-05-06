package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"

main :: proc() {
    width := 80
    height := 23
    ok: bool

    if len(os.args[1:]) >= 1 {
        if width, ok = strconv.parse_int(os.args[1]); !ok {
            fmt.printfln("Invalid width: %s", os.args[1])
            return
        }
    }

    if len(os.args[1:]) >= 2 {
        if height, ok = strconv.parse_int(os.args[2]); !ok {
            fmt.printfln("Invalid height: %s", os.args[2])
            return
        }
    }

    screen: [dynamic]rune

    for line in 0..<height {
        for col in 0..<width-1 {
            append(&screen, ' ')
        }

        append(&screen, '\n')
    }

    half_height := height / 2
    a := 0.0

    for x in 0..<width {
        i := half_height * width + x
        if i < len(screen) && screen[i] != '\n' do screen[i] = '-'

        r := f32(a) * math.PI / 180.0
        y := half_height + int(f32(half_height) * math.sin(r))

        i = y * width + x
        if i < len(screen) && screen[i] != '\n' do screen[i] = '*'
        a += 360.0 / f64(width)
    }

    for r in 0..<width*height {
        fmt.print(screen[r])
    }
}