local screenX, screenY = 0, 0
local screenCanvas
local shader
local shader_time = 0

function love.load()
    screenX, screenY = love.graphics.getDimensions()
    screenCanvas = love.graphics.newCanvas(screenX, screenY)
    
    shader = love.graphics.newShader([[
      // Gold Noise ©2015 dcerisano@standard3d.com 
      //  - based on the Golden Ratio, PI and Square Root of Two
      //  - superior distribution
      //  - fastest noise generator function
      //  - works with all chipsets (including low precision)
      
      uniform float time;

      float PHI = 1.61803398874989484820459 * 00000.1; // Golden Ratio   
      float PI  = 3.14159265358979323846264 * 00000.1; // PI
      float SQ2 = 1.41421356237309504880169 * 10000.0; // Square Root of Two

      float gold_noise(in vec2 coordinate, in float seed){
        return fract(tan(distance(coordinate*(seed+PHI), vec2(PHI, PI)))*SQ2);
      }

      vec4 effect(vec4 color, Image tex, vec2 uv, vec2 sc)
      {
        return vec4(
          gold_noise(sc, time + PHI),
          gold_noise(sc, time + PI),
          gold_noise(sc, time + SQ2),
          1.0f);
      }
    ]])
end

function love.update(dt)
  shader_time = shader_time + dt
  shader:send("time", shader_time)
end

local function drawPixels()
  love.graphics.setShader(shader)
  love.graphics.rectangle("fill", 0, 0, screenX, screenY)
  love.graphics.setShader()
end

function love.draw()    
  screenCanvas:renderTo(drawPixels)
  
  love.graphics.draw(screenCanvas)
  drawFPS(10, 10)
end

function drawFPS(x, y)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), x + 15, y + 14)
end