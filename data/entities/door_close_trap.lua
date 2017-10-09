-- Automatically hides/shows door entity when hero is in range

local entity = ...
local map = entity:get_map()
local hero = entity:get_map():get_hero()
