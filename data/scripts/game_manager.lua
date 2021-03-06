local game_manager = {}

local initial_game = require("scripts/initial_game")




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