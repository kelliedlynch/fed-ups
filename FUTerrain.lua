function generateRandomSurface()

local startingHeight = 50
local verticalVariation = 30 -- in screen units (pixels)
local horizontalVariation = .2 -- multipy this by x-value to get variation
local goalWidth = 50
local goalHeight = 60

local terrainWidth = screenWidth - goalWidth
local currentWidth, terrainHeight = 0, startingHeight
local vertices = { currentWidth, terrainHeight}
print("starting", currentWidth, terrainHeight)
while #vertices < 16 do
	-- how many points are left?
	local pointsLeft = 8 - (#vertices / 2)
	-- how much distance is left?
	local remainingWidth = terrainWidth - currentWidth
	-- so the approximate x-distance of the next point is...
	local nextX = remainingWidth / pointsLeft
	-- and the y-value will be:
	local nextY = vertices[#vertices] + math.random(-20, 20)
	-- constrain the height later.

	if pointsLeft == 1 then
		table.insert(vertices, terrainWidth)
		table.insert(vertices, startingHeight)
	else
		nextX = currentWidth + nextX + math.random((-nextX*horizontalVariation), (nextX*horizontalVariation))
		table.insert(vertices, nextX)
		table.insert(vertices, nextY)
	end
	currentWidth = nextX
end 
-- draw the edges of the screen
staticBody:addEdges({0,0,0,screenHeight})
staticBody:addEdges({screenWidth, 0, screenWidth, screenHeight})
staticBody:addEdges({0,screenHeight, screenWidth, screenHeight})
-- draw the floor of the goal area
staticBody:addEdges({screenWidth - goalWidth, startingHeight, screenWidth, startingHeight})
-- draw the varied terrain
staticBody:addChain(vertices)

FUGoal = require "FUGoal"
goal = FUGoal.new(goalWidth, goalHeight, screenWidth-goalWidth, startingHeight)

end