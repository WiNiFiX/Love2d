blockSize = 4

function love.update(dt)    
end

function love.draw()    
    for x = 0, love.graphics.getWidth() / blockSize do        
        for y = 0, love.graphics.getHeight() / blockSize do        
            fillRectangle(x * blockSize, y * blockSize)
        end
    end    
    drawFPS(10, 10)
end

function fillRectangle(x, y, color)
    setRandomColor()
    love.graphics.rectangle("fill", x, y, blockSize, blockSize)    
end

function fillRectangleX(x, y, width, height)            
    love.graphics.rectangle("fill", x, y, width, height)    
end

function drawFPS(x, y)
    love.graphics.setColor(0.5, 0.5, 0.8)
    fillRectangleX(x, y, 80, 40)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), x + 15, y + 14)
end

function setRandomColor()
    r = math.random(0, 255)            
    g = math.random(0, 255)    
    b = math.random(0, 255)    
    love.graphics.setColor(r / 255, g / 255, b / 255)    
end
    

