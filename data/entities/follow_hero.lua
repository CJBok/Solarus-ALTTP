-- Lua script of custom entity follow_hero.
-- This script is executed every time a custom entity with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local entity = ...
local game = entity:get_game()
local map = entity:get_map()

-- Event called when the custom entity is initialized.
function entity:on_created()
  local mov = sol.movement.create("target")
  mov:set_target(game:get_hero())
  mov:set_smooth(true)
  mov:set_speed(90)
  mov:start(entity)

  self:get_sprite():set_animation("walking")
end

function entity:on_update()
  self:get_sprite():set_direction(self:get_movement():get_direction4())
  --print(self:get_game():get_dungeon_index())
end
