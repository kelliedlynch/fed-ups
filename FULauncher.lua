_L = {}

_L.__index = _L

function _L.new()
	local launcher = {}
	setmetatable(launcher, _L)

	local size = 20
	local bodyX = 80
	local bodyY = screenHeight/2 - size/2

	body = world:addBody(MOAIBox2DBody.STATIC)

	poly = {
		bodyX, bodyY,
		bodyX + size, bodyY,
		bodyX + size, bodyY + size,
		bodyX, bodyY + size,
	}

	fixture = body:addPolygon (poly)
	fixture:setDensity(1)
	fixture:setFriction(.8)
	fixture:setFilter(0x02, 0x02)
	startX, startY = bodyX + size/2, bodyY + size/2

	fixture:setCollisionHandler (onCollideWithLauncher, MOAIBox2DArbiter.ALL, 0x02, 0x02)

	body:resetMassData()
	return launcher
end

function _L:drawLaunchLine()
	local scriptDeck = MOAIScriptDeck.new ()
	scriptDeck:setRect ( 0,0, screenWidth, screenHeight )
	scriptDeck:setDrawCallback ( onDraw )
	launchLine = MOAIProp2D.new ()
	launchLine:setDeck ( scriptDeck )
	HUDLayer:insertProp ( launchLine )
end

function onDraw ( index, xOff, yOff, xFlip, yFlip )
	MOAIGfxDevice.setPenColor ( 1, 1, 1, 1 )
	MOAIGfxDevice.setPenWidth ( 2 )
	MOAIDraw.drawLine (
		startX, startY,
		worldX, worldY
	)
end

function onCollideWithLauncher()
	print("collision with launcher")
end

return _L