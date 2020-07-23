---players class controllers
--
---get player input
function p:get_input(cb)
  if(cb) then
    cb()
  end

  for i=0, 5 do
    self['b' .. tostr(i)] = btn(i, self.index - 1)
  end
end


