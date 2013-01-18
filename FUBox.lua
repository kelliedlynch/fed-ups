_B = {}

_B.__index = _B

function _B.new(x,y,size)
	local box = {}
	setmetatable(box, _B)

	box.x = x - size/2
	box.y = y - size/2

	local body = world:addBody(MOAIBox2DBody.DYNAMIC)

	poly = {
		box.x, box.y,
		box.x+size, box.y,
		box.x+size, box.y+size,
		box.x, box.y+size,
	}

	local fixture = body:addPolygon (poly)
	fixture:setDensity(1)
	fixture:setFriction(.8)
	fixture:setFilter (0x01, 0x01)
	fixture:setRestitution(.2)
	fixture:setFilter(0x01)
	fixture:setCollisionHandler (onBoxCollision, MOAIBox2DArbiter.ALL, 0x01, 0x01)

	body:resetMassData()

	boxForFixture[fixture] = self
	box.fixture = fixture

	local texture = MOAIGfxQuad2D.new()
	texture:setTexture('Resources/Textures/brown-4x4.png')
	texture:setRect(box.x, box.y, box.x + size, box.y + size)
	local sprite = MOAIProp2D.new()
	sprite:setDeck(texture)
	layer:insertProp(sprite)
	--sprite:setLoc(0,0)

	box.sprite = sprite
	box.width = size
	box.height = size
	box.body = body

	box.sprite:setParent(body)
	box.sprite.body = body

	box.damage = 0
	damageCounter:setString(""..box.damage)
	boxForProp[sprite] = box
	boxForFixture[fixture] = box

	--FUEventDispatcher.setEventListener("followBox", box)
	--box.displayDamageMeter(box)
	-- print("getLoc", sprite:getLoc())
	-- print("modelToWorld", sprite:modelToWorld(sprite:getLoc()))
	-- print("worldToModel", sprite:worldToModel(sprite:getLoc()))
	-- print("worldToWnd", layer:worldToWnd(sprite:getLoc()))
	return box
end

function _B:__checkPos()
	local x, y = 0,0
	print("screenWidth", screenWidth)
	while x < (screenWidth/2 - self.width/2) do
		x, y = layer:worldToWnd(self.sprite:modelToWorld(0,0))
		print("x,y", x, y)

		-- print("getLoc", self.sprite:getLoc())

		-- print("modelToWorld", self.sprite:modelToWorld(0,0)) --coords from bottom of screen
		-- print("worldToWnd", layer:worldToWnd(self.sprite:modelToWorld(0,0))) --coords from top of screen
		-- print("x",x)
		-- print("screenWidth, self.width", screenWidth, self.width)
		-- print("math", (screenWidth/2 - self.width/2))
		coroutine:yield()
	end
	print("broke out of coroutine")
	print("x,y", x, y)
	print("rect", x-screenWidth/2, 0, x+screenWidth/2, screenHeight)
	--screenAnchor:setRect(x-screenWidth/2, 0, x+screenWidth/2, screenHeight)
	screenAnchor:setParent(self.sprite)
end

function _B:displayDamageMeter()
	local damageMeter = MOAITextBox.new()
	damageMeter:setFont ( font )
	damageMeter:setTextSize(14)
	damageMeter:setString(""..self.damage)
	--local x,y = layer:worldToWnd(self.sprite:worldToModel(self.sprite:getLoc()))
	local x,y = layer:worldToWnd(self.sprite:modelToWorld(0,0))
	damageMeter:setRect ( x,y, 200, 40 )
	damageMeter:setAlignment ( MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )
	damageMeter:setParent(self.sprite)
	damageMeter:setYFlip(true)
	layer:insertProp(damageMeter)
end

function _B:updateDamage(box, dmg)
	-- print("damaging box, damage", box, dmg)
	-- print("total damage on box", box.damage)
	self.damage = self.damage + dmg
	if self == activeBox then
		damageCounter:setString(""..self.damage)
	end
end

function _B:deactivateWhenResting()
	self.fixture:setFilter(0x02)
	local thread = MOAICoroutine.new()
	thread:run(self.__yield, self)
end

function _B:__yield()
	while self:isMoving() do coroutine:yield() end
	self.body:destroy()
end

function _B:isMoving()
	if self.body:getLinearVelocity() ~= 0 and self.body:getAngularVelocity() ~= 0 then
		return true
	end
	return false
end

function onBoxCollision(event, boxFixture, obstacle)
	if event == MOAIBox2DArbiter.BEGIN then beginBoxCollision(boxFixture, obstacle) end
	if event == MOAIBox2DArbiter.END then  end
	if event == MOAIBox2DArbiter.PRE_SOLVE then  end
	if event == MOAIBox2DArbiter.POST_SOLVE then  end
end

function beginBoxCollision(boxFixture, obstacle)
	print("boxFixture, obstacle", boxFixture, obstacle)
	bvelX, bvelY = boxFixture:getBody():getLinearVelocity()
	boxVelocity = math.floor(math.abs(bvelX)) + math.floor(math.abs(bvelY))
	ovelX, ovelY = obstacle:getBody():getLinearVelocity()
	obstacleVelocity = math.floor(math.abs(ovelX)) + math.floor(math.abs(ovelY))
	totalVelocity = boxVelocity + obstacleVelocity
	local boxObject = boxForFixture[boxFixture]
	local totalDamage = math.floor((totalVelocity / 10) * (boxFixture:getBody():getMass() / 200)) 
	boxObject:updateDamage(boxObject, totalDamage)
end

function followBox(box)

end

return _B