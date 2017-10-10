local game = ...


function game:get_degree(ent1, ent2)
  local ex, ey = ent1:get_position()
  local hx, hy = ent2:get_position()
  local degrees = math.atan2(hy-ey, hx-ey) * 180 / math.pi
  if degrees < 0 then degrees = 360 + degrees end
  return degrees
end