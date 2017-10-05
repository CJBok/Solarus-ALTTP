-- This script initializes game values for a new savegame file.
-- You should modify the initialize_new_savegame() function below
-- to set values like the initial life and equipment
-- as well as the starting location.
--
-- Usage:
-- local initial_game = require("scripts/initial_game")
-- initial_game:initialize_new_savegame(game)

local initial_game = {}
local game

-- Sets initial values to a new savegame file.
function initial_game:initialize_new_savegame(game)

  --game:set_starting_location("testmap", "start")
  --game:set_starting_location("dungeon_castle_B1", "start")
  --game:set_starting_location("lightworld C2", "start")
  --game:set_starting_location("lightworld C3", "link_house")

  game:set_starting_location("link_house", "start")

  game:set_max_life(6)
  game:set_life(game:get_max_life())
  game:set_max_money(100)
  game:set_ability("lift", 1)
  game:set_max_magic(42)
  game:set_magic(42)

  sol.audio.play_music("beginning")
end

return initial_game
