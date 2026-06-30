p2_timer=0

function get_target_pillar()

 local target=nil
 local best=9999

 for p in all(pillars) do
  if p.x > bird.x and p.x < best then
   best=p.x
   target=p
  end
 end

 return target

end

function update_p2()

 if p2_timer>0 then
  p2_timer-=1
 end

 local target=get_target_pillar()

 if not target then return end

 if p2_timer<=0 then

  if btnp(2,1-flyer) then
   target.gap_y-=3
   p2_timer=shift_cooldown

  elseif btnp(3,1-flyer) then
   target.gap_y+=3
   p2_timer=shift_cooldown
  end

  target.gap_y=mid(
   gap_h/2+8,
   target.gap_y,
   127-gap_h/2-8
  )

 end

end
