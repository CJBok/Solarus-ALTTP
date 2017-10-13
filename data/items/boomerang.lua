local item = ...

function item:on_created()

  self:set_savegame_variable("i1103")
  self:set_assignable(true)
end

function item:on_using()

  local hero = self:get_map():get_entity("hero")
  if self:get_variant() == 1 then
    hero:start_boomerang(128, 160, "boomerang1", "entities/boomerang1")
  else
    -- boomerang 2: longer and faster movement
    hero:start_boomerang(192, 320, "boomerang2", "entities/boomerang2")
  end
  self:set_finished()
end

-- Called when the player obtains the Boomerang.
function item:on_obtained(variant, savegame_variable)
  self:get_game():set_item_assigned(1, self:get_game():get_item("boomerang"))
end

