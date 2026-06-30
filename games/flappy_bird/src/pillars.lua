pillars={}
score=0

function reset_pillars()
 pillars={}
 score=0

 for i=0,3 do
  add(pillars,{
   x=128+i*48,
   gap_y=rnd(60)+20,
   passed=false
  })
 end
end

function get_furthest_pillar_x()
 local max_x=0

 for p in all(pillars) do
  if p.x>max_x then
   max_x=p.x
  end
 end

 return max_x
end

function update_pillars()
 for p in all(pillars) do
  p.x-=pillar_speed

  if not p.passed and p.x+pillar_w<bird.x then
   p.passed=true
   score+=1
   sfx(1)
  end
  
    if p.x < -pillar_w then
        local furthest=get_furthest_pillar_x()

        p.x=furthest+48
        p.gap_y=20+rnd(88)
        p.passed=false
    end
 end
end

function draw_pillars()
 for p in all(pillars) do

  rectfill(
   p.x,
   0,
   p.x+pillar_w,
   p.gap_y-gap_h/2,
   3
  )

  rectfill(
   p.x,
   p.gap_y+gap_h/2,
   p.x+pillar_w,
   127,
   3
  )
 end
end

function check_collision()

 if bird.y<0 or bird.y>127 then
  return true
 end

 for p in all(pillars) do

  local inside_x=
   bird.x+bird.r>p.x and
   bird.x-bird.r<p.x+pillar_w

  if inside_x then

   if bird.y-bird.r<p.gap_y-gap_h/2 then
    return true
   end

   if bird.y+bird.r>p.gap_y+gap_h/2 then
    return true
   end
  end
 end

 return false
end
