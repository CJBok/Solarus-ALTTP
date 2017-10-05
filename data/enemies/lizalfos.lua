local enemy = ...

-- Lizalfos.

sol.main.load_file("enemies/generic_soldier")(enemy)
enemy:set_properties({
  main_sprite = "enemies/lizalfos",
  sword_sprite = "enemies/lizalfos_sword",
  life = 5,
  damage = 6,
  play_hero_seen_sound = true,
  hurt_style = "monster",
  normal_speed = 48,
  faster_speed = 72
})

