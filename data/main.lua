-- This is the main Lua script of your project.
-- You will probably make a title screen and then start a game.
-- See the Lua API! http://www.solarus-games.org/doc/latest

require("scripts/features")
local game_manager = require("scripts/game_manager")
local initial_game = require("scripts/initial_game")

-- This function is called when Solarus starts.
function sol.main:on_started()

  game_manager:start_game("savetest.dat")

  -- Setting a language is useful to display text and dialogs.
  sol.language.set_language("en")

  --local solarus_logo = require("scripts/menus/solarus_logo")

  -- Show the Solarus logo initially.
  --sol.menu.start(self, solarus_logo)

  -- Start the game when the Solarus logo menu is finished.
 -- solarus_logo.on_finished = function()
   -- game_manager:start_game("savetest.dat")
 -- end

end

-- Event called when the player pressed a keyboard key.
function sol.main:on_key_pressed(key, modifiers)

  local game = sol.main.game
  local map = game:get_map()
  local hero = game:get_hero()
  local handled = false
  if key == "f5" then
    -- F5: change the video mode.
    sol.video.switch_mode()
    handled = true
  elseif key == "f11" or
    (key == "return" and (modifiers.alt or modifiers.control)) then
    -- F11 or Ctrl + return or Alt + Return: switch fullscreen.
    sol.video.set_fullscreen(not sol.video.is_fullscreen())
    handled = true
  elseif key == "f4" and modifiers.alt then
    -- Alt + F4: stop the program.
    sol.main.exit()
    handled = true
  elseif key == "escape" --[[and sol.main.game == nil--]] then
    -- Escape in title screens: stop the program.
    sol.main.exit()
    handled = true
  elseif key == "q" then
    local x, y, layer = hero:get_position()
    local direction = hero:get_direction()
    if direction == 0 then
      x = x + 16
    elseif direction == 1 then
      y = y - 16
    elseif direction == 2 then
      x = x - 16
    elseif direction == 3 then
      y = y + 16
    end

    map:create_bomb{
      x = x,
      y = y,
      layer = layer
    }
    
  end

  return handled
end