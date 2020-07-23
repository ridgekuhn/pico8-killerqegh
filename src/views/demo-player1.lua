---player 1 views

---draws player 1 to screen
function p:draw()
  if(self.berserker) then
    self:draw_berserker()
  elseif(self.invincible) then
    self:draw_invincible()
  else
    self:draw_sprite()
  end

  self:update_cors(self.dcors)
end

function p:draw_berserker()
  if(self.sclock % 2 == 0) then
    pal(4, 8)

    self:draw_sprite()

    pal()
  end

  if(self.xdir == 1) then
    self:draw_smoke(5, 4)
  else
    self:draw_smoke(10, 4)
  end
end

function p:draw_invincible()
  if(self.sclock % 2 == 0 and
     self.state ~= 'hit' and
     self.state ~= 'berserker'
  ) then
    return
  else
    self:draw_sprite()
  end
end

