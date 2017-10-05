local enemy = ...

-- Gelidrak's head

local body = nil               -- Gelidrak's body.
local vulnerable = false       -- Becomes vulnerable when the tail is hurt.
local vulnerable_delay = 5000  -- Delay while the head remains vulnerable.
local nb_flames_created = 0
local going_back = false

function enemy:on_created()

  body = self:get_map():get_entity("boss")

  self:set_life(24)
  self:set_damage(12)
  self:create_sprite("enemies/gelidrak_head")
  self:set_size(32, 40)
  self:set_origin(16, 24)
  self:set_hurt_style("boss")
  self:set_obstacle_behavior("flying")
  self:set_treasure(nil)
  self:set_layer_independent_collisions(true)
  self:set_push_hero_on_sword(true)

  self:set_invincible()
  self:set_attack_consequence("sword", "protected")
  self:set_attack_consequence("hookshot", "protected")
  self:set_attack_consequence("boomerang", "protected")
  self:set_attack_consequence("arrow", "protected")
  self:set_pushed_back_when_hurt(false)
end

function enemy:on_restarted()

  if not vulnerable then
    sol.timer.start(self, math.random(2000, 5000), function()
      self:throw_flames()
    end)
    self:go_back()
  else
    self:set_can_attack(false)
  end
end

function enemy:on_collision_enemy(other_enemy, other_sprite, my_sprite)

  -- Make sure the head stays south of the body.
  if other_enemy == body and not vulnerable and not going_back then
    self:go_back()
  end
end

function enemy:go_back()

  local x, y = body:get_position()
  local m = sol.movement.create("target")
  m:set_speed(16)
  m:set_target(x, y + 48)
  m:set_ignore_obstacles(true)
  m:start(self)
  going_back = true
end

function enemy:on_movement_finished(movement)

  local m = sol.movement.create("random")
  m:set_speed(32)
  m:set_max_distance(16)
  m:set_ignore_obstacles(true)
  m:start(self)
  going_back = false
  sol.timer.start(self, 5000, function() self:go_back() end)
end

-- This function is called by the body.
function enemy:set_vulnerable()

  if not vulnerable then
    -- The head now becomes vulnerable.
    vulnerable = true
    self:stop_movement()
    self:set_can_attack(false)
    self:set_attack_consequence("sword", 1)
    local sprite = self:get_sprite()
    sprite:set_animation("walking")
    sol.timer.stop_all(self)
    sol.timer.start(  -- To make this timer persist after the enemy gets hurt.
        self:get_map(),
        vulnerable_delay,
        function()
          if self:get_life() > 0 then
            vulnerable = false
            self:on_restarted()
            self:set_can_attack(true)
            self:set_attack_consequence("sword", "protected")
            body:head_recovered()
          end
        end
    )
  end
end

function enemy:on_hurt(attack)

  if self:get_life() <= 0 then
    body:head_dying()
  end
end

function enemy:on_dead()

  -- Notify the body.
  body:head_dead()
end

function enemy:throw_flames()

  if self:get_map():get_entities_count(self:get_name() .. "_son_") < 5 then
    nb_flames_created = 0
    self:stop_movement()
    local sprite = self:get_sprite()
    sprite:set_animation("preparing_flame")
    sol.audio.play_sound("lamp")
    sol.timer.start(self, 500, function() self:repeat_flame() end)
  end
end

function enemy:repeat_flame()

  local max_flames_created = 32 - self:get_life()
  if nb_flames_created <= max_flames_created then
    nb_flames_created = nb_flames_created + 1
    local son_name = self:get_name() .. "_son_" .. nb_flames_created
    local angle = math.random(360) * math.pi / 180
    local son = self:create_enemy{
      name = son_name,
      breed = "blue_flame",
      x = 0,
      y = 16,
    }
    son:go(angle)
    sol.audio.play_sound("lamp")
    sol.timer.start(self, 150, function() self:repeat_flame() end)
  else
    sol.timer.start(self, 500, function() self:restart() end)
  end
end

