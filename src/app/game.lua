---game app state

---initialize game app state
function game_init()
  gameclock = 0

  _update = game_running_update
  _draw = game_running_draw

  camera_init()
  level:init()

  for table in all({e, p, powerups, ptflags, hud_dcors}) do
    for actor in all(table) do
      del(table, actor)
    end

    if(type(table.init) == 'function') then
      table:init()
    end
  end

  music(11, 0, 11)

  _update()
end

---update game running state
function game_running_update()
  if(p[1].lives == 0 and p[1].state == 'dead') then
    music(-1, 8000)
    level.sclock = 0
    level.spawnrate = 2
    level.etospawn = 50

    _update = game_over_update
    _draw = game_over_draw
    return
  end

  level:update()
  e:update()
  p[1]:update()
  powerups:update()
  ptflags:update()

  gameclock += 1
end

---draw game app state
function game_running_draw()
  cls()
  camera_follow()

  map(level.map)

  e:draw()
  p[1]:draw()
  ptflags:draw()
  powerups:draw()

  hud_draw()
end

---update game over state
function game_over_update()
  if(level.sclock >= 300 and (p[1].b4 or p[1].b5)) then
    title_init()
  end

  if(level.etospawn > 0 and
     level.sclock % level.spawnrate == 0
  ) then
    e:spawn()
    level.etospawn -= 1
  end
  e:update()

  p[1]:get_input()
  p[1]:update()

  level.sclock += 1
  gameclock += 1
end

--draw game over state
function game_over_draw()
  cls()
  camera_follow()

  map(level.map)

  p[1]:draw()
  e:draw()

  print_centered('game over!', cam.x, cam.y - 7, 7, true)
  print_centered('today is a good day to die.', cam.x, cam.y, 7, true)
  print_centered('your score: '..tostr(p[1].score), cam.x, cam.y + 7, 7, true)
end

