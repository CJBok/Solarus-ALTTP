-- Sets up all non built-in gameplay features specific to this quest.

-- Usage: require("scripts/features")

-- Features can be enabled to disabled independently by commenting
-- or uncommenting lines below.

require("scripts/menus/alttp_dialog_box")

require("scripts/hud/hud")

require("scripts/entities/chests")
require("scripts/entities/doors")
require("scripts/entities/loottable")

require("scripts/map/light_manager")
require("scripts/map/wakeup_enemies")

require("scripts/hero/transition_animations")
require("scripts/hero/events")

return true
