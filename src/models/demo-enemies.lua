---enemies class model

--store default enemy table
e = actors:new({
  hitbox = {10,9,3,6},
  states = {
    default = {
      frames = {
        lpf = 3,
        sprites = {
					'16,16,16,16,0,0,0,0',
					'32,16,16,16,0,0,0,0',
					'48,16,16,16,0,0,0,0',
					'64,16,16,16,0,0,0,0',
					'80,16,16,16,0,0,0,0',
					'96,16,16,16,0,0,0,0',
					'112,16,16,16,0,0,0,0'
        }
      }
    },
    exploding = {
      frames = {
        lpf = 1,
        sprites = {
					'0,32,32,32,0,0,0,0',
					'0,32,32,32,0,0,0,0,48,48'
        },
        hitboxes = {
					'28,28,2,2',
					'42,42,3,3'
        }
      }
    }
  }
})

e:deserialize_frames()

--initialize enemies
function e:init()
  --reset dirty spawn table
  self.cors = {}
end

---enemies class contructor
function e:new(o)
  local enemy = o or actors:new(o)
  setmetatable(enemy, self)
  self.__index = self

  enemy.state = 'idle'
  enemy.sclock = 0
  enemy.aclock = 0

  enemy.cors = {}
  enemy.dcors = {}

  return enemy
end

---spawn enemies
function e:spawn(variant, arg)
  local x = 0
  local xdir = 1

  --spawn near player 1
  if(rnd() > .5) then
    x = min(level:get_xmax() - 16, p[1].x + rnd(64))
  else
    x = max(level:get_xmin(), p[1].x - rnd(64))
  end

  --track player
  if(x > p[1].x) then
    xdir = -1
  end

  --properties
  local props = {
    x = x,
    y = 0,
    xdir = xdir,
    speed = max(1, rnd(level.maxspeed)),
    rise = 10,
    firstfall = true,
  }

  --variants
  if(variant == 'tnt') then
    props.tnt = 90

  elseif(variant == 'bouncy') then
    local arg = arg or 1

    props.bouncy = ceil(rnd(arg))

    props.rise = min(12, 13 - (arg * arg))
    props.speed = max(.5,rnd())

  elseif(variant == 'lead') then
    props.lead = true
    props.rise = 0
    props.speed = .5
  end

  add(self.cors, cocreate(function()
    for i=1, ceil(rnd(level.spawnrate)) do
      yield()
    end

    add(e, e:new(props))
  end))
end

---delete enemies
function e:delete()
  for enemy in all(self) do
    if(enemy.x <= -(enemy.sprite[3]) or
       enemy.x >= level:get_xmax() or
       enemy.y >= (level.map.cely + level.map.celh) * 8 or
       (enemy.state == 'exploding' and enemy.sclock > 30)
    ) then
      del(self, enemy)
    end
  end
end

