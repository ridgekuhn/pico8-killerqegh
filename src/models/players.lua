---players class model
p = actors:new()

---players class constructor
function p:new(o)
  local player = o or actors:new(o)
  setmetatable(player, self)
  self.__index = self

  player.index = #p + 1

  player.cors = {}
  player.dcors = {}

  return player
end

