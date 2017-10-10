-- Automatically hides/shows door entity when hero is in range

local entity = ...
local map = entity:get_map()
local hero = entity:get_map():get_hero()

function entity:on_created()
  map:set_doors_open("trap", true)
  entity:add_collision_test("containing", function(ent, coll)
    if coll == hero and hero:is_visible() then
      map:close_doors("trap")
      entity:clear_collision_tests()
    end
  end)
end


function entity:on_update()
  local count = 0
  for ent in map:get_entities_by_type("enemy") do

    count = count + 1
  end

  if count == 0 then
    map:open_doors("trap")
    sol.audio.play_sound("secret")
    entity:clear_collision_tests()
    entity:remove()
  end
end