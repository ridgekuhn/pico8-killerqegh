---point flag class

--store the default table
ptflags = actors:new()

---point flag class constructor
function ptflags:new(o)
  --assert(o, 'no point data given')
  local ptflag = o
  setmetatable(ptflag, self)
  self.__index = self

  ptflag.cors = {cocreate(function()
    for i=1, 8 do
      ptflag.y -= 1
      yield()
    end
  end)}

  return ptflag
end

---delete flags
function ptflags:delete()
  for ptflag in all(self) do
    if(costatus(ptflag.cors[1]) == 'dead') then
      del(self, ptflag)
    end
  end
end
