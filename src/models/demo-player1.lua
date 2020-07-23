--t
---player 1 model

--describe default player properties
p.defaulthitbox = {w=6,h=16,ox=5,oy=0}

p.states = {
	idle = {
		frames = {
			lpf = 1,
			sprites = {
				{sx=0,sy=0,sw=16,sh=16}
			},
			hitboxes = {
				p.defaulthitbox
			}
		}
	},
	jumping = {
		frames = {
			lpf = 1,
			sprites = {
				{sx=64,sy=0,sw=16,sh=16}
			},
			hitboxes = {
				p.defaulthitbox
			}
		}
	},
	running = {
		frames = {
			lpf = 5,
			rev = true,
			sprites = {
				{sx=16,sy=0,sw=16,sh=16},
				{sx=32,sy=0,sw=16,sh=16},
				{sx=48,sy=0,sw=16,sh=16}
			},
			hitboxes = {
				p.defaulthitbox,
				p.defaulthitbox,
				p.defaulthitbox
			}
		}
	},
	sliding = {
		frames = {
			lpf = 1,
			sprites = {
				{sx=112,sy=0,sw=16,sh=16}
			},
			hitboxes = {
				{w=14,h=14,ox=1,oy=2}
			}
		}
	},
	hit = {
		frames = {
			lpf = 1,
			sprites = {
				{sx=80,sy=0,sw=16,sh=16}
			},
			hitboxes = {
				p.defaulthitbox
			}
		}
	},
	drinking = {
		frames = {
			lpf = 5,
			sprites = {
				{sx=32,sy=32,sw=16,sh=16},
				{sx=48,sy=32,sw=16,sh=16}
			},
			hitboxes = {
				p.defaulthitbox,
				p.defaulthitbox
			}
		}
	},
	berserker = {
		frames = {
			lpf = 1,
			sprites = {
				{sx=64,sy=32,sw=16,sh=16}
			},
			hitboxes = {
				p.defaulthitbox
			}
		}
	},
	dead = {
		frames = {
			lpf = 1,
			sprites = {
				{sx=96,sy=0,sw=16,sh=16}
			},
			hitboxes = {
				{w=16,h=5,ox=0,oy=9}
			}
		}
	}
}

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

