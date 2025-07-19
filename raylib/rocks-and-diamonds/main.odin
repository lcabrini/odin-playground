package main

import rl "vendor:raylib"

/*
    I was curious about how to create a Boulderdash-type game, so I wrote this little test.
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Rocks and Diamonds"
TILE_SIZE :: 32
MAP_WIDTH :: 64
MAP_HEIGHT :: 32
TICK_RATE :: 0.13

TileType :: enum {
    EMPTY,
    SOIL,
    BORDER,
    ROCK,
}

Tile :: struct {
    type: TileType,
    spritesheet: ^rl.Texture,
    sheet_x: i32,
    sheet_y: i32,
}

Map :: struct {
    tiles: [MAP_HEIGHT][MAP_WIDTH]Tile
}

PlayerStopped :: struct {
    spritesheet: ^rl.Texture,
    sheet_x: i32,
    sheet_y: i32,
}

PlayerState :: union {
    PlayerStopped,
}

Player :: struct {
    state: PlayerState,
    pos: [2]i32,
    dir: [2]i32,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)

    spritesheet_1 := rl.LoadTexture("../../resources/RocksBD.png")
    spritesheet_2 := rl.LoadTexture("../../resources/RocksSP.png")
    spritesheet_3 := rl.LoadTexture("../../resources/RocksHeroes.png")
    spritesheet_4 := rl.LoadTexture("../../resources/RocksMore.png")

    empty := Tile{}
    empty.type = .EMPTY
    empty.spritesheet = &spritesheet_1
    empty.sheet_x = 4
    empty.sheet_y = 14

    soil := Tile{}
    soil.type = .SOIL
    soil.spritesheet = &spritesheet_4
    soil.sheet_x = 0
    soil.sheet_y = 2 

    border := Tile{}
    border.type = .BORDER
    border.spritesheet = &spritesheet_2
    border.sheet_x = 0
    border.sheet_y = 5

    rock := Tile{}
    rock.type = .ROCK
    rock.spritesheet = &spritesheet_1
    rock.sheet_x = 11
    rock.sheet_y = 4

    player_stopped := PlayerStopped{}
    player_stopped.spritesheet = &spritesheet_3
    player_stopped.sheet_x = 0
    player_stopped.sheet_y = 0

    player := Player{}
    player.state = player_stopped
    player.pos = {1, 1}

    game_map := Map{}
    for y in 0..<MAP_HEIGHT {
        for x in 0..<MAP_WIDTH {
            if y == 0 || y == MAP_HEIGHT-1 {
                game_map.tiles[y][x] = border
            } else if x == 0 || x == MAP_WIDTH-1 {
                game_map.tiles[y][x] = border
            } else {
                game_map.tiles[y][x] = soil
            }
        }
    }

    for i in 0..<30 {
        x := rl.GetRandomValue(1, MAP_WIDTH-2)
        y := rl.GetRandomValue(1, MAP_HEIGHT-2)
        game_map.tiles[y][x] = rock
    }

    tick_timer: f32 = TICK_RATE

    for !rl.WindowShouldClose() {
        tick_timer -= rl.GetFrameTime()
        player.dir = {0, 0}

        if rl.IsKeyDown(.UP) {
            player.dir = {0, -1}
        }

        if rl.IsKeyDown(.DOWN) {
            player.dir = {0, 1}
        }

        if rl.IsKeyDown(.LEFT) {
            player.dir = {-1, 0}
        }

        if rl.IsKeyDown(.RIGHT) {
            player.dir = {1, 0}
        }

        if tick_timer < 0 {
            x := player.pos.x + player.dir.x
            y := player.pos.y + player.dir.y
            game_map.tiles[player.pos.y][player.pos.x] = empty

            if x >= 1 && x < MAP_WIDTH-1 {
                player.pos.x = x
            }

            if y >= 1 && y < MAP_HEIGHT-1 {
                player.pos.y = y
            }

            tick_timer += TICK_RATE
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for y in 0..<MAP_HEIGHT {
            for x in 0..<MAP_WIDTH {
                tile := game_map.tiles[y][x]
                src := rl.Rectangle{f32(tile.sheet_x*TILE_SIZE), f32(tile.sheet_y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
                dest := rl.Rectangle{f32(x*TILE_SIZE), f32(y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
                rl.DrawTexturePro(tile.spritesheet^, src, dest, {0, 0}, 0, rl.WHITE)
            }
        }

        switch state in player.state {
        case PlayerStopped:
            src := rl.Rectangle{f32(state.sheet_x*TILE_SIZE), f32(state.sheet_y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            dest := rl.Rectangle{f32(player.pos.x*TILE_SIZE), f32(player.pos.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            rl.DrawTexturePro(state.spritesheet^, src, dest, {0, 0}, 0, rl.WHITE)
        }

        rl.EndDrawing()
    }

    rl.UnloadTexture(spritesheet_1)
    rl.UnloadTexture(spritesheet_2)
    rl.UnloadTexture(spritesheet_3)
    rl.CloseWindow()
}
