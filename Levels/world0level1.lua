levelWidth = 1000
levelHeight = 800
floorHeight = 50
local goalWidth = 50
local goalHeight = 60

TerrainBody = FUWorld:addBody(MOAIBox2DBody.STATIC)
CameraFitter:setBounds(0, 0, levelWidth, levelHeight)

-- draw the edges of the screen
local left = TerrainBody:addPolygon({0,0,0,levelHeight,0,0})
left:setFilter(FILTER_ACTIVE_TERRAIN, FILTER_ACTIVE_BOX, GROUP_PRIMARY_OBJECTS)
local right = TerrainBody:addPolygon({levelWidth, 0, levelWidth, levelHeight, levelWidth, 0})
right:setFilter(FILTER_ACTIVE_TERRAIN, FILTER_ACTIVE_BOX, GROUP_PRIMARY_OBJECTS)
local ceiling = TerrainBody:addPolygon({0, levelHeight, levelWidth, levelHeight, 0, levelHeight})
ceiling:setFilter(FILTER_ACTIVE_TERRAIN, FILTER_ACTIVE_BOX, GROUP_PRIMARY_OBJECTS)
-- draw the floor of the goal area
local floor = TerrainBody:addPolygon({0, floorHeight, levelWidth, floorHeight, 0, floorHeight})
floor:setFilter(FILTER_ACTIVE_TERRAIN, FILTER_ACTIVE_BOX, GROUP_PRIMARY_OBJECTS)

FUGoal = require "FUGoal"
local goal = FUGoal.new(goalWidth, goalHeight, levelWidth-goalWidth, floorHeight)

FULauncher = require "FULauncher"
Launcher = FULauncher.new()

TG = require "FUTerrain"
--TG.rect(500, 50, 400, 100)
TG.trampoline(300, 280, 500, 40, 180)
TG.trampoline(300, 40, 500, 40, 0)