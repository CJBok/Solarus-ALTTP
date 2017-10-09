local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

end


function bush_dungeon:on_cut()
  sol.audio.play_sound("secret")
end


function bush_dungeon:on_lifting()
  sol.audio.play_sound("secret")
end


function bush_dungeon:on_exploded()
  sol.audio.play_sound("secret")
end