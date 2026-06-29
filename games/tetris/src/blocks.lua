cellsize = 4

block_variants = {
    ["I"] = {
        costume = 0,
        rotations = {
            {
                { 0, 0 }, { 0, 1 }, { 0, 2 }, { 0, 3 }
            },
            {
                { -1, 1 }, { 0, 1 }, { 1, 1 }, { 2, 1 }
            },
            {
                { 0, 0 }, { 0, 1 }, { 0, 2 }, { 0, 3 }
            },
            {
                { -1, 1 }, { 0, 1 }, { 1, 1 }, { 2, 1 }
            }
        }
    },
    ["J"] = {
        costume = 3,
        rotations = {
            {
                { 0, 2 }, { 1, 0 }, { 1, 1 }, { 1, 2 }
            },
            {
                { 0, 0 }, { 0, 1 }, { 1, 1 }, { 2, 1 }
            },
            {
                { 0, 0 }, { 0, 1 }, { 0, 2 }, { 1, 0 }
            },
            {
                { 0, 1 }, { 1, 1 }, { 2, 1 }, { 2, 2 }
            }
        }
    },
    ["L"] = {
        costume = 6,
        rotations = {
            {
                { 0, 0 }, { 1, 0 }, { 1, 1 }, { 1, 2 }
            },
            {
                { 0, 1 }, { 1, 1 }, { 2, 1 }, { 2, 0 }
            },
            {
                { 0, 0 }, { 0, 1 }, { 0, 2 }, { 1, 2 }
            },
            {
                { 0, 1 }, { 1, 1 }, { 2, 1 }, { 0, 2 }
            }
        }
    },
    ["O"] = {
        costume = 4,
        rotations = {
            {
                { 0, 0 }, { 0, 1 }, { 1, 0 }, { 1, 1 }
            },
            {
                { 0, 0 }, { 0, 1 }, { 1, 0 }, { 1, 1 }
            },
            {
                { 0, 0 }, { 0, 1 }, { 1, 0 }, { 1, 1 }
            },
            {
                { 0, 0 }, { 0, 1 }, { 1, 0 }, { 1, 1 }
            }
        }
    },
    ["S"] = {
        costume = 1,
        rotations = {
            {
                { 1, 0 }, { 2, 0 }, { 0, 1 }, { 1, 1 }
            },
            {
                { 0, 0 }, { 0, 1 }, { 1, 1 }, { 1, 2 }
            },
            {
                { 1, 0 }, { 2, 0 }, { 0, 1 }, { 1, 1 }
            },
            {
                { 0, 0 }, { 0, 1 }, { 1, 1 }, { 1, 2 }
            }
        }
    },
    ["T"] = {
        costume = 2,
        rotations = {
            {
                { 1, 0 }, { 0, 1 }, { 1, 1 }, { 2, 1 }
            },
            {
                { 1, 0 }, { 1, 1 }, { 2, 1 }, { 1, 2 }
            },
            {
                { 0, 1 }, { 1, 1 }, { 2, 1 }, { 1, 2 }
            },
            {
                { 1, 0 }, { 0, 1 }, { 1, 1 }, { 1, 2 }
            }
        }
    },
    ["Z"] = {
        costume = 5,
        rotations = {
            {
                { 0, 0 }, { 1, 0 }, { 1, 1 }, { 2, 1 }
            },
            {
                { 1, 0 }, { 0, 1 }, { 1, 1 }, { 0, 2 }
            },
            {
                { 0, 0 }, { 1, 0 }, { 1, 1 }, { 2, 1 }
            },
            {
                { 1, 0 }, { 0, 1 }, { 1, 1 }, { 0, 2 }
            }
        }
    }
}

function make_blocks()
    grid = {}
    keys = {}

    for y = 0, 31 do
        grid[y] = {}
        for x = 2, 13 do
            grid[y][x] = nil
        end
    end

    for k, _ in pairs(block_variants) do
        add(keys, k)
    end
end

function get_random_variant()
    return keys[flr(rnd(#keys)) + 1]
end

function draw_blocks()
    for y = 0, 31 do
        for x = 2, 13 do
            local cell = grid[y][x]
            if cell then
                draw_block_cell(cell.variant, x, y)
            end
        end
    end
end

function draw_block(variant, rotation, x, y)
    local block = block_variants[variant]
    local rotation_data = block.rotations[rotation]
    for _, offset in ipairs(rotation_data) do
        spr(block.costume, ((offset[1] + x) * cellsize) + 31, (offset[2] + y) * cellsize)
    end
end 

function get_rotation_data(rotation) return block_variants[player.variant].rotations[rotation] end

function draw_block_cell(variant, x, y)
    local costume = block_variants[variant].costume
    spr(costume, (x * cellsize) + 31, y * cellsize)
end

function get_rotation_data(rotation)
    return block_variants[player.variant].rotations[rotation]
end

function get_left_most(rotation)
    local data = get_rotation_data(rotation)
    local extreme = 0

    for _, offset in ipairs(data) do
        local v = offset[1]

        if extreme > v then
            extreme = v
        end
    end

    return extreme
end

function get_right_most(rotation)
    local data = get_rotation_data(rotation)
    local extreme = 0

    for _, offset in ipairs(data) do
        local v = offset[1]

        if extreme < v then
            extreme = v
        end
    end

    return extreme
end

function block_collides(variant, rotation, x, y)
    local data = block_variants[variant].rotations[rotation]

    for _, offset in ipairs(data) do
        local px = x + offset[1]
        local py = y + offset[2]

        if py > 31 or px < 2 or px > 13 then
            return true
        end

        if grid[py][px] then
            return true
        end
    end

    return false
end

function is_row_full(y)
    for x = 2, 13 do
        if not grid[y][x] then
            return false
        end
    end
    return true
end

function clear_row(y)
    for x = 2, 13 do
        grid[y][x] = nil
    end
end

function shift_rows_down(start_y)
    for y = start_y - 1, 0, -1 do
        for x = 2, 13 do
            grid[y + 1][x] = grid[y][x]
            grid[y][x] = nil
        end
    end
end

function clear_full_rows()
    local y = 31
    local i = 0

    while y >= 0 do
        if is_row_full(y) then
            clear_row(y)
            shift_rows_down(y)

            i += 1
        else
            y -= 1
        end
    end

    player.score += (i * 100) + (i * (i - 1)) * 100
end