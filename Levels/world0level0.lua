CameraFitter:setBounds(0, 0, 1000, 320)

TerrainBody = FUWorld:addBody(MOAIBox2DBody.STATIC)
TerrainGenerator = require "FUTerrain"
TerrainGenerator.generateRandomSurface()