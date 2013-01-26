_B = {}

_B.__index = _B

function _B.new(x,y,size)
	local box = {}
	setmetatable(box, _B)

	box.x = x - size/2
	box.y = y - size/2

	local body = FUWorld:addBody(MOAIBox2DBody.DYNAMIC)

	poly = {
		box.x, box.y,
		box.x+size, box.y,
		box.x+size, box.y+size,
		box.x, box.y+size,
	}

	local fixture = body:addPolygon(poly)
	-- local fixture = body:addCircle(x, y, size/2)
	fixture:setDensity(1)
	fixture:setFriction(.8)
	fixture:setFilter(FILTER_ACTIVE_BOX, FILTER_ACTIVE_TERRAIN, GROUP_PRIMARY_OBJECTS)
	fixture:setRestitution(.2)
	fixture:setCollisionHandler(onBoxCollision, MOAIBox2DArbiter.ALL, FILTER_ACTIVE_TERRAIN)
	--fixture:setCollisionHandler(onCollideWithGoal, MOAIBox2DArbiter.ALL, FILTER_GOAL)

	BoxForFixture[fixture] = box
	box.fixture = fixture

	local texture = MOAIGfxQuad2D.new()
	texture:setTexture('Resources/Textures/brown-4x4.png')
	texture:setRect(box.x, box.y, box.x + size, box.y + size)
	local sprite = MOAIProp2D.new()
	sprite:setDeck(texture)
	GameplayLayer:insertProp(sprite)

	box.sprite = sprite
	box.width = size
	box.height = size
	box.body = body

	box.sprite:setParent(body)
	box.sprite.body = body

	box.damage = 0
	DamageMeter:setString(""..box.damage)
	BoxForProp[sprite] = box
	body:setAngularDamping(.9)
	body:resetMassData()


	local point = FUWorld:addBody(MOAIBox2DBody.DYNAMIC)
	point:setMassData(0)
	point:setFixedRotation(true)
	point:setTransform(box.x, box.y)
	--print("x,y", box.x, box.y)
	--local point_fix = point:addCircle(box.x + (box.width / 2), box.y + (box.height / 2), 10)
	local point_fix = point:addCircle(0, 0, 0.1)
	point_fix:setSensor(true)
	point:setFixedRotation(true)
	local joint = FUWorld:addRevoluteJoint(point, box.body, box.body:getWorldCenter())
	point:resetMassData()
	box.point = point

	box:displayDamageMeter(box)

	return box
end

function _B:displayDamageMeter()
	local damageMeter = MOAITextBox.new()
	damageMeter:setFont(font)
	damageMeter:setTextSize(10)
	damageMeter:setString(""..self.damage)
	damageMeter:setRect(-10, 0, 30, 15)
	damageMeter:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
	--local joint = FUWorld:addRevoluteJoint(self.point, self.body, self.body:getWorldCenter())
	damageMeter:setParent(self.point)

	damageMeter:setYFlip(true)
	PhysicsHUDLayer:insertProp(damageMeter)
	self.damageMeter = damageMeter
	print("meter location", damageMeter:getLoc())
	--HUDLayer:setParent(CameraAnchor)
end

function _B:updateDamage(box, dmg)
	self.damage = self.damage + (dmg or 0)
 	if self == ScoringBox then
		DamageMeter:setString(""..self.damage)
	end
	self.damageMeter:setString(""..self.damage)
end

function _B:deactivateWhenResting()
	print("deactivating")
	local thread = MOAICoroutine.new()
	thread:run(self.__yield, self)
end

function _B:__yield()
	while self:isMoving() do coroutine:yield() end
	print("destroying physics object")
	self.body:destroy()
	--self.body = nil
	BoxForProp[self.sprite] = nil
	BoxForFixture[self.fixture] = nil
	self.point:destroy()
	LevelController:turnOver()
end

function _B:isMoving()
	if self.body:getLinearVelocity() == 0 and self.body:getAngularVelocity() == 0 then
		--self.body = nil
		return false
	end
	return true
end

function onBoxCollision(event, boxFixture, obstacle)
	if event == MOAIBox2DArbiter.BEGIN then beginBoxCollision(boxFixture, obstacle) end
	if event == MOAIBox2DArbiter.END then  end
	if event == MOAIBox2DArbiter.PRE_SOLVE then  end
	if event == MOAIBox2DArbiter.POST_SOLVE then  end
end

function beginBoxCollision(boxFixture, obstacle)
	bvelX, bvelY = boxFixture:getBody():getLinearVelocity()
	boxVelocity = math.floor(math.abs(bvelX)) + math.floor(math.abs(bvelY))
	ovelX, ovelY = obstacle:getBody():getLinearVelocity()
	obstacleVelocity = math.floor(math.abs(ovelX)) + math.floor(math.abs(ovelY))
	totalVelocity = boxVelocity + obstacleVelocity
	local boxObject = BoxForFixture[boxFixture]
	local totalDamage = math.floor((totalVelocity / 10) * (boxFixture:getBody():getMass() / 200)) 
	boxObject:updateDamage(boxObject, totalDamage)
end

function _B:releaseBox()
	--------------------------------------------------------------------
	-- Releases a box without launching it, applying normal physics
	--------------------------------------------------------------------
	MouseBody:destroy()
	MouseBody = nil

	self.body:setActive(true)
	self.body:setFixedRotation(false)
end

return _B