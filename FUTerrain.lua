_T = {}

function _T.generateRandomSurface()
	local verticalVariation = 30 -- in screen units (pixels)
	local horizontalVariation = .2 -- multipy this by x-value to get variation
	local goalWidth = 50
	local goalHeight = 60

	local terrainWidth = levelWidth - goalWidth
	local currentWidth, terrainHeight = 0, floorHeight
	local vertices = { currentWidth, terrainHeight}
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
			table.insert(vertices, floorHeight)
		else
			nextX = currentWidth + nextX + math.random((-nextX*horizontalVariation), (nextX*horizontalVariation))
			table.insert(vertices, nextX)
			table.insert(vertices, nextY)
		end
		currentWidth = nextX
	end 
	-- draw the varied terrain
	TerrainBody:addChain(vertices)
end

function _T.rect(x1, y1, x2, y2)
	local fixture = TerrainBody:addRect(x1, y1, x2, y2)
	fixture:setDensity(1)
	fixture:setFriction(.8)

	TerrainBody:resetMassData()
end

function _T.trampoline(x1, y1, x2, y2)
	local fixture = TerrainBody:addRect(x1, y1, x2, y2)
	fixture:setDensity(1)
	fixture:setFriction(.8)
	fixture:setRestitution(2)
	fixture:setFilter(FILTER_ACTIVE_TERRAIN, FILTER_ACTIVE_BOX)
	fixture:setCollisionHandler (onCollideWithTrampoline, MOAIBox2DArbiter.ALL, FILTER_ACTIVE_BOX)

	TerrainBody:resetMassData()
end

function onCollideWithTrampoline(event, trampoline, box)
	print("collision with trampoline")
	-- if event == MOAIBox2DArbiter.BEGIN then beginCollisionWithGoal(goal,box) end
	-- if event == MOAIBox2DArbiter.END then endCollisionWithGoal(goal,box) end
	-- if event == MOAIBox2DArbiter.PRE_SOLVE then preCollisionWithGoal(goal,box) end
	-- if event == MOAIBox2DArbiter.POST_SOLVE then postCollisionWithGoal(goal,box) end
end

-- function preCollisionWithGoal(goal, box)
-- 	box:getBody():setLinearVelocity(0, -.1)
-- 	box:getBody():setAngularVelocity(0)
-- 	box:setFilter(FILTER_INACTIVE_BOX, FILTER_ACTIVE_TERRAIN)
-- 	local fix = BoxForFixture[box]
-- 	fix:deactivateWhenResting()
-- end

-- function beginCollisionWithGoal(goal, box)
-- 	print("begin")
-- 	--GameplayLayer:removeProp(boxForFixture[box].sprite)
-- 	--box:getBody():destroy()
-- 	--box:setFilter(0x02)
-- 	--goal:getBody():setActive(false)

-- end

-- function endCollisionWithGoal(goal, box)
-- 	--box:getBody():setActive(false)
-- 	--goal:getBody():setActive(true)
-- 	--box:getBody():destroy()
-- 	--if box:getBody():getLinearVelocity() == 0 then box:getBody():destroy() end
-- end

-- function postCollisionWithGoal(goal, box)
-- 	--box:getBody():setActive(false)
-- 	--boxObject = boxForFixture[box]
-- 	--box:setFilter(0x02)
-- 	--print("filter", box:getFilter())
-- 	--goal:getBody():setActive(true)
-- end

return _T