-- global table to link box objects with physics objects
boxForFixture = {}
-- global table to link box objects with their sprites
boxForProp = {}
-- activeBox is the box that is currently being scored (the most recent one acted on by the player)
activeBox = nil
-- heldBox is the box currently being dragged around by the pointer
heldBox = nil

function pointerCallback (x, y)
	worldX, worldY = layer:wndToWorld(x, y)
	-- if heldBox then
	-- 	if heldBox.body then
	-- 		heldBox.body:setTransform(worldX, worldY)
	-- 	else
	-- 		print("x,y", x, y)
	-- 		print("worldX, worldY", worldX, worldY)
	-- 		x, y = heldBox.sprite:worldToModel(worldX-heldBox.x-heldBox.width, worldY-heldBox.y-heldBox.height)
	-- 		heldBox.sprite:addLoc(x, y)
	-- 	end
	-- end
	if mouseBody then
		print("mouseBody")
		mouseJoint:setTarget(worldX, worldY)
	end

end

function onDraw ( index, xOff, yOff, xFlip, yFlip )
	MOAIGfxDevice.setPenColor ( 1, 1, 1, 1 )
	MOAIGfxDevice.setPenWidth ( 2 )
	MOAIDraw.drawLine (
		startX, startY,
		worldX, worldY
	)
end

function clickCallback(down)
	--local launch
	-- see if a sprite has been touched/clicked
	local boxClicked = layer:getPartition():propForPoint(worldX, worldY)
	if boxClicked then 

	end
	print("box", boxClicked)
	if down then
		--pointerCallback(worldX, worldY)
		if boxClicked then


			print("picking up box", boxClicked)
			heldBox = boxClicked
			-- start displaying damage for this box
			damageCounter:setString(""..boxForProp[boxClicked].damage)
			
			activeBox = boxForProp[boxClicked]
			heldBox = boxForProp[boxClicked]
			--heldBox.body:setTransform(worldX, worldY)
			--boxForProp[boxClicked].body:setActive(false)
			boxClicked.body:setFixedRotation(true)
			boxClicked.body:setLinearVelocity(0,0)
			boxClicked.body:setAngularVelocity(0)
			mouseBody = world:addBody(MOAIBox2DBody.STATIC)
			mouseBody:setTransform(worldX, worldY)

			mouseJoint = world:addMouseJoint(mouseBody, boxClicked.body, worldX, worldY,  10000.0 * boxClicked.body:getMass());
		else
			-- note starting position for calculation when launching box
			launch = true
			startX, startY = worldX, worldY

			
			local newBox = FUBox.new(worldX, worldY, 20)

			-- activeBox is the box object being scored
			activeBox = newBox
			-- heldBox is the box object under the pointer/finger
			heldBox = newBox

			newBox.body:setFixedRotation(true)


			mouseBody = world:addBody(MOAIBox2DBody.STATIC)
			mouseJoint = world:addMouseJoint(mouseBody, newBox.body, worldX, worldY,  10000.0 * newBox.body:getMass())

			local scriptDeck = MOAIScriptDeck.new ()
			scriptDeck:setRect ( 0,0, screenWidth, screenHeight )
			scriptDeck:setDrawCallback ( onDraw )
			launchLine = MOAIProp2D.new ()
			launchLine:setDeck ( scriptDeck )
			HUDLayer:insertProp ( launchLine )
		end
	else  -- mouseup/touchup event
		if layer:getPartition() then 
			print("checking for box") 
			boxObject = layer:getPartition():propForPoint(worldX, worldY) 
		end
		if launchLine then
			HUDLayer:removeProp(launchLine)
			launchLine = nil
			scriptDeck = nil
		end
		if heldBox then
			-- also destroys joint
			mouseBody:destroy()
			mouseBody = nil

			heldBox.body:setActive(true)
			heldBox.body:setFixedRotation(false)
			if launch then
				heldBox.body:applyLinearImpulse(5000 * (startX-worldX), 5000 * (startY - worldY), worldX, worldY)
				launch = false
			end
			heldBox = nil
		end
	end
end

if MOAIInputMgr.device.pointer then
    MOAIInputMgr.device.mouseLeft:setCallback(
        function(isMouseDown)
            if(isMouseDown) then
                clickCallback(true)
            else
            	clickCallback()
            end
        end
    )
    MOAIInputMgr.device.pointer:setCallback(pointerCallback)
else
-- If it isn't a mouse, its a touch screen... or some really weird device.
    MOAIInputMgr.device.touch:setCallback (
        function(eventType, idx, x, y, tapCount)
        	pointerCallback(x,y)
			if eventType == MOAITouchSensor.TOUCH_DOWN then
                clickCallback(true)
            elseif eventType == MOAITouchSensor.TOUCH_UP then
				clickCallback()
            end
        end
    )
end

--MOAIInputMgr.device.pointer:setCallback ( pointerCallback )
--MOAIInputMgr.device.mouseLeft:setCallback ( clickCallback )