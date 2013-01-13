-- global table to link box objects with physics objects
boxForFixture = {}
--
boxForProp = {}
-- activeBox is the box that is currently being scored (the most recent one acted on by the player)
activeBox = nil

function pointerCallback (x, y)
	worldX, worldY = layer:wndToWorld(x, y)
	if heldBox then
		if heldBox.body then
			heldBox.body:setTransform(worldX, worldY)
		else
			print("x,y", x, y)
			print("worldX, worldY", worldX, worldY)
			x, y = heldBox.sprite:worldToModel(worldX-heldBox.x-heldBox.width, worldY-heldBox.y-heldBox.height)
			heldBox.sprite:addLoc(x, y)
		end
	end
	-- if mouseBody then
	-- 	mouseJoint:setTarget(worldX, worldY)
	-- end

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
	-- see if a sprite has been touched/clicked
	boxClicked = layer:getPartition():propForPoint(worldX, worldY)
	if boxClicked then 

	end
	print("box", box)
	if down then
		--pointerCallback(worldX, worldY)
		if box then


			-- print("picking up box")
			-- -- start displaying damage for this box
			-- damageCounter:setString(""..boxForProp[box].damage)
			
			-- activeBox = boxForProp[box]
			-- heldBox = boxForProp[box]
			-- heldBox.body:setTransform(worldX, worldY)
			-- boxForProp[box].body:setActive(false)
			-- box.body:setFixedRotation(true)
			-- box.body:setLinearVelocity(0,0)
			-- box.body:setAngularVelocity(0)
			-- mouseBody = world:addBody(MOAIBox2DBody.STATIC)
			-- mouseBody:setTransform(worldX, worldY)

			-- mouseJoint = world:addMouseJoint(mouseBody, box.body, worldX, worldY,  10000.0 * box.body:getMass());
		else
			-- note starting position for calculation when launching box
			launch = true
			startX, startY = worldX, worldY

			
			box = FUBox.new(worldX, worldY, 20)

			-- activeBox is the box object being scored
			activeBox = box
			-- heldBox is the box object under the pointer/finger
			heldBox = box

			-- box.body:setFixedRotation(true)


			-- mouseBody = world:addBody(MOAIBox2DBody.STATIC)

			-- mouseJoint = world:addMouseJoint(mouseBody, box.body, worldX, worldY,  10000.0 * box.body:getMass())

			-- scriptDeck = MOAIScriptDeck.new ()
			-- scriptDeck:setRect ( 0,0, screenWidth, screenHeight )
			-- scriptDeck:setDrawCallback ( onDraw )
			-- lineprop = MOAIProp2D.new ()
			-- lineprop:setDeck ( scriptDeck )
			-- HUDLayer:insertProp ( lineprop )
		end
	else  -- mouseup/touchup event
		--heldBox = nil


		-- if layer:getPartition() then print("checking for box"); box = layer:getPartition():propForPoint(worldX, worldY) end
		-- if lineprop then
		-- 	HUDLayer:removeProp(lineprop)
		-- 	lineprop = nil
		-- 	scriptDeck = nil
		-- end
		-- --if mouseBody then
		if heldBox then
			print("heldBox.sprite", heldBox.sprite)
		-- 	print("heldBox exists, releasing box")
		-- 	--also destroys joint
		-- 	-- mouseBody:destroy()
		-- 	-- mouseBody = nil
		-- 	-- print("box on release", box)
		-- 	-- for k,v in pairs(boxForProp) do
		-- 	-- 	print("boxForProp", k,v)
		-- 	-- end
		-- 	-- print("boxObject", boxForProp[box])
			heldBox:releaseBox()
			heldBox = nil
			-- heldBox.body:setActive(true)
			--heldBox = nil
		-- 	local boxObject = boxForProp[box]
		-- 	boxObject.body:setFixedRotation(false)
		-- 	if launch then
		-- 		print("launching box")
		-- 		--distance = math.sqrt((startX-worldX)^2 + (startY-worldY)^2)
				
		-- 		boxObject.body:applyLinearImpulse(5000 * (startX-worldX), 5000 * (startY - worldY), worldX, worldY)
		-- 		launch = false
		-- 	end
		-- 	--box = nil
		-- else

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