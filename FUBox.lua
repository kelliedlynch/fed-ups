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

	box.sprite = sprite
	box.width = size/2
	box.height = size/2
	box.body = body

	box.sprite:setParent(body)
	box.sprite.body = body

	box.damage = 0
	damageCounter:setString(""..box.damage)
	boxForProp[sprite] = box
	boxForFixture[fixture] = box

	return box
end

function _B:updateDamage(box, dmg)
	self.damage = dmg
	if self == activeBox then
		damageCounter:setString(""..self.damage)
	end
end

function _B:deactivateWhenResting()
	self.fixture:setFilter(0x02)
	local thread = MOAICoroutine.new ()
	thread:run(self.__yield, self)
end

function _B:__yield()
	while self:isMoving() do coroutine:yield () end
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
	-- print("boxFixture, obstacle", boxFixture, obstacle)
	velX, velY = boxFixture:getBody():getLinearVelocity()
	totalVelocity = math.floor(math.abs(velX)) + math.floor(math.abs(velY))
	local boxObject = boxForFixture[boxFixture]
	local totalDamage = boxObject.damage + math.floor((totalVelocity / 10) * (boxFixture:getBody():getMass() / 200))
	boxObject:updateDamage(boxObject, totalDamage)
end

return _B