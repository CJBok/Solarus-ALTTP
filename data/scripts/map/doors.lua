local doors = ...
require("scripts/multi_events")

local map=sol.main.get_metatable("map")
local range = 32

map:register_event("on_started", function(map,destination)
  local hero = map:get_hero()
  for entity in map:get_entities("door_proxy") do
    local dis = entity:get_distance(hero)
    if entity:is_enabled() == false and dis > range then
      entity:set_enabled(true)
    elseif entity:is_enabled() == true and dis <= range then
      entity:set_enabled(false)
    end
  end
end)

map:register_event("on_update", function(map)
  local hero = map:get_hero()
  for entity in map:get_entities("door_proxy") do
    local dis = entity:get_distance(hero)
    if entity:is_enabled() == false and dis > range then
      sol.audio.play_sound("door_closed")
      entity:set_enabled(true)
    elseif entity:is_enabled() == true and dis <= range then
      sol.audio.play_sound("door_open")
      entity:set_enabled(false)
    end
  end
end)



--return doors