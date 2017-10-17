local transition_animation = ...
require("scripts/multi_events")

local teletransporter_meta=sol.main.get_metatable("teletransporter")
local destinations_meta=sol.main.get_metatable("destination")
local map_meta=sol.main.get_metatable("map")

teletransporter_meta:register_event("on_activated", function(teletransporter)
  local game = teletransporter:get_game()
  local ground=game:get_map():get_ground(game:get_hero():get_position())
  game:set_value("tp_ground",ground)
end)
 
--the actual trigger
--destinations_meta:register_event("on_activated", function(destination)
map_meta:register_event("on_started", function(map, destination)

  if destination == nil then return end

  local game = destination:get_game()
  local hero = game:get_hero()
  local map = game:get_map()
  local x, y, l = hero:get_position()
  local dx, dy, dl = destination:get_position()
  local ground = game:get_value("tp_ground")
  local direction = hero:get_direction()

  if ground == "hole" then

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
    local falling_hero = map:create_custom_entity({
      --name = "falling_link",
      x = x,
      y = math.max(y - 100, 24),
      direction = 0,
      layer = map:get_max_layer(),
      sprite = hero:get_tunic_sprite_id(),
      width = 0,
      height = 0,
    })

    print(map:get_max_layer())
    falling_hero:get_sprite():set_animation("dropping_from_ceiling")
 
    --Creating a reception platform (prevents the hero from falling into consecutive holes during the animation)
    local platform = map:create_custom_entity({
      --name = "platform",
      direction = 0,
      layer = map:get_max_layer(),
      x = x,
      y = y,
      width = 0,
      height = 0,
      sprite = "entities/shadow",
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
  else
    if not destination:get_name():find("^door_") then
      return
    end

    --Walking animation towards destination
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

    --Calculation destination offset
    local offsetx = 0 
    local offsety = 0
    if direction == 0 then
      offsetx = -48
    elseif direction == 1 then
      offsety = 48
    elseif direction == 2 then
      offsetx = 48
    elseif direction == 3 then
      offsety = -48
    end

    --Creating a "stunt actor"
    local walking_hero = map:create_custom_entity({
      name="walking_link",
      x = x + offsetx,
      y = y + offsety,
      direction = direction,
      layer = dl,
      sprite = hero:get_tunic_sprite_id(),
      width = 0,
      height = 0,
    })
    walking_hero:get_sprite():set_animation("walking")

    --Creating the actual movement for the stunt actor
    local movement=sol.movement.create("target")
    movement:set_target(x,y)
    movement:set_speed(hero:get_walking_speed())
    movement:start(walking_hero, function()
      --Movement is now complete, restoring the disabled teletransoprters and getting rid of the temporary entities
      walking_hero:remove()
      hero:set_visible(true)
      hero:unfreeze()
      for _,t in pairs(disabled_teletransporters) do
        t:set_enabled(true)
      end
    end)
  end
end)