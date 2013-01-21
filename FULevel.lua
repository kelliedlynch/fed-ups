--------------------------------------------------------------------
-- Main Gameplay Display and Engine
--------------------------------------------------------------------

_L = {}

function _L.loadLevel(levelID)
	-- set up the world and start its simulation
	FUWorld = MOAIBox2DWorld.new()
	FUWorld:setGravity(0, -10)
	FUWorld:setUnitsToMeters(1/50)
	FUWorld:start()
	GameplayLayer:setBox2DWorld(FUWorld)

	GameplayPartition = MOAIPartition.new()
	GameplayLayer:setPartition(GameplayPartition)

	BoxGenerator = require "FUBox"

	if levelID then
		require("Levels/"..levelID)
	else
		require "world0level0"
	end

	-- damage counter
	local text = "0"

	DamageMeter = MOAITextBox.new()
	DamageMeter:setFont(font)
	DamageMeter:setTextSize(24)
	DamageMeter:setString(text)
	DamageMeter:setRect(0,0, 200, 40)
	DamageMeter:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
	DamageMeter:setYFlip(true)
	HUDLayer:insertProp(DamageMeter)
	--DamageMeter:setParent(HUDLayer)
	--HUDLayer:setParent(CameraAnchor)

	TouchDispatcher = require "FUTouchDispatcher"
	TouchDispatcher.beginListeningForTouches()
end

function _L:turnOver()
	CameraFitter:setDamper(.8)
	CameraAnchor:setParent(Launcher.body)
end

return _L