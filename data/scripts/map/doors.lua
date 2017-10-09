local doors = ...
require("scripts/multi_events")

local map=sol.main.get_metatable("map")
local door_meta=sol.main.get_metatable("door")
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

  map:set_doors_open("trap1", true)
end)

--[[
map:register_event("map:on_opening_transition_finished", function(map,destination)
  local hero = map:get_hero()
  for entity in map:get_entities("door_proxy") do
    local dis = entity:get_distance(hero)
    if entity:is_enabled() == false and dis > range then
      entity:set_enabled(true)
    elseif entity:is_enabled() == true and dis <= range then
      entity:set_enabled(false)
    end
  end

  map:close_doors("trap1")
end)--]]


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


door_meta:register_event("on_closed", function(door)
 -- door:set
end)


door_meta:register_event("on_opened", function(door)
  
end)