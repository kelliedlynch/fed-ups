_B = {}

_B.__index = _B

function _B.new(x,y,size)
	local box = {}
	setmetatable(box, _B)

	box.x = x - size/2
	box.y = y - size/2

	local texture = MOAIGfxQuad2D.new()
	texture:setTexture('Resources/Textures/brown-4x4.png')
	texture:setRect(box.x, box.y, box.x + size, box.y + size)
	local sprite = MOAIProp2D.new()
	--sprite:setLoc(0,0)
	sprite:setDeck(texture)
	--sprite:setParent(body)
	layer:insertProp(sprite)

	box.sprite = sprite
	box.width = size/2
	box.height = size/2

	box.damage = 0
	damageCounter:setString(""..box.damage)
	boxForProp[sprite] = box

	return box
end

function _B:releaseBox ()
	local body = world:addBody(MOAIBox2DBody.DYNAMIC)
	--body:setAwake(false)
	print("self.sprite", self.sprite)
	print("self.sprite:getDims", self.sprite:getDims())
	print("self.sprite:getLoc", self.sprite:getLoc())
	print("worldToModel", self.sprite:worldToModel(self.sprite:getLoc()))
	print("modelToWorld", self.sprite:modelToWorld(self.x, self.y))
	print("wndToWorld", layer:wndToWorld(self.sprite:getLoc()))
	print("worldToWnd", layer:worldToWnd(self.sprite:getLoc()))
	--x, y = self.sprite:getLoc()
	local x, y = worldX, worldY
	--local x,y = self.x, self.y

	poly = {
		x,y,
		x+self.width,y,
		x+self.width,y+self.height,
		x,y+self.height,
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
	self.sprite.body = body
	self.body = body
	self.fixture = fixture
	self.sprite:setParent(body)

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
	velX, velY = boxFixture:getBody():getLinearVelocity()
	totalVelocity = math.floor(math.abs(velX)) + math.floor(math.abs(velY))
	box = boxForFixture[boxFixture]
	local totalDamage = box.damage + math.floor((totalVelocity / 10) * (boxFixture:getBody():getMass() / 200))
	box:updateDamage(box, totalDamage)
end

return _B