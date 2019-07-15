local maxStars = 1000
local starSpeed = 400
local moveSpeed = 200
local maxRadius = 50
local screenX = 0
local screenY = 0
local playerX = 0
local playerY = 0
local playerDestX = 0
local playerDestY = 0
local lastClickX = 0
local lastClickY = 0
local screenCanvas

function love.load()
    screenX, screenY = love.graphics.getDimensions()  
    playerX = screenX/2
    playerY = screenY/2
    playerDestX = playerX
    playerDestY = playerY
    lastClickX = playerX
    lastClickY = playerY
    stars = {}
end

function love.update(dt) 
  if math.floor(playerX) ~= math.floor(lastClickX) and math.floor(playerY) ~= math.floor(lastClickY) then
    playerX = playerX + (playerDestX * dt)
    playerY = playerY + (playerDestY * dt)    
  end

  spawnStars()
  for i,v in ipairs(stars) do                    
      local angle = math.random(0, 360) 
      local starDx = starSpeed * math.cos(angle)
      local starDy = starSpeed * math.sin(angle)
      v.x = v.x + (starDx * dt)
      v.y = v.y + (starDy * dt)      
      if (distance(v.x, v.y, playerX, playerY) > math.random(maxRadius - 20, maxRadius + 20)) then      
        table.remove(stars, i)
      end    
	end
end

function love.draw()  
  for i,v in ipairs(stars) do
    love.graphics.setColor(v.r, v.g, v.b)
		love.graphics.circle("fill", v.x, v.y, 2)
  end
  
  --love.graphics.setColor(1,1,1, 0.5)
  --love.graphics.circle("fill", playerX, playerY, maxRadius - 10)

  drawInfo(10, 10)
end

function drawInfo(x, y)
    love.graphics.setColor(1,1,1)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), x + 15, y + 15)
    love.graphics.print("Count: "..tostring(table.getn(stars)), x + 15, y + 35)
    love.graphics.print("Player X: "..tostring(math.floor(playerX)), x + 15, y + 55)
    love.graphics.print("Player Y: "..tostring(math.floor(playerY)), x + 15, y + 75)
    love.graphics.print("Dest X: "..tostring(math.floor(lastClickX)), x + 15, y + 95)
    love.graphics.print("Dest Y: "..tostring(math.floor(lastClickY)), x + 15, y + 115)
end

function spawnStars()	
    if (table.getn(stars) >= maxStars) then return end;
		
		local angle = math.random(0, 360)
 
		local starDx = starSpeed * math.cos(angle)
		local starDy = starSpeed * math.sin(angle)
 
		table.insert(stars, {x = playerX, y = playerY, dx = starDx, dy = starDy, angle = angle, r = math.random(), g = math.random(), b = math.random()})	
end

function distance ( x1, y1, x2, y2 )
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end

function love.mousepressed(x, y, button)
  if button == 1 then

    lastClickX = x
    lastClickY = y
    
    local angle = math.atan2((lastClickY - playerY), (lastClickX - playerX))

    playerDestX = math.floor(moveSpeed * math.cos(angle))
    playerDestY = math.floor(moveSpeed * math.sin(angle))
    
    -- move all elements of the stars object towards the mouse click location.
    --for i,v in ipairs(stars) do      
    --  v.dx = destDx
    --  v.dy = destDy
    --end
  end
end