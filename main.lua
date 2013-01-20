--------------------------------------------------------------------
-- Global Variables
--------------------------------------------------------------------
ScreenWidth, ScreenHeight = 480, 320

-- layers and partitions
GameplayPartition = nil
GameplayLayer = nil
HUDLayer = nil
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


-- Create the window
local deviceHeight = MOAIEnvironment.horizontalResolution
local deviceWidth = MOAIEnvironment.verticalResolution
if deviceWidth == nil then deviceWidth = 480 end
if deviceHeight == nil then deviceHeight = 320 end
MOAISim.openWindow("Fed-Ups", deviceWidth, deviceHeight)

viewport = MOAIViewport.new()
viewport:setSize(deviceWidth , deviceHeight)
viewport:setScale(480, 320)
--viewport:setOffset ( -1, -1 )

GameplayLayer = MOAILayer.new()
GameplayLayer:setViewport(viewport)
MOAISim.pushRenderPass(GameplayLayer)

HUDLayer = MOAILayer.new ()
HUDLayer:setViewport(viewport)
MOAISim.pushRenderPass(HUDLayer)

-- initialize the camera
Camera = MOAICamera2D.new()
GameplayLayer:setCamera(Camera)
HUDLayer:setCamera(Camera)

CameraFitter = MOAICameraFitter2D.new()
CameraFitter:setViewport(viewport)
CameraFitter:setCamera(Camera)
CameraFitter:setBounds(0, 0, 480, 320)
CameraFitter:setMin(320)
CameraFitter:start()

CameraAnchor = MOAICameraAnchor2D.new()
CameraFitter:insertAnchor(CameraAnchor)
HUDLayer:setParent(CameraAnchor)

font = MOAIFont.new()
font:load('arial-rounded.TTF')

LevelController = require "FULevel"
CurrentLevel = LevelController.loadLevel("world0level1")
