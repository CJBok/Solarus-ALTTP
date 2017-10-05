local map = ...
local game = map:get_game()
local hero = map:get_hero()

function hero:on_position_changed(x, y, layer)
  local range = 32
  local ces = map:get_entities_in_rectangle(x-range, y-range, range*2, range*2)

  for ent in ces do
    if ent:get_type() == "custom_entity" then
      local dis = ent:get_distance(hero)
      if ent:is_visible() == false and dis > range then
        ent:set_visible(true)
      elseif ent:is_visible() == true and dis <= range then
        ent:set_visible(false)
      end
    end
  end
end
