---powerups views

---draw to screen
function powerups:draw()
  for powerup in all(self) do
    powerup:spawn_bubbles()
    powerup:update_cors(powerup.bubbles)

    powerup:draw_shiny()
    powerup:update_cors(powerup.dcors)
    powerup:draw_state()

    pal()
  end
end

---draw bubbles
function powerups:spawn_bubbles()
  --bubbles
  if(gameclock % 3 == 0) then
    add(self.bubbles, cocreate(function()
      local x = self.x + 3.5 + 1.5 - rnd(3)
      local y = self.y + 3
      local r = 2
      local cstate = self.state
      local sclock = 0

      local color = 8

      if(self.variant == 'health') then
        color = 11
      end

      repeat
        if(cstate == 'falling') then
          y = y - .2 + get_gravity(sclock, .05)

          if(y > self.altitude + self.hitbox[2]) then
            return
          end
        else
          y -= .2
        end

        r -= .1
        sclock += 1

        if(not self.blink or
          self.sclock % self.blink ~= 0
        ) then
          circfill(x, y, r, color)
        end

        yield()
      until(r <= 0)
    end))
  end
end

---draw state
function powerups:draw_state()
  if(self.state ~= 'decaying') then
    self:draw_sprite()
  else
   self.blink = ceil((90 - self.sclock) / 720) + 1

    if(self.sclock % self.blink ~= 0) then
      self:draw_sprite()
    end
  end
end

---draw shinies
function powerups:draw_shiny()
  if(not self.shiny) then
    add(self.dcors, cocreate(function()
      self.shiny = true

      --flash
      for i=1, 30 do
        if(i % 10 < 5) then
          pal(11, 10)
        else
          pal(11, 1)
        end

        yield()
      end

      --shine
      for i=0, 31 do
        pal(11, 1)

        local x = flr(i / 4)

        for y=0, 7 do
          if(sget(self.sprite[1] + x, self.sprite[2] + y) == 5 or
             sget(self.sprite[1] + x, self.sprite[2] + y) == 6 or
             sget(self.sprite[1] + x, self.sprite[2] + y) == 7
          ) then
            pset(self.x + x, self.y + y, 10)
          end
        end

        yield()
      end

      --sparkle
      local r = 0

      repeat
        pal(11, 1)

        r += .5
        circ(self.x + 7, self.y + 2, r, 7)

        yield()
      until(r == 3)

      self.shiny = nil
    end))
  end
end
