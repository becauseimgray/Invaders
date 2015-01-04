--Space Invaders Clone WIP 
--Created by Gray
--Due Feb 1st
--www.github.com/becauseimgray
--Thank you to Pix for creating bgmusic
--http://www.sakari-infinity.net/author/pix/

require("AnAL")
require("BoundingBox")
require ('sounds')
Menu = require("menu")

function love.load()

	--load soundtrack, fonts, and images
	clicked = love.audio.newSource("sounds/clicked.wav", "static")
	bgm = love.audio.play("sounds/bgsong.mp3", "stream", true)
	love.audio.stop(bgm)
	font = love.graphics.setNewFont( "fonts/LCD_Solid.ttf", 60 )
	default = love.graphics.setNewFont( "fonts/LCD_Solid.ttf", 10 )
	levelfont = love.graphics.setNewFont( "fonts/LCD_Solid.ttf", 50)
	bulletimg = love.graphics.newImage('images/bullet.png')
	background = love.graphics.newImage('images/bg.png')


	--Game bool
	gameStart = false
	gameWon = false

	--Later on, we'll use this to see if the player is alive when hit with an enemy bullet
	--isAlive = true

	--Scoring
	score = 0
	--Levels
	level = 1

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
end

function love.keypressed(key)
   menu:keypressed(key)
end

function love.update(dt)
	--update menu
	menu:update(dt)

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

	if not next(enemies) then
		level = level + 1 
		speed = level + 60
			for i, bullet in ipairs(bullets) do
				table.remove(bullets)
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

	if gameStart == true and level == 2 then
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



