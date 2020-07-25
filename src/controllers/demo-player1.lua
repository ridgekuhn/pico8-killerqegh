---player 1 controllers

---update player 1 data
function p:update()
  self:update_cors(self.cors)

  self:get_input(self:get_input_holds())

  self.altitude = self:get_altitude()

  self.hits = self:get_hits(e)

  self.powerup = self:get_hits(powerups)

  self:update_state()

  self.sclock += 1
end

function p:get_input_holds()
  self.b4_hold = self.b4

  if(self.state ~= 'falling') then
    self.b5_hold = self.b5
  else
    self.b5_hold = false
  end
end

---check sprite collision
function p:get_hits(actors)
  local hits = {}

  for i=1, #actors do
    local hit, xmin, ymin, xmax, ymax = self:get_coll_aabb(actors[i])

    if(hit) then
      if(actors == e and
         actors[i].state ~= 'dead'
      ) then
        add(hits, {
          id = i,
          xmin = xmin,
          ymin = ymin,
          xmax = xmax,
          ymax = ymax
        })

      elseif(actors == powerups) then
        return i
      end
    end
  end

  if(#hits > 0) then
    return hits
  end
end

function p:get_x_boundary(dx)
  if(self.x + dx >= level:get_xmin() and
    self.x + dx <= level:get_xmax() - self.sprite[3]
  ) then
    return true
  end
end

---invincibility
function p:invincibility(t)
  local t = t or 60

  self.hits = nil
  self.invincible = true

  add(self.cors, cocreate(function()
    for i=1, t do
      self.invincible = true
      yield()
    end

    self.invincible = nil
  end))
end

--oneup bonus
function p:set_bonus()
  --track oneup bonus
  if(not self.oneup and
    (self.score - self.prevscore) + (self.prevscore % 10000) >= 10000
  ) then
    add(self.cors, cocreate(function()
      self.oneup = true
      self.lives += 1

      sfx(49)

      repeat
        yield()
      until((self.score - self.prevscore) + (self.prevscore % 10000) < 10000)

      self.oneup = nil
    end))

    add(hud_dcors, cocreate(function()
      for i=1, 60 do
        if(i % 10 < 5) then
          print_shadow(p[1].score, cam.x + 25, 1, 11)
          print_shadow('𝘹'..tostr(p[1].lives), cam.x + 120, 1, 11)
        end

        yield()
      end
    end))
  end
end

---controls player 1's state
function p:update_state()
  self.sprite, self.hitbox = self:get_frame()

  if(self.state == 'idle') then
    self:state_idle()
  elseif(self.state == 'running') then
    self:state_running()
  elseif(self.state == 'falling') then
    self:state_falling()
  elseif(self.state == 'jumping') then
    self:state_jumping()
  elseif(self.state == 'sliding') then
    self:state_sliding()
  elseif(self.state == 'hit') then
    self:state_hit()
  elseif(self.state == 'drinking') then
    self:state_drinking()
  elseif(self.state == 'berserker') then
    self:state_berserker()
  elseif(self.state == 'dead') then
    self:state_dead()
  end
end

---idle state
function p:state_idle()
  if(self:get_hit_state()) then
    self:set_state('hit')
    return
  end

  if(self.powerup) then
    self:set_state('drinking')
    return
  end

  if(self.altitude > 0) then
    self:set_state('falling')
    return
  end

  if(self.b0 or self.b1) then
    self:set_state('running')
    return
  end

  if((self.b4 and not self.b4_hold) and
    self.altitude == 0
  ) then
    self:set_state('jumping')
    return
  end

  if(self.b5 and not self.b5_hold) then
    self:set_state('sliding')
    return
  end
end

---running state
function p:state_running()
  if(self:get_hit_state()) then
    self:set_state('hit')
    return
  end

  if(self.powerup) then
    self:set_state('drinking')
    return
  end

  if(self.altitude > 0) then
    self:set_state('falling')
    return
  end

  if(not self.b0 and not self.b1) then
    self:set_state('idle')
    return
  elseif(self.b0) then
    self.xdir = -1
    self.x += self:get_move('x', nil, self.get_x_boundary)
  elseif(self.b1) then
    self.xdir = 1
    self.x += self:get_move('x', nil, self.get_x_boundary)
  end

  if((self.b4 and not self.b4_hold) and
    self.altitude == 0
  ) then
    self:set_state('jumping')
    return
  end

  if(self.b5 and not self.b5_hold) then
    self:set_state('sliding')
    return
  end
end

---falling state
function p:state_falling()
  if(self:get_hit_state()) then
    self:set_state('hit')
    return
  end

  if(self.powerup) then
    self:set_state('drinking')
    return
  end

  if(self.altitude == 0) then
    self:set_state('idle')
    return
  end

  if(self.sclock > 0) then
    if(self.b0) then
      self.xdir = -1
      self.x += self:get_move('x', nil, self.get_x_boundary)
    elseif(self.b1) then
      self.xdir = 1
      self.x += self:get_move('x', nil, self.get_x_boundary)
    end
  end

  self.ydir = 1
  self.y += self:get_fall()
end

---jumping state
function p:state_jumping()
  if(self:get_hit_state()) then
    self:set_state('hit')
    return
  end

  if(self.powerup) then
    self:set_state('drinking')
    return
  end

  if(not self.b4) then
    self:set_state('falling')
    return
  end

  if(self.b0) then
    self.xdir = -1
    self.x += self:get_move('x', nil, self.get_x_boundary)
  elseif(self.b1) then
    self.xdir = 1
    self.x += self:get_move('x', nil, self.get_x_boundary)
  end

  self.ydir = -1

  local dy = self:get_move('y', self:get_jump())

  if(dy == 0) then
    self:set_state('falling')
    return
  else
    self.y += dy
  end
end

---sliding state
function p:state_sliding()
  if(not self.b5 or
    (self.sclock > 8 and
    self.b5_hold)
  ) then
    self:set_state('idle')
    return
  end

  if(self.b4) then
    self:set_state('jumping')
    return
  end

  if(self.powerup) then
    self:set_state('drinking')
    return
  end

  --test next move
  local x = self.x
  local dx = self.xdir * self.speed * 2

  for i=0, dx, self.xdir do
    self.x = x + i
    self.hits = self:get_hits(e)

    if(self.hits and
       #self.hits > 0
    ) then
      for k,v in pairs(self.hits) do
        if(e[v.id].lead) then
          self.x = x
          self.x += self:get_move('x', i + -(self.xdir), self.get_x_boundary)
          return

        elseif(e[v.id].state ~= 'dead' and
          not e[v.id].justhit and
          e[v.id].altitude <= 8 and
          ((self.xdir == 1 and e[v.id]:get_xmax() >= self:get_xmax()) or
          (self.xdir == -1 and e[v.id].x <= self.x))
        ) then
          e[v.id]:hitbyplayer()

        elseif(e[v.id].state ~= 'dead' and
          not e[v.id].justhit and
          not self.invincible and
          ((self.xdir == 1 and e[v.id].x <= self.x + 8) or
          (self.xdir == -1 and e[v.id].x >= self.x + 8))
        ) then
          self.x = x
          self.x += self:get_move('x', i, self.get_x_boundary)

          self:set_state('hit')
          return
        end
      end
    end
  end

  self.x = x
  self.x += self:get_move('x', dx, self.get_x_boundary)
end

---check if state should
--change to hit state
function p:get_hit_state()
  if(self.hits and
     #self.hits > 0
  ) then
    for k,v in pairs(self.hits) do
      if(e[v.id].lead) then
        if(self.x < e[v.id].x) then
          self.x += self:get_move('x', v.xmin - v.xmax, self.get_x_boundary)
        else
          self.x += self:get_move('x', v.xmax - v.xmin, self.get_x_boundary)
        end

      elseif(not self.invincible and
        not e[v.id].justhit) then
        return true
      end
    end
  end
end

---hit state
function p:state_hit()
  if(self.sclock == 0) then
    sfx(10)

    self.health -= 20

  elseif(self.sclock > 15) then
    if(self.health <= 0) then
      self:set_state('dead')
      return
    else
      self:invincibility()

      self:set_state('idle')
      return
    end
  end
end

---drinking state
function p:state_drinking()
  if(self.powerup) then
    self.poweredby = powerups[self.powerup].variant

    del(powerups, powerups[self.powerup])
  end

  if(self.altitude > 0) then
    self.ydir = 1
    self.y += self:get_fall()
  end

  if(self.sclock == 30) then
    if(self.poweredby == 'berserker') then
      self.poweredby = nil

      self:set_state('berserker')
      return

    elseif(self.poweredby == 'health') then
      self.poweredby = nil

      self.health = min(100, self.health + 20)

      self:invincibility()

      add(hud_dcors, cocreate(function()
        local bars = ceil(self.health / 20)

        for j=1, 60 do
          if(j % 10 < 5) then
            print_shadow('spine', cam.x + 66, 1, 11)

            for i=0, bars - 1 do
              rectfill(cam.x + (i * 5) + 87, cam.y + 2, cam.x + (i * 5) + 88, cam.y + 4, 11)
            end
          end

          yield()
        end
      end))

      sfx(49)

      self:set_state('idle')
      return
    end
  end
end

---berserker state
function p:state_berserker()
  if(self.sclock == 30) then
    local t = 150
    local m = 2

    add(self.cors, cocreate(function()
      local ospeed = self.speed

      self.berserker = true

      if(level.music) then
        level:pause_music()
        music(32, 0, 11)
      end

      for i=1, t do
        self.speed = (ospeed * m) - ((m * i) / t)
        yield()
      end

      if(level.music and
        level.state == 'running'
      ) then
        level:resume_music()
      end

      self.speed = ospeed
      self.berserker = nil
    end))

    self:invincibility(150)

    self:set_state('idle')
    return
  end

  if(self.altitude == 0) then
    self.y -= 1
  end

  if(self.altitude > 0) then
    self.ydir = 1
    self.y += self:get_fall()
  end
end

---dead state
function p:state_dead()
  if(self.altitude > 0) then
    self.ydir = 1
    self.y += self:get_fall()
  end

  if(self.lives > 0 and self.altitude == 0 and self.sclock > 30) then
    if(self.b4 or self.b5) then
      self:spawn()
      self.lives -= 1

      self:invincibility(90)

      self:set_state('idle')
      return
    end
  end
end

