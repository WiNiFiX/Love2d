x = 10
y = 10
blockSize = 20

function love.update(dt)    
end

function love.draw()    
    fillRectangle(x * blockSize, y * blockSize)    
    drawFPS(10, 10)
end

function fillRectangle(x, y, width, height)    
    if (width == nil) then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", x, y, blockSize, blockSize)    
    else
        love.graphics.rectangle("fill", x, y, width, height)    
    end
end

function drawFPS(x, y)
    love.graphics.setColor(0.5, 0.5, 0.9, 1)
    fillRectangle(x, y, 80, 40)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), x + 15, y + 14)
end
    

