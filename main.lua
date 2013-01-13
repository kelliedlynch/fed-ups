-- Create the window
local deviceHeight = MOAIEnvironment.horizontalResolution
local deviceWidth = MOAIEnvironment.verticalResolution
if deviceWidth == nil then deviceWidth = 480 end
if deviceHeight == nil then deviceHeight = 320 end
MOAISim.openWindow ( "Fed-Ups", deviceWidth, deviceHeight )

viewport = MOAIViewport.new ()
viewport:setSize ( deviceWidth , deviceHeight )
screenWidth, screenHeight = 480, 320
viewport:setScale ( 480, 320 )
viewport:setOffset ( -1, -1 )

layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
MOAISim.pushRenderPass ( layer )

HUDLayer = MOAILayer2D.new ()
HUDLayer:setViewport ( viewport )
MOAISim.pushRenderPass ( HUDLayer )

-- set up the world and start its simulation
world = MOAIBox2DWorld.new ()
world:setGravity(0, -10)
world:setUnitsToMeters(1/50)
world:start()
layer:setBox2DWorld(world)
--world:setDebugDrawEnabled(true)
--world:setDebugDrawFlags(MOAIBox2DWorld.DEBUG_DRAW_JOINTS, MOAIBox2DWorld.DEBUG_DRAW_BOUNDS, MOAIBox2DWorld.DEBUG_DRAW_PAIRS, MOAIBox2DWorld.DEBUG_DRAW_CENTERS)

partition = MOAIPartition.new()
layer:setPartition(partition)

FUBox = require "FUBox"
--brownBox = FUBox.new(100,200,50)

staticBody = world:addBody ( MOAIBox2DBody.STATIC )
require "FUTerrain"
generateRandomSurface()

-- damage counter
text = "0"

font = MOAIFont.new ()
font:load ( 'arial-rounded.TTF' )

damageCounter = MOAITextBox.new ()
damageCounter:setFont ( font )
damageCounter:setTextSize ( 24 )
damageCounter:setString ( text )
damageCounter:spool ()
damageCounter:setRect ( 0,0, 200, 40 )
damageCounter:setAlignment ( MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )
damageCounter:setYFlip(true)
layer:insertProp ( damageCounter )
--fixture2 = staticBody:addRect ( 10, 10, 460, 40 )
--fixture2:setFilter ( 0x02 )
--fixture2:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x00 )

require "FUDispatch"
