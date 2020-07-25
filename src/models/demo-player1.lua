--t
---player 1 model

--describe default player properties
p.states = {
	idle = {
		frames = {
			lpf = 1,
			sprites = {
				'0,0,16,16,0,0,0,0'
			},
			hitboxes = {
				'16,6,5,0'
			}
		}
	},
	jumping = {
		frames = {
			lpf = 1,
			sprites = {
				'64,0,16,16,0,0,0,0'
			},
			hitboxes = {
				'16,6,5,0'
			}
		}
	},
	running = {
		frames = {
			lpf = 5,
			rev = true,
			sprites = {
				'16,0,16,16,0,0,0,0',
				'32,0,16,16,0,0,0,0',
				'48,0,16,16,0,0,0,0'
			},
			hitboxes = {
				'16,6,5,0',
				'16,6,5,0',
				'16,6,5,0'
			}
		}
	},
	sliding = {
		frames = {
			lpf = 1,
			sprites = {
				'112,0,16,16,0,0,0,0'
			},
			hitboxes = {
				'15,15,1,2'
			}
		}
	},
	hit = {
		frames = {
			lpf = 1,
			sprites = {
				'80,0,16,16,0,0,0,0'
			},
			hitboxes = {
				'16,6,5,0'
			}
		}
	},
	drinking = {
		frames = {
			lpf = 5,
			sprites = {
				'32,32,16,16,0,0,0,0',
				'48,32,16,16,0,0,0,0'
			},
			hitboxes = {
				'16,6,5,0',
				'16,6,5,0'
			}
		}
	},
	berserker = {
		frames = {
			lpf = 1,
			sprites = {
				'64,32,16,16,0,0,0,0'
			},
			hitboxes = {
				'16,6,5,0'
			}
		}
	},
	dead = {
		frames = {
			lpf = 1,
			sprites = {
				'96,0,16,16,0,0,0,0'
			},
			hitboxes = {
				'5,16,0,9'
			}
		}
	}
}

p:deserialize_frames()

p.states.falling = p.states.jumping

--instantiate player 1

---initialize player
function p:init()
  p[1] = p:new({
    x = 0,
		speed = 2,
		rise = 8,

    lives = 3,
    score = 0,
    prevscore = 0,

		state = 'idle',
		sclock = 0
  })

	p[1].sprite, p[1].hitbox = p[1]:get_frame()

  p[1]:spawn()
end

---spawn player
function p:spawn()
  self.health = 100

	--reset dirty collisions
  self.powerup = nil
  self.hits = nil

  self.y = 0
  self.altitude = self:get_altitude()
end

