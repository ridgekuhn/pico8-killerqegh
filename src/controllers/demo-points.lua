---point flag controllers

function ptflags:update()
  for ptflag in all(self) do
    ptflag:update_cors(ptflag.cors)
  end

  self:delete()
end
