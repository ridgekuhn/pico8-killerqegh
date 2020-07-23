---game level model

level = {
  map = {
    celx = 0,
    cely = 0,
    sx = 0,
    sy = 0,
    celw = 24,
    celh = 16
  }
}

---initialize level
function level:init()
  level.state = 'start'
  level.sclock = 0
  level.current = cfg.level or 1
  self:get_difficulty()
  level.music = cfg.music
end

---calculate difficulty
function level:get_difficulty()
  self.spawnrate = max(45, 60 - (self.current * 2))
  self.maxspeed = min(4, max(1, self.current / 3))
  self.etospawn = min(50, max(10, self.current * 5))
  self.eremaining = self.etospawn
  self.tnt = min(.25, self.current * .03)
  self.powerups = 1/900
  self.bouncy = min(.5, self.current * .04)
  self.lead = .1
end

function level:get_xmin()
	return level.map.celx * 8
end

function level:get_xmax()
	return (level.map.celx + level.map.celw) * 8
end

function level:get_ymin()
	return level.map.cely * 8
end

function level:get_ymax()
	return (level.map.cely + level.map.celh) * 8
end
