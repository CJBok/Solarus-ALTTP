local game = ...

function game:get_patrol(npc)

  if npc:get_name() == "patrol1" then
    return {6,6,6,6,6,6,6,6,6,6,4,4,4,4,4,4,2,2,2,2,2,2,2,2,2,2,0,0,0,0,0,0}
  end
  return nil
end