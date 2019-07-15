local direction = 'right'
local blockSize = 40
local speed = 200 -- ms
local currentDirection = 'right'

function love.load()      
  screenWidth, screenHeight = love.graphics.getDimensions()    
  snake = {}
  for i = 0, 4 do
    local calcX = math.floor(screenWidth / 2 / blockSize)
    local calcY = math.floor(screenHeight / 2 / blockSize)    
    
    table.insert(snake, {x = (calcX - i) * blockSize, y = calcY * blockSize, position = i, parentDirection = 'right' })            
  end
  loaded = true
end

local tick = 0;

function love.update(dt)  
  if (love.keyboard.isDown('right') and currentDirection ~= 'left') then
    currentDirection = 'right'
  elseif (love.keyboard.isDown('left') and currentDirection ~= 'right') then
    currentDirection = 'left'
  elseif (love.keyboard.isDown('up') and currentDirection ~= 'down') then
    currentDirection = 'up'
  elseif (love.keyboard.isDown('down') and currentDirection ~= 'up') then
    currentDirection = 'down'
  end

  tick = tick + dt * 1000
  if tick >= speed then
    for i, v in pairs(snake) do
      if (v.position == 0) then -- we move the header of the snake, segments behind must follow     
        if currentDirection == 'right' then
          v.x = v.x + blockSize
        elseif currentDirection == 'left' then
          v.x = v.x - blockSize
        elseif currentDirection == 'up' then
          v.y = v.y - blockSize
        elseif currentDirection == 'down' then
          v.y = v.y + blockSize          
        end  
      end
    end
    tick = 0
  end
end

function love.draw()    
  drawGrid()
  drawSnake()  
  --drawFPS(15, 15)
end

function drawSnake()
  for i, v in pairs(snake) do
    love.graphics.setColor(1, 0.1, 0.2, 1)
    love.graphics.rectangle("fill", v.x, v.y, blockSize, blockSize)
  end
end

function drawGrid()
  love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
  for x = 0, screenWidth / blockSize do    
    love.graphics.line(x * blockSize, 0, x * blockSize, screenHeight)
  end
  for y = 0, screenHeight / blockSize do
    love.graphics.line(0, y * blockSize, screenWidth, y * blockSize)
  end
end

function drawFPS(x, y)
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS()), x, y)  
end

