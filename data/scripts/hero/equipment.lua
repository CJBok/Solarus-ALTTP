local game = ...


function game:get_small_key_amount()
  local mapname = self:get_map():get_id()
  return self:get_value(mapname .. "_small_keys") or 0
end


function game:add_small_key()
  local mapname = self:get_map():get_id()
  self:set_value(mapname .. "_small_keys", self:get_small_key_amount() + 1)
end


function game:remove_small_key()
  local mapname = self:get_map():get_id()
  self:set_value(mapname .. "_small_keys", self:get_small_key_amount() - 1)
end