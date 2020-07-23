---enemies class model

--store default enemy table
e = actors:new({
	hitbox = {w=9,h=10,ox=3,oy=6},
	states = {
		default = {
			frames = {
				lpf = 3,
				sprites = {
					{sx=16,sy=16,sw=16,sh=16},
					{sx=32,sy=16,sw=16,sh=16},
					{sx=48,sy=16,sw=16,sh=16},
					{sx=64,sy=16,sw=16,sh=16},
					{sx=80,sy=16,sw=16,sh=16},
					{sx=96,sy=16,sw=16,sh=16},
					{sx=112,sy=16,sw=16,sh=16}
				}
			}
		},
		exploding = {
			frames = {
				lpf = 1,
				sprites = {
					{sx=0,sy=32,sw=32,sh=32},
					{sx=0,sy=32,sw=32,sh=32,dw=48,dh=48}
				},
				hitboxes = {
					{w=28,h=28,ox=2,oy=2},
					{w=42,h=42,ox=3,oy=3}
				}
			}
		}
	}
})

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
		if(enemy.x <= -(enemy.sprite.sw) or
			 enemy.x >= level:get_xmax() or
			 enemy.y >= (level.map.cely + level.map.celh) * 8 or
			 (enemy.state == 'exploding' and enemy.sclock > 30)
		) then
			del(self, enemy)
		end
	end
end

