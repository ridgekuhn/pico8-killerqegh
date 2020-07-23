---enemies class controllers

---update enemies
function e:update()
	self:update_cors(self.cors)

	for enemy in all(self) do
		enemy:update_cors(enemy.cors)

		enemy.altitude = enemy:get_altitude()

		enemy:update_state()

		if(enemy.state ~= 'exploding') then
			enemy.sprite = enemy:get_frame(enemy.states.default.frames, enemy.aclock)
		else
			enemy.sprite, enemy.hitbox = enemy:get_frame()
		end

		if(enemy.tnt) then
			enemy.tnt -= 1
		end

		enemy.sclock += 1
		enemy.aclock += 1
	end

	self:delete()
end

---reverse x direction
function e:revx()
	self.xdir *= -1
	self.speed = max(0.5, self.speed - (self.speed / 2))
end

---bounce off level boundary
function e:lvlbounce()
	local xmin = level:get_xmin()
	local xmax = level:get_xmax() - 16

	if(self.x <= xmin) then
		self.x = xmin
		self:revx()

	elseif(self.x >= xmax) then
		self.x = xmax
		self:revx()
	end
end

---enemy state controllers
function e:update_state()
	if(self.state == 'idle') then
		self:state_idle()
	elseif(self.state == 'falling') then
		self:state_falling()
	elseif(self.state == 'jumping') then
		self:state_jumping()
	elseif(self.state == 'roaming') then
		self:state_roaming()
	elseif(self.state == 'dead') then
		self:state_dead()
	elseif(self.state == 'exploding') then
		self:state_exploding()
	end
end

---idle state
function e:state_idle()
	if(self.altitude > 0) then
		self:set_state('falling')
	end
end

--falling state
function e:state_falling()
	if(self.altitude == 0 and self.rise == 0) then
		self.speed = max(0.5, self.speed - (self.speed / 2))

		if(self.lead) then
			sfx(9)
		end

		self:set_state('roaming')
		return
	end

	self.ydir = 1
	self.y += self:get_fall()

	if(not self.firstfall) then
		local dx = self:get_move('x')

		if(dx ~= 0) then
			self.x += dx

			self:lvlbounce()

		elseif(dx == 0) then
			self.xdir *= -1
			self.speed = max(0.5, self.speed - (self.speed / 2))
			self.x += self:get_move('x')
		end
	end

	if(self.altitude == 0 and self.rise > 0) then
		self.firstfall = nil
		self.rise *= .75
		if(self.rise < 1) then
			self.rise = 0
		end

		self:set_state('jumping')
		return
	end
end

--jumping state
function e:state_jumping()
	if(self.rise == 0) then
		self:set_state('roaming')
		return
	end

	self.ydir = -1

	local dy = self:get_move('y', self:get_jump())

	if(dy == 0) then
		self:set_state('falling')
		return
	else
		self.y += dy
	end

	local dx = self:get_move('x')

	if(dx ~= 0) then
		self.x += dx

		self:lvlbounce()

	elseif(dx == 0) then
		self.xdir *= -1
		self.speed = max(0.5, self.speed - (self.speed / 2))
		self.x += self:get_move('x')
	end
end

--roaming state
function e:state_roaming()
	if(self.lead) then
		self.x += self.speed * self.xdir
		return
	end

	if(self.altitude > 0) then
		self.rise = min(8, self.altitude / 4)
		self:set_state('falling')
		return
	end

	if(self.tnt and self.tnt <= 0) then
		self:set_state('exploding')
		return
	end

	local dx = self:get_move('x')

	if(dx ~= 0) then
		self.x += dx

		self:lvlbounce()

	elseif(dx == 0) then
		self:revx()
		self.x += self:get_move('x')
	end
end

--exploding state
function e:state_exploding()
	--move to match expolosion
	--sprite frames
	if(self.sclock == 0) then
		self.x -= 8
		self.y -= 6

		cam.shake = 2

		sfx(50)

	elseif(self.sclock == 1) then
		self.x -= 8
		self.y -= 8
	elseif(self.sclock > 1) then
		if(self.sclock % 2 == 0) then
			self.x += 8
			self.y += 8
		else
			self.x -= 8
			self.y -= 8
		end
	end

	local self_i = 0

	for i=1, #e do
		if(e[i] ~= self and
			self:get_coll_aabb(e[i])
		) then
			if(e[i].tnt) then
				if(e[i].state ~= 'exploding') then
					e[i]:set_state('exploding')
				end

			elseif(self.sclock <= 5 and
						 e[i].state ~= 'dead'
			) then
				e[i].rise = 10
				e[i]:set_state('jumping')
			end
		end
	end
end

---hit by player
function e:hitbyplayer()
	if(self.tnt and
		 self.state ~= 'exploding'
	) then
		self.state = 'exploding'
		self.sclock = 0
		return

	elseif(self.tnt and
		self.state == 'exploding'
	) then
		return

	elseif(self.bouncy and self.bouncy > 0) then
		self.y = p[1].y
		self.xdir = p[1].xdir
		self.speed = 3
		self.bouncy -= 1
		self.rise = min(12, 13 - (self.bouncy * self.bouncy))

		self.justhit = true
		add(self.cors, cocreate(function()
			repeat
				yield()
			until(not self:get_coll_aabb(p[1]))

			self.justhit = nil
		end))

		p[1].prevscore = p[1].score
		p[1].score += 50

		add(ptflags, ptflags:new({
			x = self.x,
			y = self.y,
			pts = 50
		}))

		p[1]:set_bonus()

		sfx(51)

		self.firstfall = nil
		self.state = 'jumping'
		self.sclock = 0
		return

	else
		self.y = p[1].y
		self.xdir = p[1].xdir

		p[1].prevscore = p[1].score
		p[1].score += 100

		add(ptflags, ptflags:new({
			x = self.x,
			y = self.y,
			pts = 100
		}))

		p[1]:set_bonus()

		sfx(11)

		self.state = 'dead'
		self.sclock = 0

		level.eremaining -= 1
	end
end

---dead state
function e:state_dead()
	self.x += (self.xdir * 4)
	self.y -= 3
end

