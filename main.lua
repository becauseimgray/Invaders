--Space Invaders Clone WIP 
--Created by Gray
--Due Feb 1st
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

	--how far from (0, 0) they spawn
		enemy.x = i * (enemy.w + 60) + 100
		enemy.y = enemy.h + 100
	--enemy's current speed
		enemy.speed = 60
		table.insert(enemies, enemy)
	--creating a boolean to tell which direction we are currently moving
		enemy.right = true

	--creating collision rectangle for left side
	colrectL = {}
	colrectL.x = -10
	colrectL.y = 0
	colrectL.w = 10
	colrectL.h = 600
	colrectL.mode = "fill"

	--creating collision rectangle for right side
	colrectR = {}
	colrectR.x = winw + 1
	colrectR.y = 0
	colrectR.w = 10
	colrectR.h = 600
	colrectR.mode = "fill"

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
    --debugging in case of cthulhu

    -- if love.keyboard.isDown("down") then player.y = player.y + player.speed - dt; end

    --if love.keyboard.isDown("up") then    player.y = player.y - player.speed - dt; end



    --boundaries and movement for enemies

	--starting enemies loop
    for i,v in ipairs(enemies) do
    	--checking to see if enemy is colliding with rectangles
  		if v.x < colrectR.x + colrectR.w and colrectR.x < v.x + v.w and v.y < colrectR.y + colrectR.h and colrectR.y < v.y + v.h then
			enemy.right = false
		end
		--this is same thing, but for the left rectangle(i.e, -1)
  		if v.x < colrectL.x + colrectL.w and colrectL.x < v.x + v.w and v.y < colrectL.y + colrectL.h and colrectL.y < v.y + v.h then
			enemy.right = true
		end

	--if true, move right
	--if false, move left
		if enemy.right then
			v.x = v.x + enemy.speed * dt
		end

		if enemy.right == false then
			v.x = v.x - enemy.speed * dt
		end
    end
	end
end

function love.draw()

	--drawing background
		love.graphics.draw(background)
	
	--drawing player
		love.graphics.draw(player.image, player.x, player.y)
	
	
	--collision rectangles
	
	love.graphics.rectangle(colrectR.mode, colrectR.x, colrectR.y, colrectR.w, colrectR.h)
	love.graphics.rectangle(colrectL.mode, colrectL.x, colrectL.y, colrectL.w, colrectL.h)
	
	--drawing enemies
	for i,v in ipairs(enemies) do
    	love.graphics.draw(enemy.image, v.x, v.y, v.width, v.height)
	end


end
