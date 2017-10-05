local falling = ...
require("scripts/multi_events")

local teletransporter_meta=sol.main.get_metatable("teletransporter")
local map_meta=sol.main.get_metatable("map")

teletransporter_meta:register_event("on_activated", function(teletransporter, test)
  local game = teletransporter:get_game()
  local ground=game:get_map():get_ground(game:get_hero():get_position())
  game:set_value("tp_ground",ground)
end)
 
--the actual trigger
map_meta:register_event("on_started", function(map, destination)
  local hero=map:get_hero()
  local game=map:get_game()
  local x,y=hero:get_position()
  local ground=game:get_value("tp_ground")
  if ground=="hole" then
    --Falling from the ceiling
    hero:set_visible(false)
    hero:freeze()
    --disabling teletransoprters to avoid
    local disabled_teletransporters={}
    for t in map:get_entities_by_type("teletransporter") do
      if t:is_enabled() then
        disabled_teletransporters[#disabled_teletransporters+1]=t
        t:set_enabled(false)
      end
    end
    --Creating a "stunt actor" moving vertically from the ceiling
    local falling_hero=map:create_custom_entity({
      name="falling_link",
      x=x,
      y=math.max(y-100,24),
      direction=0,
      layer=map:get_max_layer(),
      sprite=hero:get_tunic_sprite_id(),
      width=24,
      height=24,
    })
    falling_hero:get_sprite():set_animation("dropping_from_ceiling")
    falling_hero:set_can_traverse_ground("wall",true)
    falling_hero:set_can_traverse_ground("empty",true)
    falling_hero:set_can_traverse_ground("traversable",true)
 
    --Creating a reception platform (prevents the hero from falling into consecutive holes during the animation)
    local platform=map:create_custom_entity({
      name="platform",
      direction=0,
      layer=map:get_max_layer(),
      x=x,
      y=y,
      width=32,
      height=32,
      sprite="entities/shadow",
    })
    platform:bring_to_front()
    platform:get_sprite():set_animation("big")
    platform:set_modified_ground("traversable") 
 
    --Creating the actual movement for the stunt actor
    local movement=sol.movement.create("target")
    movement:set_target(x,y)
    movement:set_speed(127)
    movement:start(falling_hero, function()
      --Movement is now complete, restoring the disabled teletransoprters and getting rid of the temporary entities
      sol.audio.play_sound("hero_lands")
      platform:remove()
      falling_hero:remove()
      hero:set_visible(true)
      hero:unfreeze()
      for _,t in pairs(disabled_teletransporters) do
        t:set_enabled(true)
      end
    end)

  end
end)