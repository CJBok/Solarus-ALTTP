local chests = ...
require("scripts/multi_events")

local chest_meta=sol.main.get_metatable("chest")


chest_meta:register_event("on_opened", function (chest, treasure_item, treasure_variant, treasure_savegame_variable)

  local map = chest:get_map()
  local game = map:get_game()
  local hero = map:get_hero()

  local itemname = treasure_item:get_name()
  
  if itemname == "rupee" and not game:has_item("lamp") then
    itemname = "lamp"
    treasure_variant = 1
  end

  hero:start_treasure(itemname, treasure_variant)

end)