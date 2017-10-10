local enemy = ...
local generic_soldier = require("enemies/generic/generic_soldier")

generic_soldier:initialize(enemy)

enemy:set_properties({
  main_sprite = "enemies/" .. enemy:get_breed(),
  sword_sprite = "enemies/" .. enemy:get_breed() .. "_weapon",
  life = 2,
  damage = 2,
  play_hero_seen_sound = true
})