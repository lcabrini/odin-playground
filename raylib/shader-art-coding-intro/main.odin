package main

import "core:fmt"
import "core:os"
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
1. Empty
2. Horizontal Gradient
3. Vertical Gradient
4. Horizontal and Vertical Gradients
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
    fmt.println(menu)
    example := readint("Enter example", 1, 4)
    if example == -1 do os.exit(1)

    screen_width: f32 = 1024
    screen_height: f32 = 768
    rl.SetConfigFlags({.VSYNC_HINT})
    //rl.SetTraceLogLevel(.ERROR)
    rl.InitWindow(i32(screen_width), i32(screen_height), TITLE)
    rl.SetTargetFPS(60)

    fn := rl.TextFormat("shader-%02d.fs", example)
    texture := rl.LoadRenderTexture(i32(screen_width), i32(screen_height))
    shader := rl.LoadShader("", fn)
    widthLoc := rl.GetShaderLocation(shader, "renderWidth")
    heightLoc := rl.GetShaderLocation(shader, "renderHeight")
    secondsLoc := rl.GetShaderLocation(shader, "seconds")
    seconds: f32 = 0
    rl.SetShaderValue(shader, widthLoc, &screen_width, rl.ShaderUniformDataType.FLOAT)
    rl.SetShaderValue(shader, heightLoc, &screen_height, rl.ShaderUniformDataType.FLOAT)

    for !rl.WindowShouldClose() {
        seconds += rl.GetFrameTime()
        rl.SetShaderValue(shader, secondsLoc, &seconds, rl.ShaderUniformDataType.FLOAT)

        rl.BeginTextureMode(texture)
        rl.ClearBackground(rl.BLACK)
        rl.DrawRectangle(0, 0, i32(screen_width), i32(screen_height), rl.BLACK)
        rl.EndTextureMode()

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.BeginShaderMode(shader)
        rl.DrawTexture(texture.texture, 0, 0, rl.WHITE)
        rl.EndShaderMode()
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
