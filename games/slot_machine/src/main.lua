name = ""
coins = 0
broke = false

function _init()
   serial(0x806, 0x9a00, 64)

    local text = ""

    for i=0,63 do
        local c = peek(0x9a00 + i)

        if c == 0 then
            break
        end

        text = text .. chr(c)
    end

    local pos

    for i=1,#text do
        if sub(text, i, i) == ":" then
            pos = i
            break
        end
    end

    if pos then
        name = sub(text, 1, pos - 1)
        coins = sub(text, pos + 1) + 0
    end

    if coins == 0 then
        broke = true
    end
end

function _update()
    if broke==false then
        if btnp(5) then
            start_spin()
        end

        if game_state == "idle" then
            if btnp(0) then
                bet = max(1, bet-1)
                sfx(1)
            end

            if btnp(1) then
                bet = min(coins, bet+1)
                sfx(1)
            end

            if bet > coins then
                bet = coins
            end

            if coins == 0 then
                broke = true
            end
        end

        update_game()
    end
end

function _draw()
    if broke==true then
        draw_broke_ui()
    else
        draw_ui()
    end
end