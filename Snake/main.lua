require "bloom"

local direction = 'right'
local blockSize = 20
local speed = 100 -- ms
local currentDirection = 'right'
local snakeLength = 5
local foodCount = 1

function love.load()      
  screenWidth, screenHeight = love.graphics.getDimensions()    
  bloom = CreateBloomEffect( screenWidth / 2, screenHeight / 2 )
  bloom:debugDraw(true)
  if bloom then print('Bloom effect returned true') end
  snake = {}  
  for i = 0, snakeLength do
    local calcX = math.floor(screenWidth / 2 / blockSize)
    local calcY = math.floor(screenHeight / 2 / blockSize)    
    
    table.insert(snake, {x = (calcX - i) * blockSize, y = calcY * blockSize })            
  end

  -- Initialize food table with blanks
  food = {}  
  for i = 1, foodCount do    
    table.insert(food, {x = 0, y = 0, respawn=true })            
  end    

  spawnNewFood()
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
    local count = 0
    for i, v in pairs(snake) do
      if (count == 0) then -- we generate a new header of the snake, segments behind will follow naturally
        local newX, newY = v.x, v.y
        if currentDirection == 'right' then
          newX = newX + blockSize          
          if newX / blockSize == screenWidth / blockSize then newX = 0 end
        elseif currentDirection == 'left' then          
          if newX == 0 and currentDirection == 'left' then 
            newX = screenWidth - blockSize 
          else
            newX = newX - blockSize 
          end         
        elseif currentDirection == 'up' then
          if newY == 0 then 
            newY = screenHeight - blockSize 
          else
            newY = newY - blockSize 
          end          
        elseif currentDirection == 'down' then
          newY = newY + blockSize          
          if newY / blockSize == screenHeight / blockSize then newY = 0 end
        end
        
        table.insert(snake, 1, {x = newX, y = newY})                    
      end
      count = count + 1               
    end
    if count > snakeLength then        
      table.remove(snake, count)
    end
    tick = 0
  end
end

function love.draw()    
  bloom:predraw()
  bloom:enabledrawtobloom()  

  drawGrid()
  drawSnake()  
  isFoodEaten()
  drawFood()  
  drawFPS(15, 15)

  bloom:postdraw()
end

function spawnNewFood()    
    -- place the food in a random location on screen     
    
    for i, v in pairs(food) do      
      if v.respawn == true then        
        local calcX = (math.floor(math.random(0, screenWidth) / blockSize) - 1) * blockSize
        local calcY = math.floor(math.random(0, screenHeight) / blockSize) * blockSize
        
        -- while it is on a snake body part, spawn again
        while isFoodOnSnake(calcX, calcY) do
          calcX = (math.floor(math.random(0, screenWidth) / blockSize) - 1) * blockSize
          calcY = math.floor(math.random(0, screenHeight) / blockSize) * blockSize
        end
        v.x = calcX
        v.y = calcY
        v.respawn = false
      end
    end    
end

function isFoodEaten()
  for i, v in pairs(food) do
    if snake[1].x == v.x and snake[1].y == v.y then      
      snakeLength = snakeLength + 1
      v.respawn = true
      spawnNewFood()
    end
  end
end

function isFoodOnSnake(calcX, calcY)
  for i, v in pairs(snake) do
    if calcX == v.x and calcY == v.y then
      print('Food on snake, spawning again...')      
      return true
    end
  end
  return false
end

function drawSnake()
  
  for i, v in pairs(snake) do
    local red = 1
    local green = 0.1 * i % 1
    local blue = 0.1 * i % 1
    local alpha = 1 / i * (snakeLength - 2)

    love.graphics.setColor(red, green, blue, alpha)
    love.graphics.rectangle("fill", v.x, v.y, blockSize - 1, blockSize - 1)

    -- this adds a semi glowy effect around the snake
    love.graphics.setColor(0, 0, 1, 0.3)
    love.graphics.rectangle("fill", v.x - 2, v.y - 2, blockSize + 4, blockSize + 4)

    love.graphics.setColor(1, 1, 1, 0.1)
    love.graphics.rectangle("fill", v.x - 3, v.y - 3, blockSize + 6, blockSize + 6)
  end  
end

function drawFood()
  for i, v in pairs(food) do
    if v.respawn == false then -- we must only draw food if it is not "eaten" aka marked to respawn      
      love.graphics.setColor(1, 1, 0, 1)
      love.graphics.rectangle("fill", v.x, v.y, blockSize - 1, blockSize - 1)

      -- this adds a semi glowy effect around the food
      love.graphics.setColor(0, 0, 1, 0.3)
      love.graphics.rectangle("fill", v.x - 2, v.y - 2, blockSize + 4, blockSize + 4)

      love.graphics.setColor(1, 1, 1, 0.1)
      love.graphics.rectangle("fill", v.x - 3, v.y - 3, blockSize + 6, blockSize + 6)
    end
  end
end

function drawGrid()
  love.graphics.setColor(0.5, 0.5, 0.5, 0.4)
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

-- SUGGESTIONS
-- 1. Because there is no death by colision like in the original game, you could change the challenge from dexterity to efficiency. 
--    By that, I mean that instead of dying by touching yourself or the borders, you could simply add a short timer to reach the next fruit
