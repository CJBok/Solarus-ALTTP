-- Sets up all non built-in gameplay features specific to this quest.

-- Usage: require("scripts/features")

-- Features can be enabled to disabled independently by commenting
-- or uncommenting lines below.

require("scripts/menus/alttp_dialog_box")

require("scripts/hud/hud")

require("scripts/map/doors")
require("scripts/map/light_manager")
require("scripts/map/wakeup_enemies")

require("scripts/hero/transition_animations")

return true
