local enemy = ...

-- Agahnim (Boss of dungeon 8).

-- Possible positions where he appears.
local positions = {
  {x = 488, y = 317},
  {x = 560, y = 317},
  {x = 704, y = 317},
  {x = 776, y = 317},
  {x = 488, y = 421},
  {x = 560, y = 421},
  {x = 704, y = 421},
  {x = 776, y = 421},
  {x = 488, y = 525},
  {x = 560, y = 525},
  {x = 704, y = 525},
  {x = 776, y = 525},
}

local nb_sons_created = 0
local initial_life = 16
local blue_fireball_proba = 33  -- Percent.
local next_fireball_sound
local next_fireball_breed
local vulnerable = false
local hurt_proba
local middle_dialog = false
local nb_fakes_created = 0
local sprite

function enemy:on_created()

  self:set_life(initial_life)
  self:set_damage(16)
  self:set_hurt_style("boss")
  self:set_optimization_distance(0)
  self:set_size(16, 16)
  self:set_origin(8, 13)
  self:set_position(-100, -100)
  self:set_invincible()
  self:set_attack_consequence("sword", "protected")
  self:set_attack_consequence("arrow", "protected")
  self:set_attack_consequence("hookshot", "protected")
  self:set_attack_consequence("boomerang", "protected")
  self:set_pushed_back_when_hurt(false)
  self:set_push_hero_on_sword(true)
  self:set_can_attack(false)

  sprite = self:create_sprite("enemies/agahnim_2")
end

function enemy:on_restarted()

  vulnerable = false
  sprite:set_animation("stopped")
  sol.timer.start(self, 100, function()
    sprite:fade_out(function() self:hide() end)
  end)
end

function enemy:on_update()

  -- Look in the direction of the hero.
  sprite:set_direction(self:get_direction4_to_hero())
end

function enemy:get_direction4_to_hero()

  local hero = self:get_map():get_entity("hero")
  local angle = self:get_angle(hero)
  local direction4 = (angle + (math.pi / 4)) * 2 / math.pi
  return (math.floor(direction4) + 4) % 4
end

function enemy:hide()

  -- Disappear for a while.
  vulnerable = false
  self:set_position(-100, -100)
  sol.timer.start(self, 500, function()
    self:unhide()
  end)
end

function enemy:unhide()

  -- Come back somewhere.
  local position = (positions[math.random(#positions)])
  self:set_position(position.x, position.y)
  sprite:set_animation("walking")
  sprite:set_direction(self:get_direction4_to_hero())
  sprite:fade_in()
  sol.timer.start(self, 1000, function()
    self:fire_step_1()
  end)
end

function enemy:fire_step_1()

  -- Before preparing a fireball.
  sprite:set_animation("arms_up")
  sol.timer.start(self, 1000, function()
    self:fire_step_2()
  end)
  self:set_can_attack(true)
end

function enemy:fire_step_2()

  -- Prepare a fireball (red or blue).
  local blue = math.random(100) <= blue_fireball_proba

  if math.random(5) == 1 then
    -- Don't tell the player if it will be red or blue.
    sprite:set_animation("preparing_unknown_fireball")
  elseif blue then
    -- Blue fireball: the hero can do nothing but run away.
    sprite:set_animation("preparing_blue_fireball")
  else
    -- Red fireball: possible to shoot it back to Agahnim.
    sprite:set_animation("preparing_red_fireball")
  end

  if blue then
    next_fireball_sound = "cane"
    next_fireball_breed = "blue_fireball_triple"
  else
    next_fireball_sound = "boss_fireball"
    next_fireball_breed = "red_fireball_triple"
  end
  sol.audio.play_sound("boss_charge")
  sol.timer.start(self, 1500, function()
    self:fire_step_3()
  end)
end

function enemy:fire_step_3()

  -- Shoot the fireball(s).
  sprite:set_animation("stopped")
  sol.audio.play_sound(next_fireball_sound)
  vulnerable = true

  local delay  -- Delay before fading out and going somewhere else.
  if next_fireball_breed == "blue_fireball_triple" then
    delay = 700
  else
    delay = 3000  -- Red fireball: stay longer to play ping-pong.
  end
  sol.timer.start(self, delay, function()
    self:restart()
  end)

  local function throw_fire()
    nb_sons_created = nb_sons_created + 1
    self:create_enemy{
      name = "agahnim_fireball_" .. nb_sons_created,
      breed = next_fireball_breed,
      x = 0,
      y = -21,
    }
  end

  throw_fire()

  -- Shoot more fireballs if the life becomes short.
  local life = self:get_life()
  if life <= initial_life / 2 then
    sol.timer.start(self, 200, function() throw_fire() end)
    sol.timer.start(self, 400, function() throw_fire() end)
    if life <= initial_life / 4 then
      sol.timer.start(self, 600, function() throw_fire() end)
      sol.timer.start(self, 800, function() throw_fire() end)
    end
  end

  -- Play ping-pong.
  if life <= initial_life * 3 / 4 then
    hurt_proba = 20
  else
    hurt_proba = 100
  end
end

function enemy:receive_bounced_fireball(fireball)

  if fireball:get_name():find("^agahnim_fireball")
      and vulnerable then
    -- Receive a fireball shot back by the hero: get hurt or throw it back.
    if math.random(100) <= hurt_proba then
      fireball:remove()
      self:hurt(1)
    else
      -- Play ping-pong.
      sol.audio.play_sound("boss_fireball")
      fireball:bounce()
      hurt_proba = hurt_proba + 20
    end
  end
end

function enemy:on_hurt(attack)

  local life = self:get_life()
  if life <= 0 then
    -- Dying.
    self:get_map():remove_entities("agahnim_fireball")
    self:get_map():remove_entities(self:get_name() .. "_")
    sprite:set_ignore_suspend(true)
    self:get_map():get_game():start_dialog("dungeon_8.agahnim_end")
    sol.timer.stop_all(self)
  elseif life <= initial_life * 2 / 3 then
    -- Not dying yet: start creating fakes after a few hits.
    sprite:set_ignore_suspend(true)
    if not middle_dialog then
      self:get_map():get_game():start_dialog("dungeon_8.agahnim_middle")
      middle_dialog = true
    end
    self:create_fakes()
  end
end

-- Create fake Agahnims.
function enemy:create_fakes()

  local prefix = self:get_name() .. "_fake_"
  if self:get_map():get_entities_count(prefix) < 3 then
    nb_fakes_created = nb_fakes_created + 1
    local fake_name = prefix .. nb_fakes_created
    self:create_enemy{
      name = fake_name,
      breed = "agahnim_2_fake",
    }
  end

  if self:get_life() < initial_life / 3
      and self:get_map():get_entities_count(prefix) < 2 then
    -- Create a second one.
    self:create_fakes()
  end
end
