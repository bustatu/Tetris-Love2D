require("blocks")

-- Game state table
tetrisGame = {

	--Game font, default: consolas (best font, fite me)
	gameFont = love.graphics.newFont("data/consolas.ttf", 60),
	
	-- Game table size
	size_x = 10,
	size_y = 18,
	
	-- Block related stuff
	block_size = 25,
	border_size = 1,
	bkg_color = {0.8, 0.8, 0.8},
	placedBlocks = {},
	
	--Block that is going to be next chosen
	nextBlock = {
		index_in_blocks = 0,
		frame = 1,
		x = love.graphics.getWidth() * 5 / 6,
		y = love.graphics.getHeight() * 2 / 8,
		
		--Function that generates random block
		generate = function()
			
			math.randomseed(math.random())
			index_in_blocks = math.random(blocks.count)
			math.randomseed(math.random())
			frame = math.random(blocks.block_data[index_in_blocks].frames)
			
			print(index_in_blocks, frame)
			
		end,
		
		--Function that draws the block
		draw = function()
		
			--Loop trough the piece
			for key, val in ipairs(blocks.block_data[index_in_blocks][frame]) do
				
				for key1, val1 in ipairs(val) do 
					
					--If this is ok
					if val1 ~= 0 then
				
						love.graphics.rectangle('fill',
						tetrisGame.nextBlock.x + (key1 - 1) * tetrisGame.block_size,
						tetrisGame.nextBlock.y + (key - 1) * tetrisGame.block_size,
						tetrisGame.block_size - tetrisGame.border_size,
						tetrisGame.block_size - tetrisGame.border_size)
						
					end
					
					-- Reset drawing color
					love.graphics.setColor(1, 1, 1)
				
				end

			end
		end
	},
	
	-- Current block related stuff (more important than the others)
	currentBlock = {
		index_in_blocks = 0,
		frame = 1,
		-- ALWAYS make this size_x / 2, could not make it myself as this crashes the damn game
		px = 0,
		py = 0,
		
		
		--Function that grabs the next block into this current one
		grabNext = function()
			px = tetrisGame.size_x / 2
			py = 1
		end,
		
		--Function that draws the block on the screen
		draw = function()
		
		end
	},
	
	--Special block that can replace the next one if you do not desire that one
	grabbedBlock = {
		index_in_blocks = 0,
		frame = 1,
		x = 0,
		y = 0,
	},
}


-- Called when initialising the state
tetrisGame.init = function()
	
	--Make table structure identical so there are no problems switching around
	tetrisGame.grabbedBlock.init = tetrisGame.nextBlock.init
	tetrisGame.grabbedBlock.draw = tetrisGame.nextBlock.draw
	tetrisGame.grabbedBlock.generate = tetrisGame.grabbedBlock.generate
	
	-- Initialise game map
	for y = 1, tetrisGame.size_y, 1 do
	
		tetrisGame.placedBlocks[y] = {}
		
		for x = 1, tetrisGame.size_y, 1 do
			
			-- Initialise block structure (empty for now)
			tetrisGame.placedBlocks[y][x] = {}
			
			-- More like 0 - empty, 1 - not empty
			tetrisGame.placedBlocks[y][x].block_type = 0
			tetrisGame.placedBlocks[y][x].color = {0, 0, 0}
		end
		
	end
	
	--Generate next block for the game to be able to start
	tetrisGame.nextBlock.generate()
	
	--Move the generated block into the main block
	
	--Generate another one
	tetrisGame.nextBlock.generate()
	
end

-- Called during the update event
tetrisGame.update = function(delta_time)

	--TODO: implement a timer and game logic

end

-- Called during the draw event
tetrisGame.draw = function()
	
	-- Size of the entire table
	local tableSizeX = tetrisGame.size_x * tetrisGame.block_size
	local tableSizeY = tetrisGame.size_y * tetrisGame.block_size
	
	-- Loops trough all the squares
	for y = 1, tetrisGame.size_y, 1 do
	
		for x = 1, tetrisGame.size_x, 1 do
			
			-- Set square drawing color
			if tetrisGame.placedBlocks[y][x].block_type == 0 then
				love.graphics.setColor(tetrisGame.bkg_color[1], tetrisGame.bkg_color[2], tetrisGame.bkg_color[3])
			else
				love.graphics.setColor(tetrisGame.placedBlocks[y][x].color[1], tetrisGame.placedBlocks[y][x].color[2], tetrisGame.placedBlocks[y][x].color[3])
			end
			
			-- Draws the squares
			love.graphics.rectangle('fill',
			love.graphics.getWidth()  / 2 - tableSizeX / 2 + (x - 1) * tetrisGame.block_size,
			love.graphics.getHeight() / 2 - tableSizeY / 2 + (y - 1) * tetrisGame.block_size,
			tetrisGame.block_size - tetrisGame.border_size,
			tetrisGame.block_size - tetrisGame.border_size)
			
			-- Reset drawing color
			love.graphics.setColor(1, 1, 1)
		end
		
	end
	
	--Draw blocks
	tetrisGame.nextBlock.draw()
	tetrisGame.grabbedBlock.draw()
	
	--Draw text
	love.graphics.setColor(0.8, 0.8, 0.8)
	love.graphics.setFont(tetrisGame.gameFont)
	love.graphics.print("NEXT", tetrisGame.nextBlock.x, tetrisGame.nextBlock.y, 0, 1, 1, 15, 50)
	love.graphics.print("GRAB", tetrisGame.grabbedBlock.x, tetrisGame.grabbedBlock.y, 0, 1, 1, 15, 50)
end

--Called when a key was pressed
tetrisGame.onKeyPress = function(key)

end