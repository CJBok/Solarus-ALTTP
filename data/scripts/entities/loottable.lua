local loottable = ...
require("scripts/multi_events")

local enemy_meta=sol.main.get_metatable("enemy")

local treasurepacks =
{
  --pack 1
  {
    { -- Items
      {"heart", 1}, -- Heart
      {"heart", 1}, -- Heart
      {"heart", 1}, -- Heart
      {"heart", 1}, -- Heart
      {"rupee", 1}, -- Green Rupee
      {"heart", 1}, -- Heart
      {"heart", 1}, -- Heart
      {"rupee", 1},  -- Green Rupee
    }, -- Chance in percentage
      50
  },

  --pack 2
  {
    { -- Items
      {"rupee", 2}, -- Blue Rupee
      {"rupee", 1}, -- Green Rupee
      {"rupee", 2}, -- Blue Rupee
      {"rupee", 3}, -- Red Rupee
      {"rupee", 2}, -- Blue Rupee
      {"rupee", 1}, -- Green Rupee
      {"rupee", 2}, -- Blue Rupee
      {"rupee", 2}, -- Blue Rupee
    }, -- Chance in percentage
      50
  },

  --pack 3
  {
    { -- Items
      {"magic_flask", 2}, -- Magic Flask Big
      {"magic_flask", 1}, -- Magic Flask Small
      {"magic_flask", 1}, -- Magic Flask Small
      {"rupee", 2},       -- Blue Rupee
      {"magic_flask", 2}, -- Magic Flask Big
      {"magic_flask", 1}, -- Magic Flask Small
      {"heart", 1},       -- Heart
      {"magic_flask", 1}, -- Magic Flask Small
    }, -- Chance in percentage
      50
  },

  --pack 4
  {
    { -- Items
      {"bomb", 1}, -- Bomb
      {"bomb", 1}, -- Bomb
      {"bomb", 1}, -- Bomb
      {"bomb", 2}, -- Bomb x3
      {"bomb", 1}, -- Bomb
      {"bomb", 1}, -- Bomb
      {"bomb", 3}, -- Bomb x8
      {"bomb", 1}, -- Bomb
    }, -- Chance in percentage
      100
  },

  --pack 5
  {
    { -- Items
      {"arrow", 2}, -- Arrow x5
      {"heart", 1}, -- Heart
      {"arrow", 2}, -- Arrow x5
      {"arrow", 3}, -- Arrow x10
      {"arrow", 2}, -- Arrow x5
      {"heart", 1}, -- Heart
      {"arrow", 2}, -- Arrow x5
      {"arrow", 3}, -- Arrow x10
    }, -- Chance in percentage
      50
  },

  --pack 6
  {
    { -- Items
      {"magic_flask", 1}, -- Magic Flask Small
      {"rupee", 1},       -- Green Rupee
      {"heart", 1},       -- Heart
      {"arrow", 2},       -- Arrow x5
      {"magic_flask", 1}, -- Magic Flask Small
      {"bomb", 1},        -- Bomb
      {"rupee", 1},       -- Green Rupee
      {"heart", 1},       -- Arrow x5
    }, -- Chance in percentage
      50
  },

  --pack 7
  {
    { -- Items
      {"heart", 1},       -- Heart
      {"fairy", 1},       -- Fairy
      {"magic_flask", 2}, -- Magic Flask Big
      {"rupee", 3},       -- Red Rupee
      {"bomb", 3},        -- Bomb x8
      {"heart", 1},       -- Heart
      {"rupee", 3},       -- Red Rupee
      {"arrow", 3},       -- Arrow x10
    }, -- Chance in percentage
      50
  },
}


local breedpacks = 
{
--  Breed Name              Treasure Pack
  {"sword_soldier_green",   1                 },
  {"sword_soldier_blue",    1                 },
  {"simple_green_soldier",  1                 },
}

enemy_meta:register_event("on_dead", function(enemy)

  if enemy:get_treasure() ~= nil then 
    return
  end

  local enemybreed = enemy:get_breed()
  local x, y, l = enemy:get_center_position()

  local pack = 0
  for i, breed in ipairs(breedpacks) do
    if breed[1] == enemybreed then 
      pack = breed[2]
      break
    end
  end

  if pack == 0 then 
    return 
  end

  math.randomseed( os.time() )
  local rand = math.random(#treasurepacks[pack][1])
  local treasure = treasurepacks[pack][1][rand]
  local chance = treasurepacks[pack][2]
  if math.random(100) >= chance then 
    return 
  end

  enemy:get_map():create_pickable({
    layer = l,
    x = x,
    y = y,
    treasure_name = treasure[1],
    treasure_variant = treasure[2],
  })

end)
