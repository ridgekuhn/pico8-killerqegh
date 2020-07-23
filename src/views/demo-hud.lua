---demo hud views

hud_dcors = {}

---draw hud
function hud_draw()
  print_shadow('score:'..tostr(p[1].score), cam.x + 1, 1, 7)

  --print health
  print_shadow('spine', cam.x + 66, 1, 7)
  hud_health(cam.x + 85, 1)

  if(level.state == 'running') then
    print_shadow('e:'..tostr(level.eremaining), cam.x + 48, 1, 7)
  end

  --print lives
  spr(32, cam.x + 111, 0)

  print_shadow('𝘹'..tostr(p[1].lives), cam.x + 120, 1, 7)

  actors.update_cors(nil, hud_dcors)
end

---draw health
function hud_health(x, y)
  for i=0, 4 do
    rect(x + (i * 5) + 2, y + 1, x + (i * 5) + 5, y + 5, 1)
    rect(x + (i * 5) + 1, y, x + (i * 5) + 4, y + 4, 7)
  end

  local bars = ceil(p[1].health / 20)

  for i=0, bars - 1 do
    rectfill(x + (i * 5) + 2, y + 1, x + (i * 5) + 3, y + 3, 8)
  end
end
