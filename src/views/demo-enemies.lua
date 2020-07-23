---enemies class views

---draw enemies to screen
function e:draw()
  for enemy in all(self) do
    enemy:draw_shadow()

    if(enemy.tnt) then
      enemy:draw_tnt()

    elseif(enemy.bouncy) then
      enemy:draw_bouncy()

    elseif(enemy.lead) then
      pal(12, 13)
      enemy:draw_sprite()

    else
      enemy:draw_sprite()
    end

    enemy:update_cors(enemy.dcors)

    pal()
  end
end

function e:draw_shadow()
  if(self.altitude > 0) then
    local length = max(1, 120 / self.altitude)

    if(length > 6) then
      length = 6
    end

    local ox = (16 / length) + 1

    if(self.xdir == 1) then
      ox += 1
    end

    line(self.x + ox, 119, self.x + ox + length, 119, 1)
  end
end

function e:draw_tnt()
  pal(12, 8)

  self:draw_sprite()

  if(self.state ~= 'exploding') then
    --timer
    local timer = ceil(self.tnt / 30)
    local xmod = 6

    if(self.xdir == -1) then
      xmod = 7
    end

    if(timer == 1) then
      if(self.sclock % 2 == 0) then
        print_shadow(timer, self.x + xmod, self.y + 8, 8)
      else
        print_shadow(timer, self.x + xmod, self.y + 8, 9)
      end
    else
      print_shadow(timer, self.x + xmod, self.y + 8)
    end

    self:draw_smoke(7, 6)
  end
end

function e:draw_bouncy()
  if(self.bouncy == 1) then
    pal(12, 9)
  elseif(self.bouncy == 2) then
    pal(12, 10)
  elseif(self.bouncy > 2) then
    pal(12, 7)
  end

  self:draw_sprite()
  pal()
end
