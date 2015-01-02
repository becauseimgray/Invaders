--Space Invaders Clone WIP 
--Created by Gray
--www.github.com/becauseimgray

function love.load()

	--get window dimensions
	winw = love.window.getWidth()
	winh = love.window.getHeight()
	--create player
	player = {}
	player.image = love.graphics.newImage('images/player.png')
	--player dimensions and location
	player.w, player.h = 32
	player.x = winw / 2 - player.w
	player.y = winh - 50
	--player's current speed
	player.speed = 600

	--create enemies 
	enemies = {}
	--set variables for enemies
	for i = 0, 7 do
		enemy = {}
		enemy.image = love.graphics.newImage('images/enemy.png')
		enemy.w = 32
		enemy.h = 32

	--set enemies location
		enemy.x = i * (enemy.w + 60) + 100
		enemy.y = enemy.h + 100
	--enemy's current speed
		enemy.speed = 100
		table.insert(enemies, enemy)
	end

	--create/load background image

	background = love.graphics.newImage('images/bg.png')

end

function love.update(dt)

    --boundaries and movement for player

	if love.keyboard.isDown("right") and player.x + player.w <= winw then
		player.x = player.x + player.speed * dt
	end

    if love.keyboard.isDown("left") and player.x >= 0 then
        player.x = player.x - player.speed * dt;
    end

    --boundaries and movement for enemies
   
	for i,v in ipairs(enemies) do

    -- movement (currently downwards) 
    -- planning to make them move side to side like space invaders
    v.y = v.y + dt

    if v.y > 465 then
    end

end
	--debugging in case of cthulhu

   -- if love.keyboard.isDown("down") then player.y = player.y + player.speed - dt; end

   --if love.keyboard.isDown("up") then    player.y = player.y - player.speed - dt; end

end

function love.draw()

	--drawing background

		love.graphics.draw(background)
	
	--drawing player
	
		love.graphics.draw(player.image, player.x, player.y)
	
	--drawing enemies
	
	for i,v in ipairs(enemies) do
    	love.graphics.draw(enemy.image, v.x, v.y, v.width, v.height)
	end


end
