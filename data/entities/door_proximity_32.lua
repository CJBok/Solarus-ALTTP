-- Automatically hides/shows door entity when hero is in range

local entity = ...
local map = entity:get_map()
local hero = entity:get_map():get_hero()
local range = 32

function entity:on_created()
  local dis = entity:get_distance(hero)
  if dis > range then
    entity:set_traversable_by(false)
    entity:set_visible(true)
  elseif dis <= range then
    entity:set_traversable_by(true)
    entity:set_visible(false)
  end
end

function entity:on_update()
  local dis = entity:get_distance(hero)
  if entity:is_visible() == false and dis > range then
    sol.audio.play_sound("door_closed")
    entity:set_traversable_by(false)
    entity:set_visible(true)
  elseif entity:is_visible() == true and dis <= range then
    sol.audio.play_sound("door_open")
    entity:set_traversable_by(true)
    entity:set_visible(false)
  end
end