function new_reel()
    local reel = {}

    reel.symbol = flr(rnd(#symbols)) + 1
    reel.spinning = false
    reel.timer = 0

    return reel
end

function spin_reel(reel)
    sfx(0, -1, 0, 20)
    reel.spinning = true
    reel.timer = 30 + flr(rnd(30))
end

function update_reel(reel)
    if reel.spinning then
        reel.timer -= 1
        reel.symbol = flr(rnd(#symbols)) + 1

        if reel.timer <= 0 then
            reel.spinning = false
        end
    end
end

function draw_reel(reel,x,y)
    rectfill(x,y,x+30,y+30,1)

    local sym = symbols[reel.symbol]
    local col = symbol_colors[reel.symbol]

    print(sym,x+11,y+12,col)
end