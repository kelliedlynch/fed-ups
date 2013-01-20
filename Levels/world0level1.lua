TerrainBody = FUWorld:addBody(MOAIBox2DBody.STATIC)

local levelWidth = 1000
local levelHeight = 800
local startingHeight = 50
local verticalVariation = 30 -- in screen units (pixels)
local horizontalVariation = .2 -- multipy this by x-value to get variation
local goalWidth = 50
local goalHeight = 60

CameraFitter:setBounds(0, 0, levelWidth, levelHeight)
HUDLayer:setParent(CameraAnchor)


-- local terrainWidth = levelWidth - goalWidth
-- local currentWidth, terrainHeight = 0, startingHeight
-- local vertices = { currentWidth, terrainHeight}
-- while #vertices < 16 do
-- 	-- how many points are left?
-- 	local pointsLeft = 8 - (#vertices / 2)
-- 	-- how much distance is left?
-- 	local remainingWidth = terrainWidth - currentWidth
-- 	-- so the approximate x-distance of the next point is...
-- 	local nextX = remainingWidth / pointsLeft
-- 	-- and the y-value will be:
-- 	local nextY = vertices[#vertices] + math.random(-20, 20)
-- 	-- constrain the height later.

-- 	if pointsLeft == 1 then
-- 		table.insert(vertices, terrainWidth)
-- 		table.insert(vertices, startingHeight)
-- 	else
-- 		nextX = currentWidth + nextX + math.random((-nextX*horizontalVariation), (nextX*horizontalVariation))
-- 		table.insert(vertices, nextX)
-- 		table.insert(vertices, nextY)
-- 	end
-- 	currentWidth = nextX
-- end 
-- draw the edges of the screen
TerrainBody:addEdges({0,0,0,levelHeight})
TerrainBody:addEdges({levelWidth, 0, levelWidth, levelHeight})
TerrainBody:addEdges({0, levelHeight, levelWidth, levelHeight})
-- draw the floor of the goal area
TerrainBody:addEdges({0, startingHeight, levelWidth, startingHeight})


FUGoal = require "FUGoal"
goal = FUGoal.new(goalWidth, goalHeight, levelWidth-goalWidth, startingHeight)

FULauncher = require "FULauncher"
Launcher = FULauncher.new()