package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Image 2 Code"

main :: proc() {
    image := rl.LoadImage("../../resources/space-bg.png")
    rl.ExportImageAsCode(image, "exported_image.h")
    rl.UnloadImage(image)
}
