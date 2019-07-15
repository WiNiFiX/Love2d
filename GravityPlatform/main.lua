platformHeight = 200 -- from bottom of screen
platform = {}
player = {}  -- Add this below the platform variable
 
function love.load()
    love.graphics.setBackgroundColor(0.21, 0.67, 0.97) 

    -- This is the height and the width of the platform.
	platform.width = love.graphics.getWidth()    -- This makes the platform as wide as the whole game window.
	platform.height = love.graphics.getHeight()  -- This makes the platform as tall as the whole game window.
 
    -- This is the coordinates where the platform will be rendered.
	platform.x = 0                                            -- This starts drawing the platform at the left edge of the game window.
    platform.y = love.graphics.getHeight() - platformHeight   -- This starts drawing the platform at the very middle of the game window
    
    -- This is the coordinates where the player character will be rendered.
	player.x = love.graphics.getWidth() / 2   -- This sets the player at the middle of the screen based on the width of the game window. 
    player.y = platform.y
    
    player.speed = 300                        -- This is the player's speed. This value can be change based on your liking.
    
    -- This calls the file named "purple.png" and puts it in the variable called player.img.
    player.img = love.graphics.newImage('fishy.png')
    player.ground = player.y -- This makes the character land on the plaform.     
	player.y_velocity = 0        -- Whenever the character hasn't jumped yet, the Y-Axis velocity is always at 0. 
	player.jump_height = -300    -- Whenever the character jumps, he can reach this height.
    player.gravity = -500        -- Whenever the character falls, he will descend at this rate.
        
	bulletSpeed = 250 
    bullets = {}
    
    myShader = love.graphics.newShader([[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
      return pixel * color;
    }
  ]])
end
 
function love.update(dt)
    if love.keyboard.isDown('d') then
		-- This makes sure that the character doesn't go pass the game window's right edge.
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = player.x + (player.speed * dt)
		end
	elseif love.keyboard.isDown('a') then
		-- This makes sure that the character doesn't go pass the game window's left edge.
		if player.x > 0 then 
			player.x = player.x - (player.speed * dt)
		end
    end
    if love.keyboard.isDown('space') then         -- The game checks if the player is on the ground. Remember that when the player is on the ground, Y-Axis Velocity = 0.
        if player.y_velocity == 0 then
            player.y_velocity = player.jump_height    -- The player's Y-Axis Velocity is set to it's Jump Height.
        end
    end

    -- This is in charge of the jump physics.
    if player.y_velocity ~= 0 then                                  -- The game checks if player has "jumped" and left the ground.
		player.y = player.y + player.y_velocity * dt                -- This makes the character ascend/jump.
		player.y_velocity = player.y_velocity - player.gravity * dt -- This applies the gravity to the character.
	end
 
    -- This is in charge of collision, making sure that the character lands on the ground.
    if player.y > player.ground then                                -- The game checks if the player has jumped.
		player.y_velocity = 0                                       -- The Y-Axis Velocity is set back to 0 meaning the character is on the ground again.
    	player.y = player.ground                                    -- The Y-Axis Velocity is set back to 0 meaning the character is on the ground again.
    end
    
    for i,v in ipairs(bullets) do
		v.x = v.x + (v.dx * dt)
		v.y = v.y + (v.dy * dt)
	end
end
 
function love.draw()
	love.graphics.setColor(1, 1, 0.6)        -- This sets the platform color to white.
 
    -- The platform will now be drawn as a white rectangle while taking in the variables we declared above.
    love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)
    
    love.graphics.setShader(myShader) --draw something here
    -- This draws the player.
    love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, player.img:getHeight())
    love.graphics.setShader()

	love.graphics.setColor(0.5, 0.5, 0.5)
	for i,v in ipairs(bullets) do
		love.graphics.circle("fill", v.x, v.y, 5)
    end
    
    --love.graphics.setColor(0.5, 0.5, 0.5, 1) -- single dark color
	--love.graphics.rectangle("fill", 0, 0, platform.width, platform.height) 
    --love.graphics.setBlendMode("subtract")
    
    
    
end

function love.mousepressed(x, y, button)
	if button == 1 then
		local startX = player.x + player.img:getWidth() / 2
		local startY = player.y - player.img:getHeight() / 2
		local mouseX = x
		local mouseY = y
 
		local angle = math.atan2((mouseY - startY), (mouseX - startX))
 
		local bulletDx = bulletSpeed * math.cos(angle)
		local bulletDy = bulletSpeed * math.sin(angle)
 
		table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})
	end
end