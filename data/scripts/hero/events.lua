require("scripts/multi_events")

local hero_meta=sol.main.get_metatable("hero")


hero_meta:register_event("on_state_changed", function(hero)
  local current_state = hero:get_state()
  if hero.previous_state == "carrying" then
    hero:notify_object_thrown()
  end
  hero.previous_state = current_state
end)
hero_meta:register_event("notify_object_thrown", function() end)