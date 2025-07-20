package main

import "core:fmt"
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

PlayerLeft :: struct {
    spritesheet: ^rl.Texture,
    sprites: [4][2]i32,
    sprite_idx: i32,
}

PlayerRight :: struct {
    spritesheet: ^rl.Texture,
    sprites: [4][2]i32,
    sprite_idx: i32,
}

PlayerUp :: struct {
    spritesheet: ^rl.Texture,
    sprites: [4][2]i32,
    sprite_idx: i32,
}

PlayerDown :: struct {
    spritesheet: ^rl.Texture,
    sprites: [4][2]i32,
    sprite_idx: i32,
}

PlayerPushLeft :: struct {
    spritesheet: ^rl.Texture,
    sprites: [4][2]i32,
    sprite_idx: i32,
    rock: ^Rock,
}

PlayerPushRight :: struct {
    spritesheet: ^rl.Texture,
    sprites: [4][2]i32,
    sprite_idx: i32,
    rock: ^Rock,
}

PlayerState :: union {
    PlayerStopped,
    PlayerLeft,
    PlayerRight,
    PlayerUp,
    PlayerDown,
    PlayerPushLeft,
    PlayerPushRight,
}

Player :: struct {
    state: PlayerState,
    pos: [2]i32,
    dir: [2]i32,
}

Rock :: struct {
    spritesheet: ^rl.Texture,
    sheet_x: i32,
    sheet_y: i32,
    pos: [2]i32,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.InitAudioDevice()

    spritesheet_1 := rl.LoadTexture("../../resources/RocksBD.png")
    spritesheet_2 := rl.LoadTexture("../../resources/RocksSP.png")
    spritesheet_3 := rl.LoadTexture("../../resources/RocksHeroes.png")
    spritesheet_4 := rl.LoadTexture("../../resources/RocksMore.png")
    empty_wav := rl.LoadSound("../../resources/empty.wav")
    soil_wav := rl.LoadSound("../../resources/schlurf.wav")
    push_wav := rl.LoadSound("../../resources/pusch.wav")

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

    player_stopped := PlayerStopped{}
    player_stopped.spritesheet = &spritesheet_3
    player_stopped.sheet_x = 0
    player_stopped.sheet_y = 0

    player_left := PlayerLeft{}
    player_left.spritesheet = &spritesheet_3
    player_left.sprites[0] = {0, 1}
    player_left.sprites[1] = {1, 1}
    player_left.sprites[2] = {2, 1}
    player_left.sprites[3] = {3, 1}
    player_left.sprite_idx = 0

    player_right := PlayerRight{}
    player_right.spritesheet = &spritesheet_3
    player_right.sprites[0] = {4, 1}
    player_right.sprites[1] = {5, 1}
    player_right.sprites[2] = {6, 1}
    player_right.sprites[3] = {7, 1}
    player_right.sprite_idx = 0

    player_up := PlayerUp{}
    player_up.spritesheet = &spritesheet_3
    player_up.sprites[0] = {4, 0}
    player_up.sprites[1] = {5, 0}
    player_up.sprites[2] = {6, 0}
    player_up.sprites[3] = {7, 0}
    player_up.sprite_idx = 0

    player_down := PlayerDown{}
    player_down.spritesheet = &spritesheet_3
    player_down.sprites[0] = {0, 0}
    player_down.sprites[1] = {1, 0}
    player_down.sprites[2] = {2, 0}
    player_down.sprites[3] = {3, 0}
    player_down.sprite_idx = 0

    player_push_left := PlayerPushLeft{}
    player_push_left.spritesheet = &spritesheet_3
    player_push_left.sprites[0] = {4, 2}
    player_push_left.sprites[1] = {5, 2}
    player_push_left.sprites[2] = {6, 2}
    player_push_left.sprites[3] = {7, 2}
    player_push_left.sprite_idx = 0

    player_push_right := PlayerPushRight{}
    player_push_right.spritesheet = &spritesheet_3
    player_push_right.sprites[0] = {0, 2}
    player_push_right.sprites[1] = {1, 2}
    player_push_right.sprites[2] = {2, 2}
    player_push_right.sprites[3] = {3, 2}

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

    rocks: [30]Rock
    for i in 0..<30 {
        x := rl.GetRandomValue(1, MAP_WIDTH-2)
        y := rl.GetRandomValue(1, MAP_HEIGHT-2)
        rocks[i].pos = {x, y}
        rocks[i].spritesheet = &spritesheet_1
        rocks[i].sheet_x = 11
        rocks[i].sheet_y = 4
    }


    tick_timer: f32 = TICK_RATE

    for !rl.WindowShouldClose() {
        tick_timer -= rl.GetFrameTime()


        if tick_timer < 0 {
            player.dir = {0, 0}

            if rl.IsKeyDown(.UP) {
                player.dir = {0, -1}
                player.state = player_up
            }

            if rl.IsKeyDown(.DOWN) {
                player.dir = {0, 1}
                player.state = player_down
            }

            if rl.IsKeyDown(.LEFT) {
                player.dir = {-1, 0}
                player.state = player_left
            }

            if rl.IsKeyDown(.RIGHT) {
                player.dir = {1, 0}
                player.state = player_right
            }

            x := player.pos.x + player.dir.x
            y := player.pos.y + player.dir.y
            
            type := game_map.tiles[y][x].type
            if type != .EMPTY && type != .SOIL do player.dir = {0, 0}

            for &rock in rocks {
                if rock.pos == {x, y} {
                    if player.dir.x == 1 {
                        player.state = player_push_right
                        player_push_right.rock = &rock
                    } else if player.dir.x == -1 {
                        player.state = player_push_left
                        player_push_left.rock = &rock
                    } else {
                        player.dir = {0, 0}
                    }
                    break
                }
            }

            if player.dir != {0, 0} {
                #partial switch &state in player.state {
                case PlayerLeft:
                    player_left.sprite_idx += 1
                    if player_left.sprite_idx > 3 do player_left.sprite_idx = 0
                case PlayerRight:
                    player_right.sprite_idx += 1
                    if player_right.sprite_idx > 3 do player_right.sprite_idx = 0
                case PlayerUp:
                    player_up.sprite_idx += 1
                    if player_up.sprite_idx > 3 do player_up.sprite_idx = 0
                case PlayerDown:
                    player_down.sprite_idx += 1
                    if player_down.sprite_idx > 3 do player_down.sprite_idx = 0
                case PlayerPushRight:
                    rock := player_push_right.rock
                    fmt.println(rock)
                    fmt.println(game_map.tiles[rock.pos.x+1][rock.pos.y])
                    if game_map.tiles[rock.pos.y][rock.pos.x+1].type == TileType.EMPTY {
                        player_push_right.sprite_idx += 1
                        if player_push_right.sprite_idx > 3 do player_push_right.sprite_idx = 0
                        rock.pos.x += 1
                        rl.PlaySound(push_wav)
                    } else {
                        player_push_right.sprite_idx = 0  
                        player.dir = {0, 0}
                    }
                case PlayerPushLeft:
                    rock := player_push_left.rock
                    fmt.println(game_map.tiles[rock.pos.x-1][rock.pos.y])
                    if game_map.tiles[rock.pos.y][rock.pos.x-1].type == TileType.EMPTY {
                        player_push_left.sprite_idx += 1
                        if player_push_left.sprite_idx > 3 do player_push_left.sprite_idx = 0
                        rock.pos.x -= 1
                        rl.PlaySound(push_wav)
                    } else {
                        player_push_left.sprite_idx = 0
                        player.dir = {0, 0}
                    }
                }
            }

            if player.dir != {0, 0} {
                game_map.tiles[player.pos.y][player.pos.x] = empty

                if x >= 1 && x < MAP_WIDTH-1 {
                    player.pos.x = x
                }

                if y >= 1 && y < MAP_HEIGHT-1 {
                    player.pos.y = y
                }

                if game_map.tiles[y][x] == empty {
                    rl.PlaySound(empty_wav)
                } else if game_map.tiles[y][x] == soil {
                    rl.PlaySound(soil_wav)
                }
            }

            tick_timer += TICK_RATE
        }

        offset_x := f32(rl.GetScreenWidth() / 2)
        offset_y := f32(rl.GetScreenHeight() / 2)
        
        if player.pos.x * TILE_SIZE < WIDTH/2 {
            offset_x = f32(player.pos.x) * TILE_SIZE
        }

        if player.pos.y * TILE_SIZE < HEIGHT/2 {
            offset_y = f32(player.pos.y) * TILE_SIZE
        }

        if player.pos.x * TILE_SIZE > MAP_WIDTH * TILE_SIZE - WIDTH/2 {
            offset_x = f32(player.pos.x) * TILE_SIZE - (MAP_WIDTH * TILE_SIZE - WIDTH)
        }

        if player.pos.y * TILE_SIZE > MAP_HEIGHT * TILE_SIZE - HEIGHT/2 {
            offset_y = f32(player.pos.y) * TILE_SIZE - (MAP_HEIGHT * TILE_SIZE - HEIGHT)
        }

        camera := rl.Camera2D {
            zoom = 1,
            offset = {offset_x, offset_y},
            target = {f32(player.pos.x) * TILE_SIZE, f32(player.pos.y) * TILE_SIZE},
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.BeginMode2D(camera)

        for y in 0..<MAP_HEIGHT {
            for x in 0..<MAP_WIDTH {
                tile := game_map.tiles[y][x]
                src := rl.Rectangle{f32(tile.sheet_x*TILE_SIZE), f32(tile.sheet_y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
                dest := rl.Rectangle{f32(x*TILE_SIZE), f32(y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
                rl.DrawTexturePro(tile.spritesheet^, src, dest, {0, 0}, 0, rl.WHITE)
            }
        }

        for rock in rocks {
            src := rl.Rectangle{f32(rock.sheet_x*TILE_SIZE), f32(rock.sheet_y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            dest := rl.Rectangle{f32(rock.pos.x*TILE_SIZE), f32(rock.pos.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            rl.DrawTexturePro(rock.spritesheet^, src, dest, {0, 0}, 0, rl.WHITE)
        }

        switch state in player.state {
        case PlayerStopped:
            src := rl.Rectangle{f32(state.sheet_x*TILE_SIZE), f32(state.sheet_y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            dest := rl.Rectangle{f32(player.pos.x*TILE_SIZE), f32(player.pos.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            rl.DrawTexturePro(state.spritesheet^, src, dest, {0, 0}, 0, rl.WHITE)
        case PlayerLeft:
            sprite := state.sprites[state.sprite_idx]
            src := rl.Rectangle{f32(sprite.x*TILE_SIZE), f32(sprite.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            dest := rl.Rectangle{f32(player.pos.x*TILE_SIZE), f32(player.pos.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            rl.DrawTexturePro(state.spritesheet^, src, dest, {0, 0}, 0, rl.WHITE)
        case PlayerRight:
            sprite := state.sprites[state.sprite_idx]
            src := rl.Rectangle{f32(sprite.x*TILE_SIZE), f32(sprite.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            dest := rl.Rectangle{f32(player.pos.x*TILE_SIZE), f32(player.pos.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            rl.DrawTexturePro(state.spritesheet^, src, dest, {0, 0}, 0, rl.WHITE)
        case PlayerUp:
            sprite := state.sprites[state.sprite_idx]
            src := rl.Rectangle{f32(sprite.x*TILE_SIZE), f32(sprite.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            dest := rl.Rectangle{f32(player.pos.x*TILE_SIZE), f32(player.pos.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            rl.DrawTexturePro(state.spritesheet^, src, dest, {0, 0}, 0, rl.WHITE)
        case PlayerDown:
            sprite := state.sprites[state.sprite_idx]
            src := rl.Rectangle{f32(sprite.x*TILE_SIZE), f32(sprite.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            dest := rl.Rectangle{f32(player.pos.x*TILE_SIZE), f32(player.pos.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            rl.DrawTexturePro(state.spritesheet^, src, dest, {0, 0}, 0, rl.WHITE)
        case PlayerPushRight:
            sprite := state.sprites[state.sprite_idx]
            src := rl.Rectangle{f32(sprite.x*TILE_SIZE), f32(sprite.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            dest := rl.Rectangle{f32(player.pos.x*TILE_SIZE), f32(player.pos.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            rl.DrawTexturePro(state.spritesheet^, src, dest, {0, 0}, 0, rl.WHITE)
        case PlayerPushLeft:
            sprite := state.sprites[state.sprite_idx]
            src := rl.Rectangle{f32(sprite.x*TILE_SIZE), f32(sprite.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            dest := rl.Rectangle{f32(player.pos.x*TILE_SIZE), f32(player.pos.y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
            rl.DrawTexturePro(state.spritesheet^, src, dest, {0, 0}, 0, rl.WHITE)
        }

        rl.EndMode2D()
        rl.EndDrawing()
    }

    rl.UnloadSound(push_wav)
    rl.UnloadSound(soil_wav)
    rl.UnloadSound(empty_wav)
    rl.UnloadTexture(spritesheet_1)
    rl.UnloadTexture(spritesheet_2)
    rl.UnloadTexture(spritesheet_3)
    rl.UnloadTexture(spritesheet_4)
    rl.CloseAudioDevice()
    rl.CloseWindow()
}
