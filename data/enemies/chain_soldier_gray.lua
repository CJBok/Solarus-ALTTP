local enemy = ...

local generic_soldier = require("enemies/generic/generic_soldier")

generic_soldier:initialize(enemy)
enemy:set_properties({
  main_sprite = "enemies/chain_soldier_gray",
  sword_sprite = nil,--"enemies/red_knight_soldier_sword",
  life = 4,
  damage = 2,
  play_hero_seen_sound = false,
  normal_speed = 32,
  faster_speed = 32,
})

