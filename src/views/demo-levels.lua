---game level views

---draw level start state
function level:draw_start()
  if(self.sclock > 1 and self.sclock <= 90) then
    print_centered('level '..tostr(level.current), cam.x, cam.y - 7, 7, true)
    print_centered('ready', cam.x, cam.y, 7, true)
    print_centered(tostr(ceil((90 - self.sclock) / 30)), cam.x, cam.y + 7, 7, true)
  end
end

---draw level running state
function level:draw_running()
  if(self.sclock <= 30) then
    print_centered('engage!', cam.x, cam.y, 7, true)
  end
end

---draw level over state
function level:draw_over()
  print_centered('level cleared!', cam.x, cam.y, 7, true)
end
