_T = {}

_T.__index = _T

function _T.new(x, y, w, h, angle)
	-- x, y is the center of the trampoline
	local xmod, ymod
	if not angle then angle=0 end
	angle = math.rad(angle)

	if angle >= 0 and angle < 90 then
		xmod, ymod = 1, 1
	elseif angle >= 90 and angle < 180 then
		xmod, ymod = 1, -1
	elseif angle >= 180 and angle < 270 then
		xmod, ymod = -1, -1
	elseif angle >= 270 and angle < 360 then
		xmod, ymod = -1, 1
	else
		print("invalid angle")
		xmod, ymod = 1, 1
	end

	-- find the top center point of the trampoline
	local th = h/2
	local tcx = -math.sin(angle) * th + x
	local tcy = math.cos(angle) * th + y

	-- find the "upper right" corner of the trampoline
	local h1 = w/2
	local x1 = math.cos(angle) * h1 + tcx
	local y1 = math.sin(angle) * h1 + tcy

	-- find the "upper left" corner of the trampoline
	local h2 = w
	local x2 = -math.cos(angle) * h2 + x1
	local y2 = -math.sin(angle) * h2 + y1

	-- find the "lower left" corner of the trampoline
	local h3 = h
	local x3 = math.sin(angle) * h3 + x2
	local y3 = -math.cos(angle) * h3 + y2

	-- find the "lower right" corner of the trampoline
	local h4 = w
	local x4 = math.cos(angle) * h4 + x3
	local y4 = math.sin(angle) * h4 + y3

	print("coords", x1, y1, x2, y2, x3, y3, x4, y4)

	local fixture = TerrainBody:addPolygon({x1, y1, x2, y2, x3, y3, x4, y4})
	fixture:setDensity(1)
	fixture:setFriction(.8)
	fixture:setFilter(FILTER_ACTIVE_TERRAIN, FILTER_ACTIVE_BOX)
	fixture:setCollisionHandler (onCollideWithTrampoline, MOAIBox2DArbiter.ALL, FILTER_ACTIVE_BOX)

	fixture.angle = angle

	TerrainBody:resetMassData()
end

function onCollideWithTrampoline(event, trampoline, box)
	print("collision with trampoline")
	if event == MOAIBox2DArbiter.BEGIN then beginCollisionWithTrampoline(trampoline,box) end
	if event == MOAIBox2DArbiter.END then endCollisionWithTrampoline(trampoline,box) end
	if event == MOAIBox2DArbiter.PRE_SOLVE then preCollisionWithTrampoline(trampoline,box) end
	if event == MOAIBox2DArbiter.POST_SOLVE then postCollisionWithTrampoline(trampoline,box) end
end

function preCollisionWithTrampoline(trampoline, box)
	print("pre")

	local velX, velY = box:getBody():getLinearVelocity()
	local boxAngle = math.atan(velY/velX)

	if velX < 0 and velY > 0 then
		boxAngle = boxAngle + math.rad(180)
	elseif velX < 0 and velY < 0 then
		boxAngle = boxAngle + math.rad(180)
	end

	local exitAngle = -(boxAngle - trampoline.angle) + trampoline.angle

	-- get the hypoteneuse (total velocity)
	local h = math.sqrt(velX^2 + velY^2)
	eVelX = math.cos(exitAngle) * h
	eVelY = math.sin(exitAngle) * h	
end

function beginCollisionWithTrampoline(trampoline, box)
	print("begin")
end

function endCollisionWithTrampoline(trampoline, box)
	print("end")
end

function postCollisionWithTrampoline(trampoline, box)
	print("post")
	box:getBody():setLinearVelocity(eVelX, eVelY)
end

return _T