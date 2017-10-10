local enemy = ...
local generic_soldier = require("enemies/generic/generic_soldier")

generic_soldier:initialize(enemy)

enemy:set_properties({
  main_sprite = "enemies/" .. enemy:get_breed(),
  sword_sprite = "enemies/" .. enemy:get_breed() .. "_weapon",
  life = 3,
  damage = 1,
  play_hero_seen_sound = true
})