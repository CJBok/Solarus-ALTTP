local game_manager = {}

local initial_game = require("scripts/initial_game")
local light_manager = require("maps/lib/light_manager")

local teletransporter_meta=sol.main.get_metatable("teletransporter")
local map_meta=sol.main.get_metatable("map")
local game_meta=sol.main.get_metatable("game")

-- Starts the game from the given savegame file,
-- initializing it if necessary.
function game_manager:start_game(file_name)
  local exists = sol.game.exists(file_name)
  local game = sol.game.load(file_name)
  if not exists then
    -- Initialize a new savegame.
    initial_game:initialize_new_savegame(game)
  end

  sol.main.game = game
  game:start()
end


 
function teletransporter_meta:on_activated()
  local game=self:get_game()
  local ground=self:get_map():get_ground(game:get_hero():get_position())
  game:set_value("tp_ground",ground)
end
 
--the actual trigger
function map_meta:on_started(destination)
  light_manager.enable_light_features(self)

  local hero=self:get_hero()
  local game=self:get_game()
  local x,y=hero:get_position()
  local ground=game:get_value("tp_ground")
  if ground=="hole" then
    --Falling from the ceiling
    hero:set_visible(false)
    hero:freeze()
    --disabling teletransoprters to avoid
    local disabled_teletransporters={}
    for t in self:get_entities_by_type("teletransporter") do
      if t:is_enabled() then
        disabled_teletransporters[#disabled_teletransporters+1]=t
        t:set_enabled(false)
      end
    end
    --Creating a "stunt actor" moving vertically from the ceiling
    local falling_hero=self:create_custom_entity({
      name="falling_link",
      x=x,
      y=math.max(y-100,24),
      direction=0,
      layer=self:get_max_layer(),
      sprite=hero:get_tunic_sprite_id(),
      width=24,
      height=24,
    })
    falling_hero:get_sprite():set_animation("dropping_from_ceiling")
    falling_hero:set_can_traverse_ground("wall",true)
    falling_hero:set_can_traverse_ground("empty",true)
    falling_hero:set_can_traverse_ground("traversable",true)
 
    --Creating a reception platform (prevents the hero from falling into consecutive holes during the animation)
    local platform=self:create_custom_entity({
      name="platform",
      direction=0,
      layer=self:get_max_layer(),
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
    --]]
  end
end

game_meta:register_event("on_map_changed", function(game)
  local map = game:get_map()
  for ent in map:get_entities("settings") do
    local lightlevel = split(split(ent:get_name(), "settings:")[1],"-")[1]
    local ambientlevel = split(split(ent:get_name(), "settings:")[1],"-")[2]
    game:set_light(tonumber(lightlevel))
    game:set_ambient_light(ambientlevel)
  end
  
end)

function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

return game_manager



