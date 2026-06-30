function draw_ui()
    cls(3)

    print("slot machine",38,8,7)

    draw_reel(reels[1],16,40)
    draw_reel(reels[2],48,40)
    draw_reel(reels[3],80,40)

    print("coins: "..coins,8,95,11)
    print("bet: "..bet,8,105,10)

    if game_state == "idle" then
        print("❎ spin",80,105,7)
    else
        print("spinning...",72,105,8)
    end

    print("⬅️➡️ change bet",8,118,6)
end

function draw_broke_ui()
    rectfill(0,0,150,150,0)
    print("You are broke", 40, 40, 8)
end