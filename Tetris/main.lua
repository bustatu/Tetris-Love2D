require("tetris")

state = tetrisGame

-- Executed on app load
function love.load()
	
	--Randomizes the random number generator
	math.randomseed(os.time())
	
	-- Initialises the default game state. All other initialisations must be done individually
	state.init()
	
end

-- Executed on each game step
function love.update(delta_time)

	-- Updates the game state
	state.update(delta_time)
	
end

-- Executed on each draw call
function love.draw()

	-- Clears the screen
	love.graphics.clear(0.1, 0.1, 0.1, 1)
	
	-- Draws the entire GUI
	state.draw()
	
end

--Executed on key press
function love.keypressed(key)
	
	--Updates state
	state.onKeyPress(key)
	
end