local maxStars = 1000
local starSpeed = 200
local maxRadius = 50
local startX, startY, screenX, screenY = 0
local screenCanvas

function love.load()
    screenX, screenY = love.graphics.getDimensions()  
    startX = screenX/2
    startY = screenY/2
    stars = {}
end

function love.update(dt) 
  spawnStars()

  for i,v in ipairs(stars) do

    local angle = math.random(0, 360)
 
		local starDx = starSpeed * math.cos(angle)
    local starDy = starSpeed * math.sin(angle)
    
		v.x = v.x + (starDx * dt)
    v.y = v.y + (starDy * dt)
    if (distance(v.x, v.y, startX, startY) > maxRadius) then
    --if (v.x < 0 or v.x > screenX or v.y < 0 or v.y > screenY) then                
      table.remove(stars, i)
    end
	end
end

function love.draw()  
  for i,v in ipairs(stars) do
    love.graphics.setColor(v.r, v.g, v.b)
		love.graphics.circle("fill", v.x, v.y, 2)
  end
  
  drawInfo(10, 10)
end

function drawInfo(x, y)
    love.graphics.setColor(1,1,1)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), x + 15, y + 15)
    love.graphics.print("Count: "..tostring(table.getn(stars)), x + 15, y + 35)
end

function spawnStars()	
    if (table.getn(stars) >= maxStars) then return end;
		
		local angle = math.random(0, 360)
 
		local starDx = starSpeed * math.cos(angle)
		local starDy = starSpeed * math.sin(angle)
 
		table.insert(stars, {x = startX, y = startY, dx = starDx, dy = starDy, angle = angle, r = math.random(), g = math.random(), b = math.random()})	
end

function distance ( x1, y1, x2, y2 )
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end