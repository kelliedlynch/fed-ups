levelWidth = 1000
levelHeight = 320
floorHeight = 50
local verticalVariation = 30 -- in screen units (pixels)
local horizontalVariation = .2 -- multipy this by x-value to get variation
local goalWidth = 50
local goalHeight = 60

TerrainBody = FUWorld:addBody(MOAIBox2DBody.STATIC)
CameraFitter:setBounds(0, 0, levelWidth, levelHeight)

TerrainGenerator = require "FUTerrain"
TerrainGenerator.generateRandomSurface()

-- draw the edges of the screen
TerrainBody:addEdges({0,0,0,levelHeight})
TerrainBody:addEdges({levelWidth, 0, levelWidth, levelHeight})
TerrainBody:addEdges({0,ScreenHeight, levelWidth, levelHeight})
-- draw the floor of the goal area
TerrainBody:addEdges({levelWidth - goalWidth, floorHeight, levelWidth, floorHeight})

FUGoal = require "FUGoal"
local goal = FUGoal.new(goalWidth, goalHeight, levelWidth-goalWidth, floorHeight)

FULauncher = require "FULauncher"
Launcher = FULauncher.new()