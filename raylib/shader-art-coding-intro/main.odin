package main

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strconv"
import rl "vendor:raylib"

/*
    I converted "An Introduction to Shader Art Coding" by kishimisu ((https://www.youtube.com/watch?v=f4s1h2YETNY).
    I got some help from  https://github.com/planetis-m/raylib-examples/blob/main/personal/shaderart.nim to figure 
    out how to to get it to work with Raylib.
*/

TITLE :: "Shader Art Coding Intro"

menu := `
Shader examples from "An Introduction to Shader Art Coding" by kishimisu" 
(https://www.youtube.com/watch?v=f4s1h2YETNY).

Select the shader you want to test:
1.  Empty
2.  Red horizontal gradient
3.  Green vertical gradient
4.  Red horizontal and green vertical gradients
5.  Red radial gradient
6.  Gray radial gradient
7.  Gray radial gradient (larger black inner circle)
8.  Bi-directional gray radial gradient
9.  Ring
10. Ring with smooth transition
11. Multiple rings with smooth transition
12. Animated rings
13. Inverse animated rings
14. Inverse animated rings with red tint
15. Inverse animated rings with vibrant blue tint
16. Multi-colored animated rings
17. Dynamic multi-colored animated rings
18. Spatial repetition of animated rings
19. Pattern 1
20. Pattern 2
21. Pattern 3
22. Pattern 4
23. Final Pattern
`

readint :: proc(prompt: string, min, max: int) -> int {
    buf: [5]byte
    
    for {
        fmt.printf("%s (%d-%d): ", prompt, min, max)
        bytes_read, err := os.read(os.stdin, buf[:])
        if err != nil {
            fmt.eprintln("Could not read from stdin: ", err)
            return -1
        }

        s := string(buf[:bytes_read-1])
        n, ok := strconv.parse_int(s)
        if !ok {
            fmt.eprintfln("'%s' is not a valid integer. Try again.", s)
            continue
        }

        if n < min || n > max {
            fmt.eprintfln("%d is outside the valid range %d-%d. Try again.", n, min, max)
            continue
        }

        return n
    }
}

main :: proc() {
    shaders, err := filepath.glob("*.frag")
    if err != nil {
        fmt.eprintln("Unable to glob: ", err)
        os.exit(1) 
    }

    fmt.println(menu)
    example := readint("Enter example", 1, len(shaders))
    if example == -1 do os.exit(1)

    screen_width: f32 = 1024
    screen_height: f32 = 768
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.SetTraceLogLevel(.ERROR)
    rl.InitWindow(i32(screen_width), i32(screen_height), TITLE)
    rl.SetTargetFPS(60)

    fn := rl.TextFormat("shader-%02d.frag", example)
    target := rl.LoadRenderTexture(i32(screen_width), i32(screen_height))
    shader := rl.LoadShader("", fn)
    widthLoc := rl.GetShaderLocation(shader, "renderWidth")
    heightLoc := rl.GetShaderLocation(shader, "renderHeight")
    timeLoc := rl.GetShaderLocation(shader, "time")
    td: f32 = 0
    rl.SetShaderValue(shader, widthLoc, &screen_width, rl.ShaderUniformDataType.FLOAT)
    rl.SetShaderValue(shader, heightLoc, &screen_height, rl.ShaderUniformDataType.FLOAT)

    for !rl.WindowShouldClose() {
        td += rl.GetFrameTime()
        rl.SetShaderValue(shader, timeLoc, &td, rl.ShaderUniformDataType.FLOAT)

        rl.BeginTextureMode(target)
        rl.ClearBackground(rl.BLACK)
        rl.DrawRectangle(0, 0, i32(screen_width), i32(screen_height), rl.BLACK)
        rl.EndTextureMode()

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.BeginShaderMode(shader)
        rl.DrawTexture(target.texture, 0, 0, rl.WHITE)
        rl.EndShaderMode()
        rl.EndDrawing()
    }

    rl.UnloadRenderTexture(target)
    rl.CloseWindow()
}
