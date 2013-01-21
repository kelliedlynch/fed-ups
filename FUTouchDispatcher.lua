_D = {}

function _D.pointerCallback (x, y)
	worldX, worldY = GameplayLayer:wndToWorld(x, y)
	if MouseBody then
		MouseJoint:setTarget(worldX, worldY)
	end
end

function _D.clickCallback(down)
	-- Is a sprite under the pointer?
	local spriteTouched = GameplayPartition:propForPoint(worldX, worldY)

	if down then
		if BoxForProp[spriteTouched] then
			print("test")
			HeldBox = BoxForProp[spriteTouched]
			ScoringBox = HeldBox
			-- start displaying damage for this box
			HeldBox:updateDamage()
			
			--HeldBox = boxForProp[spriteTouched]

			spriteTouched.body:setFixedRotation(true)
			spriteTouched.body:setLinearVelocity(0,0)
			spriteTouched.body:setAngularVelocity(0)
			MouseBody = FUWorld:addBody(MOAIBox2DBody.STATIC)
			MouseBody:setTransform(worldX, worldY)

			MouseJoint = FUWorld:addMouseJoint(MouseBody, spriteTouched.body, worldX, worldY,  10000.0 * spriteTouched.body:getMass());
		else
			Launcher:loadLauncher()
		end
	else  -- mouseup/touchup event
		if Launcher.boxLoaded then
			Launcher:launchBox(HeldBox)
		elseif HeldBox then
			HeldBox:releaseBox()
		end
	end
end

function _D.beginListeningForTouches()
	if MOAIInputMgr.device.pointer then
	    MOAIInputMgr.device.mouseLeft:setCallback(
	        function(isMouseDown)
	            if(isMouseDown) then
	                _D.clickCallback(true)
	            else
	            	_D.clickCallback()
	            end
	        end
	    )
	    MOAIInputMgr.device.pointer:setCallback(_D.pointerCallback)
	else
	-- If it isn't a mouse, its a touch screen... or some really weird device.
	    MOAIInputMgr.device.touch:setCallback (
	        function(eventType, idx, x, y, tapCount)
	        	_D.pointerCallback(x,y)
				if eventType == MOAITouchSensor.TOUCH_DOWN then
	                _D.clickCallback(true)
	            elseif eventType == MOAITouchSensor.TOUCH_UP then
					_D.clickCallback()
	            end
	        end
	    )
	end
end

return _D