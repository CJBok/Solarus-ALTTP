local game = ...

function game:get_dungeon_index()

  local map = self:get_map()
  if map ~= nil then 
    local mapname = self:get_map():get_id()
    
    if mapname:find("Dungeon") and mapname:find("/") then
      return split(mapname, "/")[1]
    end
  
  end
  return "undefined"
end


function game:get_small_key_amount()
  if self:get_dungeon_index() == "undefined" then return -1 end

  local mapname = self:get_dungeon_index()
  return self:get_value(mapname .. "_small_keys") or 0
end


function game:add_small_key()
  local mapname = self:get_dungeon_index()
  self:set_value(mapname .. "_small_keys", self:get_small_key_amount() + 1)
end


function game:remove_small_key()
  local mapname = self:get_dungeon_index()
  self:set_value(mapname .. "_small_keys", self:get_small_key_amount() - 1)
end


