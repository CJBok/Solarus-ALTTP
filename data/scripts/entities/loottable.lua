local loottable = ...
require("scripts/multi_events")

local enemy_meta=sol.main.get_metatable("enemy")

local treasurepacks =
{
  --pack 1
  {
    {"heart", 1}, -- Heart
    {"heart", 1}, -- Heart
    {"heart", 1}, -- Heart
    {"heart", 1}, -- Heart
    {"rupee", 1}, -- Green Rupee
    {"heart", 1}, -- Heart
    {"heart", 1}, -- Heart
    {"rupee", 1}, -- Green Rupee
  },

  --pack 2
  {
    {"rupee", 2}, -- Blue Rupee
    {"rupee", 1}, -- Green Rupee
    {"rupee", 2}, -- Blue Rupee
    {"rupee", 3}, -- Red Rupee
    {"rupee", 2}, -- Blue Rupee
    {"rupee", 1}, -- Green Rupee
    {"rupee", 2}, -- Blue Rupee
    {"rupee", 2}, -- Blue Rupee
  },

  --pack 3
  {
    {"magic_flask", 2}, -- Magic Flask Big
    {"magic_flask", 1}, -- Magic Flask Small
    {"magic_flask", 1}, -- Magic Flask Small
    {"rupee", 2},       -- Blue Rupee
    {"magic_flask", 2}, -- Magic Flask Big
    {"magic_flask", 1}, -- Magic Flask Small
    {"heart", 1},       -- Heart
    {"magic_flask", 1}, -- Magic Flask Small
  },

  --pack 4
  {
    {"bomb", 1}, -- Bomb
    {"bomb", 1}, -- Bomb
    {"bomb", 1}, -- Bomb
    {"bomb", 2}, -- Bomb x3
    {"bomb", 1}, -- Bomb
    {"bomb", 1}, -- Bomb
    {"bomb", 3}, -- Bomb x8
    {"bomb", 1}, -- Bomb
  },

  --pack 5
  {
    {"arrow", 2}, -- Arrow x5
    {"heart", 1}, -- Heart
    {"arrow", 2}, -- Arrow x5
    {"arrow", 3}, -- Arrow x10
    {"arrow", 2}, -- Arrow x5
    {"heart", 1}, -- Heart
    {"arrow", 2}, -- Arrow x5
    {"arrow", 3}, -- Arrow x10
  },

  --pack 6
  {
    {"magic_flask", 1}, -- Magic Flask Small
    {"rupee", 1},       -- Green Rupee
    {"heart", 1},       -- Heart
    {"arrow", 2},       -- Arrow x5
    {"magic_flask", 1}, -- Magic Flask Small
    {"bomb", 1},        -- Bomb
    {"rupee", 1},       -- Green Rupee
    {"heart", 1},       -- Arrow x5
  },

  --pack 7
  {
    {"heart", 1},       -- Heart
    {"fairy", 1},       -- Fairy
    {"magic_flask", 2}, -- Magic Flask Big
    {"rupee", 3},       -- Red Rupee
    {"bomb", 3},        -- Bomb x8
    {"heart", 1},       -- Heart
    {"rupee", 3},       -- Red Rupee
    {"arrow", 3},       -- Arrow x10
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

  if math.random(100) >= 50 then 
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

  local treasure = treasurepacks[pack][math.random(8)]

  enemy:get_map():create_pickable({
    layer = l,
    x = x,
    y = y,
    treasure_name = treasure[1],
    treasure_variant = treasure[2],
  })

end)
