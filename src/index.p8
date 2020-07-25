pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--star trek: killer q'egh
--by ridgek
--https://ridgek.itch.io

-->8
---engine models
#include ./models/actors.lua
#include ./models/players.lua

-->8
---engine controllers
#include ./controllers/global.lua
#include ./controllers/actors.lua
#include ./controllers/players.lua

-->8
---engine views

-->8
---app
#include ./app/app.lua
#include ./app/game.lua

-->8
---demo modules
#include ./modules/global/camera.lua
#include ./modules/global/print-helpers.lua

#include ./modules/app/title-credits.lua
#include ./modules/app/title-menu.lua
#include ./modules/app/config-menu.lua

#include ./modules/actors/state-frames.lua
#include ./modules/actors/state-frames-deserialize.lua
#include ./modules/actors/2d-jump.lua
#include ./modules/actors/collision-aabb.lua

#include ./modules/actors/draw-sprite.lua

-->8
---demo models
#include ./models/demo-levels.lua
#include ./models/demo-player1.lua
#include ./models/demo-enemies.lua
#include ./models/demo-points.lua
#include ./models/demo-powerups.lua

-->8
---demo controllers
#include ./controllers/demo-levels.lua
#include ./controllers/demo-player1.lua
#include ./controllers/demo-enemies.lua
#include ./controllers/demo-points.lua
#include ./controllers/demo-powerups.lua

-->8
---demo views
#include ./views/demo-actors.lua
#include ./views/demo-hud.lua
#include ./views/demo-levels.lua
#include ./views/demo-player1.lua
#include ./views/demo-enemies.lua
#include ./views/demo-points.lua
#include ./views/demo-powerups.lua

-->8
---demo debug
#include ./modules/actors/draw-sprite-debug.lua
#include ./modules/actors/collision-aabb-debug.lua
