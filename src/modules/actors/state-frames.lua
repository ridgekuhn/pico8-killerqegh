---actor state frames

--*****
--views
--*****
---frame animation
function actors:get_frame(frames, clock)
  local frames = frames or self.states[self.state].frames
  local clock = clock or self.sclock

	frames.hitboxes = frames.hitboxes or {}

  if(#frames.sprites == 1) then
    return frames.sprites[1], frames.hitboxes[1]
  end

  --total duration of animation
  local d = frames.lpf * #frames.sprites
  local aclock = 0
  local f = 0

  --reset dirty animation
  if(clock == 0 and frames.r) then
    frames.r = nil
  end

  --animation is not reversible
  if(not frames.rev) then
    aclock = clock % d
    f = flr((aclock / d) * #frames.sprites) + 1

  --animation is reversible
  elseif(frames.rev) then
    --total frames of reversed
    --animation, excluding
    --the first and last
    local nframes = (#frames.sprites * 2) - 2
    --total duration
    --of animation
    local rd = frames.lpf * nframes

    aclock = clock % rd

    --animation is
    --playing forward
    if(not frames.r) then
      f = flr((aclock / d) * #frames.sprites) + 1

      if(clock > 0 and aclock == (d - 1)) then
        frames.r = true
      end

    --animation is
    --playing backwards
    else
      f = abs(flr((aclock / rd) * nframes) - (#frames.sprites * 2) + 1)

      if(f == 2 and aclock == (rd - 1)) then
        frames.r = false
      end
    end
  end

  return frames.sprites[f], frames.hitboxes[f]
end

