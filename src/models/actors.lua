---actor base class

--store the default actors table
actors = {
  --state = 'idle',
  --sclock = 0,
  --x = 0,
  --y = 0,
  --xdir = 1,
  --ydir = 1,
  --speed = 1,
  --rise = 8,
  --cors = {}
}

---actors class constructor
function actors:new(o)
  local actor = o or {}
  setmetatable(actor, self)
  self.__index = self

  return actor
end

--actor collision coordinates
function actors:get_xmin()
	return self.x + self.hitbox[3]
end

function actors:get_xmax()
	return self.x + self.hitbox[3] + self.hitbox[2] - 1
end

function actors:get_ymin()
	return self.y + self.hitbox[4]
end

function actors:get_ymax()
	return self.y + self.hitbox[4] + self.hitbox[1] - 1
end

