---powerups base class
powerups = actors:new({
	sprite = {0,24,8,8,0,0,0,0},
	hitbox = {5,6,1,2}
})

---initialize powerups
function powerups:init()
	powerups.lastspawn = 0
end

---powerups class constructor
function powerups:new(o)
	local powerup = o or actors:new(o)
	setmetatable(powerup, self)
	self.__index = self

	powerup.dcors = {}
	powerup.bubbles = {}

	return powerup
end

---spawn powerups
function powerups:spawn()
	local x = 0

	self.lastspawn = gameclock

	--spawn near player 1
	if(rnd() > .5) then
		x = min(level:get_xmax() - 16, p[1].x + rnd(64))
	else
		x = max(level:get_xmin(), p[1].x - rnd(64))
	end

	local props = {
		x = x,
		y = 0,

		state = 'idle',
		sclock = 0
	}

	if(rnd() < .30) then
		props.variant = 'health'
	else
		props.variant = 'berserker'
	end

	add(powerups, self:new(props))
end

