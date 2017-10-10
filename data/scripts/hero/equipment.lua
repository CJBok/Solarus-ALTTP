local game = ...


function game:get_small_key_amount()
  if self:get_map() == nil or self:get_map():get_world() == nil then return -1 end

  local mapname = self:get_map():get_world()
  return self:get_value(mapname .. "_small_keys") or 0
end


function game:add_small_key()
  if self:get_map() == nil then return end
  local mapname = self:get_map():get_world()
  self:set_value(mapname .. "_small_keys", self:get_small_key_amount() + 1)
end


function game:remove_small_key()
  if self:get_map() == nil then return end
  local mapname = self:get_map():get_world()
  self:set_value(mapname .. "_small_keys", self:get_small_key_amount() - 1)
end