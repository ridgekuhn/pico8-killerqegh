---axis-aligned collisions
--
--detect if actors
--have collided using
--axis-aligned bounding boxes
--
--dependencies:
--	none
--
--extends:
--	none
--
--conflicts:
--	actors/collision-per-pixel
--		@see actors:get_coll_aabb()

--***********
--controllers
--***********
---aabb sprite collision
--
--checks for collision with
--another actor object.
--
--@usage
--  function some_actor:check_hits()
--    for enemy in all(enemies) do
--      if(some_actor:coll_aabb(enemy)) then
--        do_something()
--      end
--    end
--  end
--
--@param actor table
--  to check for
--  collisions against
--
--@return boolean true if
--  collision detected
--
--@return num leftmost draw
--  coordinate of the collision
--
--@return num top draw
--	coordinate of the collision
--
--@return num rightmost draw
--	coordinate of the collision
--
--@return num bottom draw
--	coordinate of the collision
function actors:get_coll_aabb(actor)
  local l = self
  local r = actor

  --set leftmost actor
  if(l.x > r.x) l, r = r, l

  local l_xmin = l:get_xmin()
  local l_xmax = l:get_xmax()
  local l_ymin = l:get_ymin()
  local l_ymax = l:get_ymax()

  local r_xmin = r:get_xmin()
  local r_xmax = r:get_xmax()
  local r_ymin = r:get_ymin()
  local r_ymax = r:get_ymax()

  --check hitbox overlap
  if(l_xmin < r_xmax and
      l_xmax > r_xmin and
      l_ymin < r_ymax and
      l_ymax > r_ymin
  ) then
    return true,
      r_xmin,
      max(l_ymin, r_ymin),
      min(l_xmax, r_xmax),
      min(l_ymax, r_ymax)
  end
end

