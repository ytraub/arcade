gamestate="play"

user1 = ""
user2 = ""
coins1 = 0
coins2 = 0
flyer = 0

function start_game()
 bird_init()
 reset_pillars()
 p2_timer=0
 gamestate="play"
end

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

    
    local parts=split(text,":")

    if #parts>=4 then
        user1=parts[1]
        coins1=parts[2]+0
        user2=parts[3]
        coins2=parts[4]+0
    end

 start_game()
end

function _update()

 if gamestate=="play" then

  bird_update()
  update_pillars()
  update_p2()

  if check_collision() then
   gamestate="gameover"
    
    if flyer==0 then
        local output = user1 .. ":" .. (coins1 + score)
        printh(output, "receive.txt", true)
    else
        local output = user2 .. ":" .. (coins2 + score)
        printh(output, "receive.txt", true)
    end

   flyer = 1-flyer
  end

 elseif gamestate=="gameover" then
  if btnp(4) or btnp(5) then
   start_game()
  end

 end
end

function _draw()

 cls()

 draw_pillars()
 bird_draw()


    if flyer==0 then
        print("p1 flying",2,20,11)
        print("p2 sabotaging",2,28,8)
    else
        print("p2 flying",2,20,11)
        print("p1 sabotaging",2,28,8)
    end

    if flyer==0 then
        print("score (" .. user1 .. "): "..score,2,2,7)
    else
        print("score (" .. user2 .. "): "..score,2,2,7)
    end

 if gamestate=="gameover" then

  rectfill(20,50,108,78,0)

  print("game over",40,55,8)
  print("score "..score,45,65,7)
  print("press x",35,72,7)

 end
end