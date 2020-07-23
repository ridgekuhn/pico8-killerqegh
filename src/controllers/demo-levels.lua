---game level controllers

---update level
function level:update()
	self:update_state()

	if(p[1].state ~= 'dead') then
		self.sclock += 1
	end
end

---pause music
function level:pause_music()
	if(stat(24) > 11 and
		 stat(24) < 32) then
		level.music = stat(24)
		music(-1)
	end
end

---resume music
function level:resume_music()
	if(type(level.music) == 'number') then
		music(level.music, 3000, 11)
	else
		music(12, 0, 11)
	end
end

---update level state
function level:update_state()
	if(self.state == 'start') then
		self:update_start()
		self.draw = self.draw_start

	elseif(self.state == 'running') then
		self:update_running()
		self.draw = self.draw_running

	elseif(self.state == 'over') then
		self:update_over()
		self.draw = self.draw_over
	end
end

function level:update_start()
	if(self.sclock == 90) then
		sfx(13)

		actors.set_state(self, 'running')
		return

	elseif(self.sclock % 30 == 0) then
		sfx(12)
	end

	if(level.music and
		 stat(24) == 11 and
		 stat(26) >= 210
	) then
		self:resume_music()
	end
end

function level:update_running()
	if(self.eremaining == 0 and
		 self.etospawn == 0 and
		 #e == 0
	) then
		self:pause_music()

		actors.set_state(self, 'over')
		return
	end

	self:spawn_enemies()
	self:spawn_powerups()
end

function level:update_over()
	if(self.sclock == 0) then
		music(11, 0, 11)

	elseif(self.sclock == 90) then
		self.current += 1

		self:get_difficulty()

		actors.set_state(self, 'start')
		return
	end
end

---spawn enemies
function level:spawn_enemies()
	if(p[1].state ~= 'dead' and
		 self.etospawn > 0 and
		 self.sclock % self.spawnrate == 0
	) then

		if(self.current == 1) then
			e:spawn()
			self.etospawn -=1

		elseif(self.current == 2) then
			if(rnd() < self.bouncy) then
				e:spawn('bouncy')
				self.etospawn -= 1
			else
				e:spawn()
				self.etospawn -=1
			end

		elseif(self.current == 3) then
			if(rnd() < self.bouncy) then
				e:spawn('bouncy')
				self.etospawn -= 1
			elseif(rnd() < self.lead) then
				e:spawn('lead')
			else
				e:spawn()
				self.etospawn -=1
			end

		elseif(self.current == 4) then
			if(rnd() < self.bouncy) then
				e:spawn('bouncy')
				self.etospawn -= 1
			elseif(rnd() < self.lead) then
				e:spawn('lead')
			elseif(rnd() < self.tnt) then
				e:spawn('tnt')
			else
				e:spawn()
				self.etospawn -=1
			end

		elseif(self.current == 5) then
			if(rnd() < self.bouncy) then
				e:spawn('bouncy', 2)
				self.etospawn -= 1
			elseif(rnd() < self.lead) then
				e:spawn('lead')
			elseif(rnd() < self.tnt) then
				e:spawn('tnt')
			else
				e:spawn()
				self.etospawn -=1
			end

		elseif(self.current > 5) then
			if(rnd() < self.bouncy) then
				e:spawn('bouncy', 3)
				self.etospawn -= 1
			elseif(rnd() < self.lead) then
				e:spawn('lead')
			elseif(rnd() < self.tnt) then
				e:spawn('tnt')
			else
				e:spawn()
				self.etospawn -=1
			end
		end
	end
end

function level:spawn_powerups()
	if(level.state == 'running' and
		 rnd() < self.powerups and
		 gameclock - powerups.lastspawn > 900
	) then
		powerups:spawn()
	end
end
