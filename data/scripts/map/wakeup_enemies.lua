local wakup_enemies = ...

local destinations_meta=sol.main.get_metatable("destination")
local teletransporter_meta=sol.main.get_metatable("teletransporter")

local map_meta=sol.main.get_metatable("map")

map_meta:register_event("on_started", function(destination)
  destination:get_game():set_suspended(true)
end)


map_meta:register_event("on_opening_transition_finished", function(destination)
  destination:get_game():set_suspended(false)
end)

--[[
destinations_meta:register_event("on_activated", function(destination)
  local map = destination:get_map()
  local entities = map:get_entities_in_region(destination)
  for ent in entities do
    if sol.main.get_type(ent) == "enemy" then
      ent:set_enabled(true)
    end    
  end

end)


teletransporter_meta:register_event("on_activated", function(teletransporter)
  local map = teletransporter:get_map()
  local entities = map:get_entities_in_region(teletransporter)
  for ent in entities do
    if sol.main.get_type(ent) == "enemy" then
      ent:set_enabled(false)
    end    
  end
end)--]]