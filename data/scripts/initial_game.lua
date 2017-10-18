local initial_game = {}
local game

-- Sets initial values to a new savegame file.
function initial_game:initialize_new_savegame(game)

  sol.main.load_file("scripts/game/functions")(game)
  sol.main.load_file("scripts/game/patrols")(game)
  sol.main.load_file("scripts/hero/equipment")(game)

  --game:set_starting_location("testmap", "start")
  --game:set_starting_location("dungeon_castle_secret_b1", "start")
  --game:set_starting_location("lightworld_c2", "start")
  --game:set_starting_location("lightworld_c3", "link_house")
  --game:set_starting_location("dungeon_castle_1f")

  game:set_starting_location("Light_World/indoor/house_link", "start")
  --game:set_starting_location("Light_World/F6")

  game:set_max_life(6)
  game:set_life(game:get_max_life())
  game:set_max_money(100)
  game:set_ability("lift", 1)
  game:set_max_magic(42)
  game:set_magic(0)

  game:set_ability("sword", 1)
  game:set_ability("shield", 1)

  sol.audio.play_music("beginning")
end

return initial_game
