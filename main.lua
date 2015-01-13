--Space Invaders Clone WIP 
--Created by Gray
--Due Feb 1st
--www.github.com/becauseimgray
--Thank you to Pix for creating bgmusic
--http://www.sakari-infinity.net/author/pix/


require("BoundingBox")
require ('sounds')
Menu = require("menu")
require("AnAL")
require("animator")

function love.load()
	clicked = 			love.audio.newSource("sounds/clicked.wav", "static") -- menu select sound
	bgm = 				love.audio.play("sounds/bgsong.mp3", "stream", true) -- background music that plays during the main game
	love.audio.stop(bgm)												     -- stops music so it doesnt play during main menu screen
	font = 				love.graphics.setNewFont( "fonts/LCD_Solid.ttf", 60 )--loads score font
	default = 			love.graphics.setNewFont( "fonts/LCD_Solid.ttf", 10 )--loads default size for menu
	levelfont = 		love.graphics.setNewFont( "fonts/LCD_Solid.ttf", 50) --loads level font
	bulletimg = 		love.graphics.newImage('images/bullet.png')          --bullet image
	background = 		love.graphics.newImage('images/bg.png')              --background image
	gameStart = false --Game booleans and integers
	gameWon = false
	score = 0 -- Keeping score
	level = 1 -- Keeping track of which level we're on 

		
	--isAlive = true | use this to see if the player is alive when hit with an enemy bullet


	--create menu
	menu = Menu.new()
   		menu:addItem{
     	name = 'Start Game',
      	action = function()
      		if gameStart == false then
      			clicked:play()
      			love.audio.play(bgm)
      		end
        gameStart = true
    	end
   }
   menu:addItem{
      	name = 'Quit',
      	action = function()
      	gameStart = false
      	love.event.quit()
      	end
   }

   if gameWon == true then
   	winmenu = Menu.new()
   end

	--get window dimensions
	winw = love.window.getWidth()
	winh = love.window.getHeight()



	--create player
	player = {}

	player.image = love.graphics.newImage('images/player.png')
	player.w, player.h = 32
	player.x = winw / 2 - player.w
	player.y = winh - 50
	player.speed = 600



	--create enemies 
	enemies = {}

	for j = 0, 2 do
		for i = 0, 7 do
			enemy = {}
			enemy.image = love.graphics.newImage('images/enemy.png')
			enemy.w = 32
			enemy.h = 32
			enemy.x = i * (enemy.w + 60) + 100
			enemy.y = j * (enemy.h + 100) + 100
			enemy.speed = 60
			table.insert(enemies, enemy)
			enemy.right = true
		end
	end



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

	--create bullets
	bullets = {}
	--bullet timer
	canShoot = true
	canShootTimerMax = 0.1 --0.9 = perfect speed || lower speeds = faster shooting
	shootSpeed = 100
	canShootTimer = canShootTimerMax

	-- obstacle = {}
	-- obstacle.w = 96
	-- obstacle.h = 96
	-- obstacle.image     = love.graphics.newImage("images/obstacle.png")        --animations start here
	-- obstacle.ouch1 = 	 love.graphics.newImage("images/obstacleouch1.png")   
	-- obstacle.ouch2 = 	 love.graphics.newImage("images/obstacleouch2.png")
	-- obstacle.ouch3 =      love.graphics.newImage("images/obstacleouch3.png")
	-- obstacle.anim  =      newAnimation(obstacle.image, 96, 96, 3, 0)           --using AnAL to load in animation settings
	-- obstacle.ouch1anim  = newAnimation(obstacle.ouch1, 96, 96, 3, 0)
	-- obstacle.ouch2anim  = newAnimation(obstacle.ouch2, 96, 96, 3, 0)
	-- obstacle.ouch3anim  = newAnimation(obstacle.ouch3, 96, 96, 3, 0) 
	-- obstacle.x          = winw - 700
	-- obstacle.y          = player.y - 150
	animationLoad(obstacle, 96, 96, winw - 700, player.y - 150, "images/obstacle.png", 3)
	animationLoad(obstacle2, 96, 96, winw - 700, player.y - 150, "images/obstacleouch2.png", 3)

	-- --creating obstacle booleans 
	-- damagedouch1 = false
	-- damagedouch2 = false
	-- damagedouch3 = false

end

function love.keypressed(key)
   menu:keypressed(key)
end

function love.update(dt)
	--update menu
	menu:update(dt)

	--update animation
	animationUpdate(obstacle, dt)
	animationUpdate(obstacle2, dt)

	-- --update animations
	-- obstacle.anim:update(dt)
	-- obstacle.ouch1anim:update(dt)
	-- obstacle.ouch2anim:update(dt)
	-- obstacle.ouch3anim:update(dt)

	--update music if playing game
	if gameStart == true then love.audio.update() end

	--canshoot?
	canShootTimer = canShootTimer - (1 * dt)
	if canShootTimer < 0 then canShoot = true end


   --boundaries and movement for player
	if love.keyboard.isDown("right") and player.x + player.w <= winw then player.x = player.x + player.speed * dt; end

    if love.keyboard.isDown("left") and player.x >= 0 then player.x = player.x - player.speed * dt; end

    --Create bullets when z or space is pressed 
    if love.keyboard.isDown(' ', 'z') and canShoot then
	newBullet = { x = player.x + (player.image:getWidth()/2), y = player.y, img = bulletImg }
	table.insert(bullets, newBullet)
	canShoot = false
	canShootTimer = canShootTimerMax
	end

--boundaries and movement for enemies

	--starting enemies loop
    for i,v in ipairs(enemies) do
    	--checking to see if enemy is colliding with rectangles
  		if v.x < colrectR.x + colrectR.w and colrectR.x < v.x + v.w and v.y < colrectR.y + colrectR.h and colrectR.y < v.y + v.h then
			enemy.right = false
		end
  		if v.x < colrectL.x + colrectL.w and colrectL.x < v.x + v.w and v.y < colrectL.y + colrectL.h and colrectL.y < v.y + v.h then
			enemy.right = true
		end

	--if true, move right
	--if false, move left
		if enemy.right then v.x = v.x + enemy.speed * dt end

		if enemy.right == false then v.x = v.x - enemy.speed * dt end
	end

	-- update the positions of bullets
	for i, bullet in ipairs(bullets) do
		bullet.y = bullet.y - (shootSpeed * dt)

  		if bullet.y < 0 then -- remove bullets when they pass off the screen
			table.remove(bullets, i)
		end
	end

    	--bullet collision logic loop
    for i, enemy in ipairs(enemies) do
		for j, bullet in ipairs(bullets) do
			if CheckCollision(enemy.x, enemy.y, enemy.image:getWidth(), enemy.image:getHeight(), bullet.x, bullet.y, bulletimg:getWidth(), bulletimg:getHeight()) then
				table.remove(bullets, j)
				table.remove(enemies, i)
				score = score + 1
			end
		end
	end

	for i, bullet in ipairs(bullets) do
		if animationCollision(bullet.x, bullet.y, bulletimg:getWidth(), bulletimg:getHeight()) then
			animationNext(obstacle, obstacle2)
		end

		-- if damagedouch1 == false and damagedouch2 == false and damagedouch3 == false then
		-- 	if CheckCollision(bullet.x, bullet.y, bulletimg:getWidth(), bulletimg:getHeight(), obstacle.x, obstacle.y, obstacle.w, obstacle.h - 25) then
		-- 		table.remove(bullets, i)
		-- 		damagedouch1 = true
		-- 	end
		-- end

		-- if damagedouch1 == true then
		-- 	if CheckCollision(bullet.x, bullet.y, bulletimg:getWidth(), bulletimg:getHeight(), obstacle.x, obstacle.y, obstacle.w, obstacle.h - 25) then
		-- 		table.remove(bullets, i)
		--  		damagedouch2 = true
		--  		damagedouch1 = false
		--  	end
		-- end
	end


	if not next(enemies) then
		level = level + 1 
		speed = level + 60
			for i, bullet in ipairs(bullets) do
				for bullet in pairs (bullets) do
    				bullets [bullet] = nil
				end
				canShoot = false
				canShootTimer = canShootTimerMax
			end
				for j = 0, 2 do
					for i = 0, 7 do
					enemy = {}
					enemy.image = love.graphics.newImage('images/enemy.png')
					enemy.w = 32
					enemy.h = 32
					enemy.x = i * (enemy.w + 60) + 100
					enemy.y = j * (enemy.h + 100) + 100
					enemy.speed = speed + 5
					table.insert(enemies, enemy)
					enemy.right = true
					end
				end
	end
end




function love.draw()
	
if gameStart == true then
	love.graphics.setFont( font )
	love.graphics.setColor(255,255,255,255)
	
	--drawing background
		love.graphics.draw(background)
	
	--drawing player
		love.graphics.draw(player.image, player.x, player.y)
	
	
	--collision rectangles
	love.graphics.rectangle(colrectR.mode, colrectR.x, colrectR.y, colrectR.w, colrectR.h)
	love.graphics.rectangle(colrectL.mode, colrectL.x, colrectL.y, colrectL.w, colrectL.h)
	

	--drawing animations
	if damagedouch1 == true then
		obstacle.ouch1anim:draw(obstacle.x, obstacle.y)
	end

	if damagedouch2 == true then
		obstacle.ouch2anim:draw(obstacle.x, obstacle.y)
	end

	if damagedouch3 == true then
		obstacle.ouch3anim:draw(obstacle.x, obstacle.y) 
	end
	
	if damagedouch1 == false then
		obstacle.anim:draw(obstacle.x, obstacle.y)
	end
	
	--drawing bullets
	for i, bullet in ipairs(bullets) do
  		love.graphics.draw(bulletimg, bullet.x, bullet.y)
	end

	--drawing enemies
	for i,v in ipairs(enemies) do
    	love.graphics.draw(enemy.image, v.x, v.y, v.width, v.height)
	end

	love.graphics.print("Score: " .. score, 10, 5)
	love.graphics.setFont( levelfont )
	love.graphics.setColor( 255, 0, 0)
	love.graphics.print("Level: " .. level, winw / 1.5, 5)

end
	if gameStart == false then
		love.graphics.setColor( 255, 255, 255)
		love.graphics.setFont( default )
		love.graphics.draw(background)
		--draw menu
		menu:draw(winw / 2 - 50, winh / 2)
	end

	if gameStart == true and level == 10 then
		canShoot = false
		for bullet in pairs (bullets) do
    		bullets [bullet] = nil
		end
		gameWon = true
		love.graphics.setColor( 0, 0, 255)
		love.graphics.print("Congratulations! You win!", 10, winh / 2 )
		love.graphics.print("Press 'x' to Continue", 10, winh / 2 + 100)
		enemy.speed = 180
		if love.keyboard.isDown('x') then
		gameStart = false
		gameWon = false
		level = 1
		love.audio.stop(bgm)
		love.graphics.reset()
	end
	end

end



