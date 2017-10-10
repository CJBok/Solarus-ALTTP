local generic_soldier = {}

function generic_soldier:initialize(enemy)

  local properties = {}
  local interrupted = false
  local main_sprite = nil
  local sword_sprite = nil
  local state = "idle"
  local attacking = false

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

    properties.path = enemy:get_game():get_patrol(enemy)
  end


  function enemy:on_restarted()
    if state == "idle" and not interrupted and properties.path ~= nil then
      self:patrol_movement() 
    elseif state == "idle" then
      self:random_movement() 
    end
  end


  function enemy:on_update()

    if enemy:get_sprite() == nil then return end

    local movement = enemy:get_movement()
    local animation = enemy:get_sprite():get_animation()
    if movement ~= nil and (animation == "walking" or animation == "running") then
      self:set_direction(movement:get_direction4())
    end

    if state == "patrolling" or state == "random" then
      if self:can_see_hero() then
        state = "provoked"
      end
    end

    if state == "provoked" then
      self:set_animation("idle")
      self:stop_movement()
      state = "provoking"
      interrupted = true
      
      sol.timer.start(self, 300, function()
        
        state = "attack"
      end)
    end

    if state == "attack" then
      self:attack_hero_movement()
    end

    if state == "hurt" then
      sol.timer.start(self, 300, function()
        state = "attack"
      end)
    end
  end


  function enemy:patrol_movement()
    state = "patrolling"
    self:set_animation("walking")
    local movement = sol.movement.create("path")
    movement:set_path(properties.path)
    movement:set_speed(properties.normal_speed)
    movement:set_loop(true)
    movement:start(self)
  end


  function enemy:attack_hero_movement()
    if not attacking then
      sol.audio.play_sound("hero_seen")
    end
    attacking = true
    state = "attacking"
    self:set_animation("running")
    local movement = sol.movement.create("target")
    movement:set_speed(properties.faster_speed)
    movement:start(self)
    sol.timer.start(self, 5000, function()
      self:searching()
    end)
  end


  function enemy:random_movement()
    state = "random"
    self:set_animation("walking")
    local movement = sol.movement.create("random_path")
    movement:set_speed(properties.normal_speed)
    movement:start(self)
  end


  function enemy:can_see_hero()
    local hero = self:get_map():get_entity("hero")
    local _, _, layer = self:get_position()
    local _, _, hero_layer = hero:get_position()
    local near_hero = layer == hero_layer and self:get_distance(hero) < 100
    local facing_hero = main_sprite:get_direction() == self:get_direction4_to(hero)

    return near_hero and facing_hero
  end


  function enemy:searching()
    attacking = false
    state = "searching"
    self:stop_movement()
    self:set_animation("idle")
    sol.timer.start(self, 2000, function() 
      state = "idle"
      self:restart()
    end)
  end


  function enemy:on_hurt()
    state = "hurt"
  end


  function enemy:on_dying()
    self:stop_movement()
    state = "died"
  end


  function enemy:on_custom_attack_received(attack, sprite)
    if attack == "sword" and sprite == sword_sprite then
      state = "tapped"
      self:set_animation("idle")
      sol.audio.play_sound("sword_tapping")
      local x, y = self:get_position()
      local angle = self:get_angle(self:get_map():get_entity("hero")) + math.pi
      local movement = sol.movement.create("straight")
      movement:set_speed(128)
      movement:set_angle(angle)
      movement:set_max_distance(26)
      movement:set_smooth(true)
      movement:start(self, function()
        state = "provoked"
      end)
    end
  end


  function enemy:set_direction(direction)
    sword_sprite:set_direction(direction)
    main_sprite:set_direction(direction)
  end


  function enemy:set_animation(animation)
    sword_sprite:set_animation(animation)
    main_sprite:set_animation(animation)
  end

  function enemy:on_attacking_hero(hero, enemy_sprite)
    if enemy:overlaps(hero) and not hero:is_blinking() then
      hero:start_hurt(enemy, properties.damage)
    end
  end 

end

return generic_soldier
