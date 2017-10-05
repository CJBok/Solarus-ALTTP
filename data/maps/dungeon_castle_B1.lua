local map = ...
local game = map:get_game()


function uncle_dying:on_activated()
  hero:freeze()
  
  game:start_dialog("quest.beginning.uncle.dying", function()
    uncle:set_direction(1)
    game:set_ability("sword", 1)
    game:set_ability("shield", 1)
    hero:get_sprite():set_animation("sword_raise")
    sol.audio.play_sound("treasure")
    uncle_dying:remove()
    sol.timer.start(2000, function()
      hero:unfreeze()
    end)
  end)
end