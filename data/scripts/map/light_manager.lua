local light_manager = ...
require("scripts/multi_events")

local map_meta=sol.main.get_metatable("map")
local game_meta=sol.main.get_metatable("game")

-- Dark overlay for each hero direction.
local dark_surfaces = {
  [0] = sol.surface.create("entities/dark0.png"),
  [1] = sol.surface.create("entities/dark1.png"),
  [2] = sol.surface.create("entities/dark2.png"),
  [3] = sol.surface.create("entities/dark3.png")
}
game_meta:register_event("on_started", function(game)
  game.light = 0
  game.get_light = function(map)
    return game.light
  end

  game.set_light = function(game, light)
    if light < 0 then light = 0 elseif light > 16 then light = 16 end
    game.light = light
  end

  game.add_light = function(game, amount)
    local light = game.light - amount
    if light < 0 then light = 0 elseif light > 16 then light = 16 end
    game.light = light
  end
  
  game.ambientlight = {0,0,0,0}
  game.set_ambient_light = function(game, ambientlight)
    if ambientlight == nil or ambientlight == "" then
      game.ambientlight = {0,0,255,48}
    elseif ambientlight == "day" then
      game.ambientlight = {0,0,0,0}
    elseif ambientlight == "night" then
      game.ambientlight = {0,0,255,48}
    end
  end
end)


game_meta:register_event("on_map_changed", function(game)
  local map = game:get_map()
  for ent in map:get_entities("settings") do
    local lightlevel = split(split(ent:get_name(), "settings:")[1],"-")[1]
    local ambientlevel = split(split(ent:get_name(), "settings:")[1],"-")[2]
    game:set_light(tonumber(lightlevel))
    game:set_ambient_light(ambientlevel)
  end


  local rainsprite1 = sol.sprite.create("entities/rain")
  local rainsprite2 = sol.sprite.create("entities/rain")
  rainsprite2:set_direction(1)

  rainsprite1:set_blend_mode("add")
  rainsprite2:set_blend_mode("add")

  local rainposx = {}
  local rainposy = {}
  math.randomseed(397)
  for i = 1, 4096 do
    rainposx[i] = math.random(2048)
    rainposy[i] = math.random(2048)
  end

  map:get_game().raintimer = 0
  map:get_game().on_update = function(game)
    if(game.raintimer <= 0 and map:get_id():find("^lightworld")) then
      game.raintimer = 150
      sol.audio.play_sound("water_fill")
    end
    game.raintimer = game.raintimer - 1
  end

  map.on_draw = function(map, dst_surface)

    local game = map:get_game()
    local has_lamp_equiped = (game:get_item_assigned(1) ~= nil and game:get_item_assigned(1):get_name() == "lamp")
    local camera_x, camera_y = map:get_camera():get_bounding_box()

    dst_surface:fill_color(game.ambientlight, 0, 0, 1024, 1024)

    if game:get_light() == 16 then
      local black = {0, 0, 0,  math.min(16 * game.light, 255)}
      -- Dark room.
      local screen_width, screen_height = dst_surface:get_size()
      local hero = map:get_entity("hero")
      local hero_x, hero_y = hero:get_center_position()
      local x = 320 - hero_x + camera_x
      local y = 240 - hero_y + camera_y
      local dark_surface = dark_surfaces[hero:get_direction()]
      dark_surface:set_opacity(math.min(16 * game.light, 255))
      dark_surface:draw_region(
          x, y, screen_width, screen_height, dst_surface)
      

      -- dark_surface may be too small if the screen size is greater
      -- than 320x240. In this case, add black bars.
      if x < 0 then
        dst_surface:fill_color(black, 0, 0, -x, screen_height)
      end

      if y < 0 then
        dst_surface:fill_color(black, 0, 0, screen_width, -y)
      end

      local dark_surface_width, dark_surface_height = dark_surface:get_size()
      if x > dark_surface_width - screen_width then
        dst_surface:fill_color(black, dark_surface_width - x, 0,
            x - dark_surface_width + screen_width, screen_height)
      end

      if y > dark_surface_height - screen_height then
        dst_surface:fill_color(black, 0, dark_surface_height - y,
            screen_width, y - dark_surface_height + screen_height)
      end
    else
      dst_surface:fill_color({0, 0, 0, math.min(16 * game.light, 255)}, 0, 0, 1024, 1024)
    end

    if map:get_id():find("^lightworld") then
      if (math.random(100) == 1) then
        dst_surface:fill_color({255, 255, 255, 128}, 0, 0, 1024, 1024)
      end
    
      for i = 1, 1024 do
        map:draw_visual(rainsprite1, rainposx[i] + camera_x / 1.5, rainposy[i] + camera_y / 1.5)
      end

      for i = 1024, 4096 do
        map:draw_visual(rainsprite2, rainposx[i] + camera_x / 1.5, rainposy[i] + camera_y / 1.5)
      end
    end
  end
end)