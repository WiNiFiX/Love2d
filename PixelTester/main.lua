local screenX, screenY = 0, 0
local screenImgData, screenTex
function love.load()
    screenX, screenY = love.graphics.getDimensions()
    screenImgData = love.image.newImageData(screenX, screenY, "rgba8")
    screenTex = love.graphics.newImage(screenImgData)
end

local function getRandomColor()
    r = math.random(0, 255)            
    g = math.random(0, 255)    
    b = math.random(0, 255)    
    return r / 255, g / 255, b / 255, 1.0

end

local function fillTexture(x, y, r, g, b, a)
    return getRandomColor()
end
function love.update(dt)
    screenImgData:mapPixel(fillTexture)
    screenTex:replacePixels(screenImgData)
end
function love.draw()    
    love.graphics.draw(screenTex)
    drawFPS(10, 10)
end

function drawFPS(x, y)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), x + 15, y + 14)
end