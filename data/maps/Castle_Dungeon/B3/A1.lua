-- Lua script of map Castle_Dungeon/B3/A1.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
    
  chain:set_center_enemy(red)

end

function red:on_dying()
   chain:remove()
end
