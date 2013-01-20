_GOAL = {}

_GOAL.__index = _GOAL

function _GOAL.new(width, height, posX, posY)
	local goal = {}
	setmetatable(goal, _GOAL)

	body = FUWorld:addBody(MOAIBox2DBody.STATIC)

	poly = {
		posX, posY,
		posX + width, posY,
		posX + width, posY + height,
	}

	fixture = body:addPolygon (poly)
	fixture:setDensity(1)
	fixture:setFriction(.8)
	fixture:setFilter(0x01, 0x01)

	fixture:setCollisionHandler (onCollideWithGoal, MOAIBox2DArbiter.ALL, 0x01, 0x01)

	body:resetMassData()
	return goal
end

function onCollideWithGoal(event, goal, box)
	if event == MOAIBox2DArbiter.BEGIN then beginCollisionWithGoal(goal,box) end
	if event == MOAIBox2DArbiter.END then endCollisionWithGoal(goal,box) end
	if event == MOAIBox2DArbiter.PRE_SOLVE then preCollisionWithGoal(goal,box) end
	if event == MOAIBox2DArbiter.POST_SOLVE then postCollisionWithGoal(goal,box) end
end

function preCollisionWithGoal(goal, box)
	box:getBody():setLinearVelocity(0, -.1)
	box:getBody():setAngularVelocity(0)
	box:setFilter(0x02, 0x02)
	local fix = BoxForFixture[box]
	fix:deactivateWhenResting()
end

function beginCollisionWithGoal(goal, box)
	print("begin")
	--GameplayLayer:removeProp(boxForFixture[box].sprite)
	--box:getBody():destroy()
	--box:setFilter(0x02)
	--goal:getBody():setActive(false)

end

function endCollisionWithGoal(goal, box)
	--box:getBody():setActive(false)
	--goal:getBody():setActive(true)
	--box:getBody():destroy()
	--if box:getBody():getLinearVelocity() == 0 then box:getBody():destroy() end
end

function postCollisionWithGoal(goal, box)
	--box:getBody():setActive(false)
	--boxObject = boxForFixture[box]
	--box:setFilter(0x02)
	--print("filter", box:getFilter())
	--goal:getBody():setActive(true)
end

return _GOAL