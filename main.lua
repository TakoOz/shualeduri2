push = require 'push'
Class = require 'class'

require 'Player'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PLAYER_SPEED = 5

gameState = 'start'

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	love.window.setTitle('Catch!')
	
	math.randomseed(os.time())
	
	
	mediumFont = love.graphics.newFont('font.ttf', 10)
	smallFont = love.graphics.newFont('font.ttf', 6)
	
	love.graphics.setFont(mediumFont)
	
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = true,
		vsync = true
	})

	sounds = {
		['score'] = love.audio.newSource('sounds/score.wav', 'static'),
		['miss'] = love.audio.newSource('sounds/miss.wav', 'static')
	}

    player = Player(VIRTUAL_WIDTH/2-13, VIRTUAL_HEIGHT-24)

    playerScore = 0

    ball = Ball(VIRTUAL_WIDTH/2-2, 0)
    point = 0

end

function love.resize(weight, height)
	push:resize(weight, height)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end

    if key == 'enter' or key == 'return' then
		if gameState == 'start' then
			gameState = 'ready'
		elseif gameState == 'ready' then
			gameState = 'play'
		elseif gameState == 'win' or gameState=='lose'then
			gameState = 'start'
            winner = 0
            playerScore = 0
            playerMiss = 0
           
        end
    end
end

function love.update(dt)

    if gameState == 'ready' then
		point= math.random(0,VIRTUAL_WIDTH)
    end
 

    if gameState == 'play' then
        ball.x= point
        ball.y=ball.y+3
    end

    if ball:collides(player) then
		playerScore = playerScore + 1
		sounds['score']:play()
        ball:reset()

    end

    if ball.y >= VIRTUAL_HEIGHT then
		playerScore = playerScore - 1
		sounds['miss']:play()
        ball:reset()
    end

	if playerScore==10 then
		gameState= 'win'
	elseif playerScore==-10 then
		gameState= 'lose'
	end

    ball:update(dt)
    



    if gameState== 'play' then

    if love.keyboard.isDown('right') then
		player.x = math.min(player.x + PLAYER_SPEED, VIRTUAL_WIDTH - player.width)
	elseif love.keyboard.isDown('left') then
		player.x = math.max(player.x - PLAYER_SPEED, 0)
	end
    end

end

function love.draw()
	push:start()
	
	love.graphics.clear(20/255, 40/255, 50/255, 255/255)
	
	
	
	displayScore()
	
	
	if gameState == 'start' then
		love.graphics.setFont(mediumFont)
		love.graphics.printf('Welcome to Catch!', 0, VIRTUAL_HEIGHT/2-30, VIRTUAL_WIDTH, 'center')
		love.graphics.printf('Press Enter!', 0, VIRTUAL_HEIGHT/2-15, VIRTUAL_WIDTH, 'center')
	elseif gameState == 'ready' then
		love.graphics.setFont(mediumFont)
		love.graphics.printf('Press Enter when ready!', 0, 10, VIRTUAL_WIDTH, 'center')
	elseif gameState == 'win' then
		love.graphics.setFont(mediumFont)
		love.graphics.printf('You Won!', 0, VIRTUAL_HEIGHT/2 - 5, VIRTUAL_WIDTH, 'center')

	elseif gameState== 'lose' then
		love.graphics.setFont(mediumFont)
		love.graphics.printf('You Lost!', 0, VIRTUAL_HEIGHT/2 - 5, VIRTUAL_WIDTH, 'center')
	end
	
	player:render()

    ball:render()
	
	push:finish()
end

function displayScore()
	love.graphics.setFont(smallFont)
	love.graphics.print('Score: ' .. playerScore, 5, VIRTUAL_HEIGHT -15)
end
