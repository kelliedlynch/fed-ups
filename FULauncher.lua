_L = {}

_L.__index = _L

function _L.new()
	local launcher = {}
	setmetatable(launcher, _L)

	local size = 20
	local bodyX = 80
	local bodyY = ScreenHeight/2 - size/2

	local body = FUWorld:addBody(MOAIBox2DBody.STATIC)
	launcher.body = body

	body:setTransform(bodyX, bodyY)

	local fixture = body:addRect(0, 0, size, size)
	fixture:setDensity(1)
	fixture:setFriction(.8)
	fixture:setFilter(FILTER_INACTIVE_TERRAIN, FILTER_INACTIVE_TERRAIN)
	launcher.x, launcher.y = bodyX + size/2, bodyY + size/2

	fixture:setCollisionHandler (onCollideWithLauncher, MOAIBox2DArbiter.ALL, FILTER_INACTIVE_TERRAIN, FILTER_INACTIVE_TERRAIN)

	body:resetMassData()
	return launcher
end

function _L:drawLaunchLine()
	local scriptDeck = MOAIScriptDeck.new ()
	local x, y, x1, y1 = 0, 0, levelWidth, levelHeight
	scriptDeck:setRect(x, y, x1, y1)
	scriptDeck:setDrawCallback(__launcher__onDraw)
	self.line = MOAIProp2D.new ()
	self.line:setDeck(scriptDeck)
	self.line:setLoc(0,0)
	PhysicsHUDLayer:insertProp(self.line)
end

function __launcher__onDraw( index, xOff, yOff, xFlip, yFlip)
	MOAIGfxDevice.setPenColor ( 1, 1, 1, 1 )
	MOAIGfxDevice.setPenWidth ( 2 )
	--local sX, sY = startX, startY
	MOAIDraw.drawLine (
		Launcher.x, Launcher.y,
		worldX, worldY
	)
end

function _L:loadLauncher()
	local newBox = BoxGenerator.new(worldX, worldY, 20)
	self.boxLoaded = newBox
	-- ScoringBox is the box object being scored
	ScoringBox = newBox
	-- HeldBox is the box object under the pointer/finger
	HeldBox = newBox

	newBox.body:setFixedRotation(true)

	MouseBody = FUWorld:addBody(MOAIBox2DBody.STATIC)
	MouseJoint = FUWorld:addMouseJoint(MouseBody, newBox.body, worldX, worldY,  10000.0 * newBox.body:getMass())

	CameraFitter:setDamper(0)

	Launcher:drawLaunchLine()
end

function _L:launchBox()
	CameraAnchor:setParent(self.boxLoaded.point)
	PhysicsHUDLayer:removeProp(self.line)
	self.line = nil
	scriptDeck = nil

	-- also destroys joint
	MouseBody:destroy()
	MouseBody = nil

	self.boxLoaded.body:setActive(true)
	self.boxLoaded.body:setFixedRotation(false)

	self.boxLoaded.body:applyLinearImpulse(5000 * (self.x-worldX), 5000 * (self.y - worldY), worldX, worldY)
	HeldBox = nil
	self.boxLoaded:deactivateWhenResting()
end

function onCollideWithLauncher()
	print("collision with launcher")
end

return _L