---actors class controller

---update actor state
--function actors:update_state()
--  if(self.state == 'some_state') then
--    self:some_state()
--  elseif(self.state == 'some_other_state') then
--    self:some_other_state()
--  end
--end

---set actor state
function actors:set_state(state, no_update)
  self.state = state
  self.sclock = 0

  if(not no_update) then
    self:update_state()
  end
end

---update coroutines
function actors:update_cors(cors)
  for cor in all(cors) do
    if(costatus(cor) == 'suspended') then
      coresume(cor)
    elseif(costatus(cor) == 'dead') then
      del(cors, cor)
    end
  end
end

---solid map tile collision
function actors:get_coll_solid(axis, d, ndir)
  local d = d or 0
  local ndir = ndir or self[axis..'dir']

  if(ndir == 1) then
    d += self['get_'..axis..'max'](self)
  else
    d += self['get_'..axis..'min'](self)
  end

  if(axis == 'x') then
    local x = d

    for y = self:get_ymin(), self:get_ymax() - 1, 1 do
      if(is_solid(x,y)) then
        return get_cel(x) * 8
      end
    end
  else
    local y = d

    for x = self:get_xmin(), self:get_xmax() - 1, 1 do
      if(is_solid(x,y)) then
        return get_cel(y) * 8
      end
    end
  end
end

---get move distance
function actors:get_move(axis, d, in_bounds)
  local d = d or (self.speed * self[axis..'dir'])

  for i = d, 0, -sgn(d) do
    local c = self:get_coll_solid(axis, i)

    if(type(in_bounds) == 'function') then
      if(not c and
        in_bounds(self, i)
      ) then
        return i
      end
    elseif(not c) then
      return i
    end
  end

  return 0
end

