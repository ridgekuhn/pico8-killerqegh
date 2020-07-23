---powerups controllers

---update powerups
function powerups:update()
	for powerup in all(self) do
		powerup.altitude = powerup:get_altitude()

		powerup:update_state()

		powerup.sclock += 1
	end
end

---update powerups state
function powerups:update_state()
	if(self.state == 'idle') then
		self:state_idle()
	elseif(self.state == 'falling') then
		self:state_falling()
	elseif(self.state == 'decaying') then
		self:state_decaying()
	end
end

---idle state
function powerups:state_idle()
	if(self.altitude > 0) then
		self:set_state('falling')
		return
	end

	if(self.sclock == 30) then
		self:set_state('decaying')
	end
end

---falling state
function powerups:state_falling()
	if(self.altitude == 0) then
		self:set_state('idle')
	end

	self.ydir = 1
	self.y += self:get_fall(.05)
end

---decaying state
function powerups:state_decaying()
	if(self.sclock >= 90) then
		del(powerups, self)
	end
end
