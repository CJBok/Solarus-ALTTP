-- Defines the elements to put in the HUD
-- and their position on the game screen.

-- You can edit this file to add, remove or move some elements of the HUD.

-- Each HUD element script must provide a method new()
-- that creates the element as a menu.
-- See for example scripts/hud/hearts.lua.

-- Negative x or y coordinates mean to measure from the right or bottom
-- of the screen, respectively.

local hud_config = {

  -- Magic meter.
  {
    menu_script = "scripts/hud/magic_bar",
    x = 10,
    y = 8,
  },

  -- Hearts meter.
  {
    menu_script = "scripts/hud/hearts",
    x = 130,
    y = 0,
  },

  -- Rupee counter.
  {
    menu_script = "scripts/hud/rupees",
    x = 30,
    y = 10,
  },

  -- Bomb counter.
  {
    menu_script = "scripts/hud/bombs",
    x = 55,
    y = 10,
  },

  -- Arrow counter.
  {
    menu_script = "scripts/hud/arrows",
    x = 80,
    y = 10,
  },

  -- Small Keys counter.
  {
    menu_script = "scripts/hud/keys",
    x = 95,
    y = 10,
  },

  -- Item assigned to slot 1.
  {
    menu_script = "scripts/hud/item",
    x = 225,
    y = 10,
    slot = 1,  -- Item slot (1 or 2).
  },

-- Item assigned to slot 1.
  {
    menu_script = "scripts/hud/item",
    x = 225,
    y = 35,
    slot = 2,  -- Item slot (1 or 2).
  },

  -- You can add more HUD elements here.
}

return hud_config
