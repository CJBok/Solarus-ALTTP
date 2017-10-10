local game = ...

function game:get_patrol(npc)

  if npc == nil or npc:get_name() == nil then
    return nil
  end

  local patrolname = npc:get_map():get_id() .. "/" .. npc:get_name()
  local path = ""

  if     patrolname == "Castle_Dungeon/B1/C1/blue_soldier_1" then
    path = "6666644422222000"
    
  elseif patrolname == "Castle_Dungeon/B1/C1/blue_soldier_2" then
    path = "0000044444"

  elseif patrolname == "Castle_Dungeon/B1/C3/blue_soldier_1" then
    path = "6666622222"
    
  elseif patrolname == "Castle_Dungeon/B1/C3/blue_soldier_2" then
    path = "2222266666"

  elseif patrolname == "Castle_Dungeon/B1/C3/blue_soldier_3" then
    path = "6666622222"

  elseif patrolname == "Castle_Dungeon/B1/A3/green_soldier_1" then
    path = "6666622222"

  elseif patrolname == "Castle_Dungeon/B1/A3/green_soldier_2" then
    path = "6666622222"

  end

  if path == "" then return nil end

  local patharray = {}
  local count = 1
  for c in path:gmatch"." do
    patharray[count] = tonumber(c)
    count = count + 1
    patharray[count] = tonumber(c)
    count = count + 1
  end

  return patharray
end