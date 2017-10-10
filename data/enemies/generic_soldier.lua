local enemy = ...

-- Generic script for an enemy with a sword
-- that goes towards the hero if he sees him
-- and walks randomly otherwise.

-- Example of use from an enemy script:

-- sol.main.load_file("enemies/generic_soldier")(enemy)
-- enemy:set_properties({
--   main_sprite = "enemies/green_knight_soldier",
--   sword_sprite = "enemies/green_knight_soldier_sword",
--   life = 4,
--   damage = 2,
--   play_hero_seen_sound = false,
--   normal_speed = 32,
--   faster_speed = 64,
--   hurt_style = "normal"
-- })

-- The parameter of set_properties() is a table.
-- Its values are all optional except main_sprite
-- and sword_sprite.

local properties = {}
local going_hero = false
local seeing_hero = false
local being_pushed = false
local main_sprite = nil
local sword_sprite = nil

function enemy:set_properties(prop)

  properties = prop
  -- Set default values.
  if properties.life == nil then
    properties.life = 2
  end
  if properties.damage == nil then
    properties.damage = 2
  end
  if properties.play_hero_seen_sound == nil then
    properties.play_hero_seen_sound = false
  end
  if properties.normal_speed == nil then
    properties.normal_speed = 32
  end
  if properties.faster_speed == nil then
    properties.faster_speed = 60
  end
  if properties.hurt_style == nil then
    properties.hurt_style = "normal"
  end
end

function enemy:on_created()

  self:set_life(properties.life)
  self:set_damage(properties.damage)
  self:set_hurt_style(properties.hurt_style)
  sword_sprite = self:create_sprite(properties.sword_sprite)
  main_sprite = self:create_sprite(properties.main_sprite)
  self:set_size(16, 16)
  self:set_origin(8, 13)

  self:set_invincible_sprite(sword_sprite)
  self:set_attack_consequence_sprite(sword_sprite, "sword", "custom")
end


function enemy:on_restarted()
  main_sprite:set_animation("idle")
  sword_sprite:set_animation("idle")
  sol.timer.stop_all(self)
  sol.timer.start(self, 1000, function() self:restarted() end)
end


function enemy:restarted()
  main_sprite:set_animation("walking")
  sword_sprite:set_animation("walking")
  if not being_pushed then
    if going_hero then
      self:go_hero()
    else
      self:go_random()
      self:check_hero()
    end
  end
end

function enemy:check_hero()

  local hero = self:get_map():get_entity("hero")
  local _, _, layer = self:get_position()
  local _, _, hero_layer = hero:get_position()
  local near_hero = layer == hero_layer and self:get_distance(hero) < 100
  local facing_hero = main_sprite:get_direction() == self:get_direction4_to(hero)

  if facing_hero and near_hero and not going_hero then
    if properties.play_hero_seen_sound then
      --sol.audio.play_sound("hero_seen")
    end
    self:go_hero()
  elseif not near_hero and going_hero then
    self:go_random()
  end

  if not seeing_hero then
    sol.timer.stop_all(self)
    sol.timer.start(self, 1000, function() self:check_hero() end)
  end

end

function enemy:on_movement_changed(movement)

  if not being_pushed then
    local direction4 = movement:get_direction4()
    main_sprite:set_direction(direction4)
    sword_sprite:set_direction(direction4)
  end
end

function enemy:on_movement_finished(movement)

  if being_pushed then
    self:go_hero()
  end
end

function enemy:on_obstacle_reached(movement)

  if being_pushed then
    self:go_hero()
  end
end

function enemy:on_custom_attack_received(attack, sprite)

  if attack == "sword" and sprite == sword_sprite then
    sol.audio.play_sound("sword_tapping")
    being_pushed = true
    local x, y = self:get_position()
    local angle = self:get_angle(self:get_map():get_entity("hero")) + math.pi
    local movement = sol.movement.create("straight")
    movement:set_speed(128)
    movement:set_angle(angle)
    movement:set_max_distance(26)
    movement:set_smooth(true)
    movement:start(self)
  end
end

function enemy:go_random()
  local movement = sol.movement.create("random_path")
  movement:set_speed(properties.normal_speed)
  movement:start(self)
  being_pushed = false
  going_hero = false
end

function enemy:go_hero()
    
  main_sprite:set_animation("idle")
  sword_sprite:set_animation("idle")
  self:stop_movement()

  seeing_hero = true

  sol.timer.start(self, 500, function() 
    sol.audio.play_sound("hero_seen")
    main_sprite:set_animation("running")
    sword_sprite:set_animation("running")
    local movement = sol.movement.create("target")
    movement:set_speed(properties.faster_speed)
    movement:start(self)
    being_pushed = false
    seeing_hero = false
    going_hero = true
      
  end)
--[[
  main_sprite:set_animation("running")
  sword_sprite:set_animation("running")
  local movement = sol.movement.create("target")
  movement:set_speed(properties.faster_speed)
  movement:start(self)
  being_pushed = false
  going_hero = true--]]
end

--[[
function enemy:on_update()
  self:can_see_hero()
  print(self:get_game():get_degree(self, self:get_map():get_entity("hero")))
end

function enemy:can_see_hero()
  local hero = self:get_map():get_entity("hero")
  local dir = main_sprite:get_direction()
  local degree = self:get_game():get_degree(self, hero)
  print(dir, degree)
  print(dir == self:get_direction4_to(hero))
  return false
end

--]]
