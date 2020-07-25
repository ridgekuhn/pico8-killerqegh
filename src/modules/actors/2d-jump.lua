--******
--models
--******
---2d jump
function actors:get_altitude()
  for i=1, 127, 8 do
    local c = self:get_coll_solid('y', i, 1)

    if(c) then
      return c - self:get_ymax() - 1
    end
  end

  return -1
end

--***********
--controllers
--***********
---fall distance
function actors:get_fall(m)
  local dy = get_gravity(self.sclock, m)

  if(dy > self.altitude) then
    return self.altitude
  end

  return dy
end

---jump distance
function actors:get_jump(rise, m)
  local rise = rise or self.rise
  local decel = get_gravity(self.sclock, m)

  if(decel >= rise) then
    return 0
  else
    return -(rise - get_gravity(self.sclock))
  end
end

