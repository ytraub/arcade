function make_player()
    player = {}

    player.score = 0

    reset_player()
end

function reset_player()
    set_player_position(7, 0, 1)

    player.variant = get_random_variant()

    player.frames = 0
    player.speed = 0.1

    player.lock_timer = 0
    player.lock_frames = 15

    player.gravity_timer = 0
    player.gravity_delay = 10
end

function set_player_position(x, y, rotation)
    player.x = x
    player.y = y
    player.new_x = x
    player.new_y = y

    player.rotation = rotation
end

function move_player()
    player.gravity_timer += 1

    if player.gravity_timer >= player.gravity_delay then
        player.gravity_timer = 0
        player.new_y = player.y + 1

        player.score += flr((10 - player.gravity_delay) * 0.2) + 1
    end

    if btnp(0) then player.new_x = player.x - 1 end
    if btnp(1) then player.new_x = player.x + 1 end
    if btnp(2) then rotate() end

    if not player.new_x == player.x or not player.new_x == player.y then
        player.lock_timer = 0
    end

    if not block_collides(player.variant, player.rotation, player.x, player.new_y) then
        player.y = player.new_y
    else
        player.lock_timer += 1

        if player.lock_timer >= player.lock_frames then
            local data = get_rotation_data(player.rotation)
    
            for _, offset in ipairs(data) do
                local x = player.x + offset[1]
                local y = player.y + offset[2]
                grid[y][x] = {
                    variant = player.variant,
                    rotation = player.rotation
                }
            end
    
            reset_player()
        end

    end

    if not block_collides(player.variant, player.rotation, player.new_x, player.y)
            and player.new_x + get_left_most(player.rotation) >= 0
            and player.new_x + get_right_most(player.rotation) <= 15 then
        player.x = player.new_x
    end

    player.gravity_delay = btn(3) and 2 or 10
end

function rotate()
    local new_rotation = (player.rotation % 4) + 1
    local new_x = player.x

    local left = get_left_most(new_rotation)
    local right = get_right_most(new_rotation)

    if new_x + left < 0 then
        new_x += -(new_x + left)
    elseif new_x + right > 15 then
        new_x -= (new_x + right - 15)
    end

    if not block_collides(player.variant, new_rotation, new_x, flr(player.y)) then
        player.rotation = new_rotation
        player.x = new_x
    end
end

function draw_points()
    print(pad_number(player.score, 6), 8, 6, 8)
end