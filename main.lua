--------------------------------------------------------------------
-- Global Variables
--------------------------------------------------------------------
ScreenWidth, ScreenHeight = 480, 320

-- layers and partitions
GameplayPartition = nil
GameplayLayer = nil
HUDLayer = nil
PhysicsHUDLayer = nil
-- camera
Camera = nil
CameraAnchor = nil
CameraFitter = nil
-- global touch handler
TouchDispatcher = nil

--
-- Gameplay elements
--
MouseBody = nil
MouseJoint = nil
-- terrain
TerrainBody = nil
Launcher = nil
-- global tables to assist with looking up boxes
BoxForFixture = {}
BoxForProp = {}
-- ScoringBox is the box currently being scored (most recent one acted on by player)
ScoringBox = nil
-- HeldBox is the box currently being dragged around by the pointer
HeldBox = nil

--------------------------------------------------------------------
-- FILTER REFERENCE
-- 
FILTER_ACTIVE_BOX = 0x01
FILTER_ACTIVE_TERRAIN = 0x02
FILTER_INACTIVE_BOX = 0x04
FILTER_INACTIVE_TERRAIN = 0x08
FILTER_GOAL = 0x16

GROUP_ACTIVE_BOX = 1
GROUP_ACTIVE_TERRAIN = 2
GROUP_ACTIVE_TERRAIN = -1
GROUP_INACTIVE_TERRAIN = -2
--------------------------------------------------------------------


-- Create the window
local deviceHeight = MOAIEnvironment.horizontalResolution
local deviceWidth = MOAIEnvironment.verticalResolution
if deviceWidth == nil then deviceWidth = 480 end
if deviceHeight == nil then deviceHeight = 320 end
MOAISim.openWindow("Fed-Ups", deviceWidth, deviceHeight)

viewport = MOAIViewport.new()
viewport:setSize(deviceWidth, deviceHeight)
viewport:setScale(480, 320)
--viewport:setOffset ( -1, -1 )\
viewport2 = MOAIViewport.new()
viewport2:setSize(deviceWidth, deviceHeight)
viewport2:setScale(480, 320)
viewport2:setOffset(-1, -1)

GameplayLayer = MOAILayer.new()
GameplayLayer:setViewport(viewport)
MOAISim.pushRenderPass(GameplayLayer)

-- HUD Layer for anything NOT interacting with a physics object
HUDLayer = MOAILayer.new()
HUDLayer:setViewport(viewport2)
MOAISim.pushRenderPass(HUDLayer)

-- HUD Layer for anything interacting with a physics object
PhysicsHUDLayer = MOAILayer.new()
PhysicsHUDLayer:setViewport(viewport)
MOAISim.pushRenderPass(PhysicsHUDLayer)

-- initialize the camera
Camera = MOAICamera2D.new()
GameplayLayer:setCamera(Camera)
PhysicsHUDLayer:setCamera(Camera)

CameraFitter = MOAICameraFitter2D.new()
CameraFitter:setViewport(viewport)
CameraFitter:setCamera(Camera)
CameraFitter:setBounds(0, 0, 480, 320)
CameraFitter:setMin(320)
CameraFitter:start()

CameraAnchor = MOAICameraAnchor2D.new()
CameraFitter:insertAnchor(CameraAnchor)

font = MOAIFont.new()
font:load('arial-rounded.TTF')

LevelController = require "FULevel"
CurrentLevel = LevelController.loadLevel("world0level1")
