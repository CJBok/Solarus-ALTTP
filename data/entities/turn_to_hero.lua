local entity = ...
local game = entity:get_game()
local map = entity:get_map()

function entity:on_update()
  entity:set_direction(entity:get_direction4_to(game:get_hero()))
end
