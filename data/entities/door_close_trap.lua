-- Automatically hides/shows door entity when hero is in range

local entity = ...
local map = entity:get_map()
local hero = entity:get_map():get_hero()

function entity:on_created()
  entity:add_collision_test("containing", function(ce, ent)
    --print("test1")
    if ent == hero then
      print("test2")
      map:close_doors("trap1")
      entity:clear_collision_tests()
    end
  end)
end

function entity:on_update() 
  if not map:has_entities("trap1_enemy") then
    print("test3")
   -- map:open_doors("trap1")
    entity:remove()
  end
end