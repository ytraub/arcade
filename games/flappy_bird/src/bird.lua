bird={}

function bird_init()
 bird.x=32
 bird.y=64
 bird.vel=0
 bird.r=3
end

function bird_update()

 bird.vel+=gravity

if btnp(4,flyer) or btnp(5,flyer) then
   bird.vel=jump_vel
  end

 bird.y+=bird.vel

end

function bird_draw()
 circfill(bird.x,bird.y,bird.r,11)
end