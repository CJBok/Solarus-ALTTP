local enemy = ...

-- A spider boss from Newlink

local nb_sons_to_create = 0
local nb_sons_created = 0

function enemy:on_created()

  self:set_life(8)
  self:set_damage(2)
  self:set_hurt_style("boss")
  self:create_sprite("enemies/mowatulla")
  self:set_size(96, 112)
  self:set_origin(48, 64)
  self:set_push_hero_on_sword(true)
  self:set_invincible()
  self:set_attack_consequence("explosion", 1)
end

function enemy:on_restarted()

  sol.timer.start(self, 500, function()
    self:jump_or_son_phase()
  end)
  self:go()
end

function enemy:on_movement_finished(movement)

  self:on_restarted()
end

function enemy:on_update()

  local _, y = self:get_position()
  local _, hero_y = self:get_map():get_entity("hero"):get_position()
  if hero_y > y + 8 then
    self:set_attack_consequence("sword", 1)
    self:set_attack_consequence("arrow", 2)
  else
    self:set_attack_consequence("sword", "protected")
    self:set_attack_consequence("arrow", "protected")
  end
end

function enemy:on_hurt(attack)

  if self:get_life() <= 0 then
    -- I am dying: remove the sons.
    local sons_prefix = self:get_name() .. "_son"
    self:get_map():remove_entities(sons_prefix)
  end
end

function enemy:go()
  local m = sol.movement.create("random_path")
  m:set_speed(64)
  m:start(self)
  local sprite = self:get_sprite()
  sprite:set_animation("walking")
end

function enemy:son_phase_soon()

  self:stop_movement()
  sol.timer.start(self, 500, function()
    self:son_phase()
  end)
end

function enemy:son_phase()

  local sprite = self:get_sprite()
  sprite:set_animation("preparing_son")
  sol.audio.play_sound("stone")
  sol.timer.start(self, 1500, function() self:throw_son() end)

  if self:get_life() < 3 then
    nb_sons_to_create = 3
  else
    nb_sons_to_create = 1
  end

end

function enemy:throw_son()

  -- Create the son.
  nb_sons_created = nb_sons_created + 1
  local son_name = self:get_name() .. "_mini_" .. nb_sons_created
  self:create_enemy{
    name = son_name,
    breed = "mini_mowatulla",
    x = 0,
    y = 40,
  }
  sol.audio.play_sound("ice")

  -- See what to do next.
  nb_sons_to_create = nb_sons_to_create - 1
  if nb_sons_to_create > 0 then
    -- Throw another son in 0.5 second.
    sol.timer.start(self, 500, function() self:throw_son() end)
  else
    -- Finish the son phase.
    local sprite = self:get_sprite()
    sprite:set_animation("walking")
    local delay = 3500 + (math.random(3) * 1000)
    sol.timer.start(self, delay, function() self:jump_or_son_phase() end)
    sol.timer.start(self, 500, function() self:go() end)
  end
end

function enemy:jump_or_son_phase()

  if math.random(2) == 1 then

    local sons_prefix = self:get_name() .. "_son"
    local nb_sons = self:get_map():get_entities_count(sons_prefix)
    if nb_sons < 5 then
      self:son_phase_soon()
    else
      -- No son phase if there are already too much sons: jump instead.
      self:jump_phase()
    end
  else
    self:jump_phase()
  end
end

function enemy:jump_phase()

  local direction8
  local x, y = self:get_position()
  y = y - 16
  local hero_x, hero_y = self:get_map():get_entity("hero"):get_position()
  if hero_x > x then
    if y > 856 then
      direction8 = 1
    else
      direction8 = 0
    end
  else
    if y > 856 then
      direction8 = 3
    else
      direction8 = 4
    end
  end

  local m = sol.movement.create("jump")
  m:set_direction8(direction8)
  m:set_distance(112)
  m:set_speed(96)
  m:start(self)
  local sprite = self:get_sprite()
  sprite:set_animation("jumping")
  sol.audio.play_sound("jump")
end

