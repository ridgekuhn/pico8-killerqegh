---point flag views

---draw point flags to screen
function ptflags:draw()
  for ptflag in all(ptflags) do
    print_shadow(ptflag.pts, ptflag.x + 1, ptflag.y + 1)
  end
end

