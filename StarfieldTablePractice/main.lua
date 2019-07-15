local maxStars = 1000
local starSpeed = 60

local screenX, screenY = 0, 0
local screenCanvas

function love.load()
    screenX, screenY = love.graphics.getDimensions()  
    stars = {}
end

function love.update(dt) 
  spawnStars()

  for i,v in ipairs(stars) do
		v.x = v.x + (v.dx * dt)
    v.y = v.y + (v.dy * dt)
    if (v.x < 0 or v.x > screenX or v.y < 0 or v.y > screenY) then      
      table.remove(stars, i)
    end
	end
end

function love.draw()  
  for i,v in ipairs(stars) do
		love.graphics.circle("fill", v.x, v.y, 2)
  end
  
  drawFPS(10, 10)
end

function drawFPS(x, y)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), x + 15, y + 15)
end

function spawnStars()	
    if (table.getn(stars) >= maxStars) then return end;

		local startX = screenX/2
		local startY = screenY/2
		
		local angle = math.random(0, 360)
 
		local starDx = starSpeed * math.cos(angle)
		local starDy = starSpeed * math.sin(angle)
 
		table.insert(stars, {x = startX, y = startY, dx = starDx, dy = starDy})	
end