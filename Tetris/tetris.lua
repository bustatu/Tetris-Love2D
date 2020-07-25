require("blocks")

-- Game state table
tetrisGame = {

	--Game font, default: consolas (best font, fite me)
	gameFont = love.graphics.newFont("data/consolas.ttf", 60),
	
	--Render scale
	render_scale_x = 1,
	render_scale_y = 1,
	
	-- Game table size
	size_x = 10,
	size_y = 20,
	
	-- Block related stuff
	block_size = 25,
	border_size = 1,
	bkg_color = {0.8, 0.8, 0.8},
	placedBlocks = {},
	
	--Block that is going to be next chosen
	nextBlock = {
		index_in_blocks = 0,
		frame = 1,
		x = 0,
		y = 0,
		color = {0.8, 0.8, 0.8},
		
		--Function that generates a random block
		generate = function()
			
			math.randomseed(math.random())
			tetrisGame.nextBlock.index_in_blocks = math.random(blocks.count)
			math.randomseed(math.random())
			tetrisGame.nextBlock.frame = math.random(blocks.block_data[tetrisGame.nextBlock.index_in_blocks].frames)
			
			tetrisGame.nextBlock.color = {}
			math.randomseed(math.random())
			tetrisGame.nextBlock.color[1] = math.random(99) / 100
			
			--Second color can't be closer than 0.1 to the first
			math.randomseed(math.random())
			tetrisGame.nextBlock.color[2] = math.random(99) / 100
			while(math.abs(tetrisGame.nextBlock.color[2] - tetrisGame.nextBlock.color[1]) < 0.1) do
				math.randomseed(math.random())
				tetrisGame.nextBlock.color[2] = math.random(99) / 100			
			end
			
			--Last color can't be closer than 0.1 to all the others
			math.randomseed(math.random())
			tetrisGame.nextBlock.color[3] = math.random(99) / 100
			while(math.abs(tetrisGame.nextBlock.color[2] - tetrisGame.nextBlock.color[3]) < 0.1 and math.abs(tetrisGame.nextBlock.color[1] - tetrisGame.nextBlock.color[3]) < 0.1) do
				math.randomseed(math.random())
				tetrisGame.nextBlock.color[3] = math.random(99) / 100			
			end
			
		end,
		
		--Function that draws the block
		draw = function()
			
			--Update position
			tetrisGame.nextBlock.x = love.graphics.getWidth() * 5 / 6
			tetrisGame.nextBlock.y = love.graphics.getHeight() * 2 / 8
			
			--Rectangle around the boundary of the piece
			love.graphics.rectangle('line',
			tetrisGame.nextBlock.x - (blocks.block_data[tetrisGame.nextBlock.index_in_blocks].size_x / 2 * tetrisGame.block_size + 2 * tetrisGame.border_size) * tetrisGame.render_scale_x,
			tetrisGame.nextBlock.y - (blocks.block_data[tetrisGame.nextBlock.index_in_blocks].size_y / 2 * tetrisGame.block_size + 2 * tetrisGame.border_size) * tetrisGame.render_scale_y,
			(blocks.block_data[tetrisGame.nextBlock.index_in_blocks].size_x * tetrisGame.block_size + 3 * tetrisGame.border_size) * tetrisGame.render_scale_x,
			(blocks.block_data[tetrisGame.nextBlock.index_in_blocks].size_y * tetrisGame.block_size + 3 * tetrisGame.border_size) * tetrisGame.render_scale_y)
		
			--Loop trough the piece
			for key, val in ipairs(blocks.block_data[tetrisGame.nextBlock.index_in_blocks][tetrisGame.nextBlock.frame]) do
				
				for key1, val1 in ipairs(val) do 
					
					--If this is ok
					if val1 ~= 0 then
						
						-- Set drawing color
						love.graphics.setColor(tetrisGame.nextBlock.color[1], tetrisGame.nextBlock.color[2], tetrisGame.nextBlock.color[3])
						
						--Draw block
						love.graphics.rectangle('fill',
						tetrisGame.nextBlock.x - (blocks.block_data[tetrisGame.nextBlock.index_in_blocks].size_x / 2 - (key1 - 1)) * tetrisGame.block_size * tetrisGame.render_scale_x,
						tetrisGame.nextBlock.y - (blocks.block_data[tetrisGame.nextBlock.index_in_blocks].size_y / 2 - (key  - 1)) * tetrisGame.block_size * tetrisGame.render_scale_y,
						(tetrisGame.block_size - tetrisGame.border_size) * tetrisGame.render_scale_x,
						(tetrisGame.block_size - tetrisGame.border_size) * tetrisGame.render_scale_y)
						
						-- Reset drawing color
						love.graphics.setColor(1, 1, 1)
						
					end
				
				end

			end
		end,
		
		grabGrabbed = function()
			
			tetrisGame.nextBlock.index_in_blocks = tetrisGame.grabbedBlock.index_in_blocks
			tetrisGame.grabbedBlock.index_in_blocks = 0
			tetrisGame.nextBlock.frame = tetrisGame.grabbedBlock.frame
			tetrisGame.grabbedBlock.frame = 1
			tetrisGame.nextBlock.color = tetrisGame.grabbedBlock.color
			
		end,
	},
	
	-- Current block related stuff (more important than the others)
	currentBlock = {
		index_in_blocks = 1,
		frame = 1,
		-- ALWAYS make this size_x / 2, could not make it myself as this crashes the damn game
		px = 0,
		py = 1,
		x = 0,
		y = 0,
		color = {0, 0, 0},
		speed = 1,
		timer = 0,
		
		--Function that grabs the next block into this current one
		grabNext = function()
		
			--Reset coordonates
			tetrisGame.currentBlock.px = math.floor(tetrisGame.size_x / 2 - #blocks.block_data[tetrisGame.nextBlock.index_in_blocks][tetrisGame.nextBlock.frame] / 2)
			tetrisGame.currentBlock.py = 1
			
			tetrisGame.currentBlock.index_in_blocks = tetrisGame.nextBlock.index_in_blocks
			tetrisGame.currentBlock.frame = tetrisGame.nextBlock.frame
			tetrisGame.currentBlock.color = tetrisGame.nextBlock.color
			
			--Generate another one
			tetrisGame.nextBlock.generate()
			
		end,
		
		--Function that draws the block
		draw = function()
		
			--Loop trough the piece
			for key, val in ipairs(blocks.block_data[tetrisGame.currentBlock.index_in_blocks][tetrisGame.currentBlock.frame]) do
				
				for key1, val1 in ipairs(val) do 
					
					--If this is ok
					if val1 ~= 0 then
						
						-- Set drawing color
						love.graphics.setColor(tetrisGame.currentBlock.color[1], tetrisGame.currentBlock.color[2], tetrisGame.currentBlock.color[3])
						
						--Draw block
						love.graphics.rectangle('fill',
						tetrisGame.currentBlock.x + (key1 - 1 + tetrisGame.currentBlock.px) * tetrisGame.block_size * tetrisGame.render_scale_x,
						tetrisGame.currentBlock.y + (key  - 1 + tetrisGame.currentBlock.py) * tetrisGame.block_size * tetrisGame.render_scale_y,
						(tetrisGame.block_size - tetrisGame.border_size) * tetrisGame.render_scale_x,
						(tetrisGame.block_size - tetrisGame.border_size) * tetrisGame.render_scale_y)
						
						-- Reset drawing color
						love.graphics.setColor(1, 1, 1)
						
					end
				
				end

			end
		end,
		
		--Updates the block each step
		update = function(delta_time)
			
			--Update timer
			tetrisGame.currentBlock.timer = tetrisGame.currentBlock.timer + delta_time * tetrisGame.currentBlock.speed
			while tetrisGame.currentBlock.timer > 1 do
				
				--Go down
				tetrisGame.currentBlock.py = tetrisGame.currentBlock.py + 1
				tetrisGame.currentBlock.timer = tetrisGame.currentBlock.timer - 1
				
			end
		
		end,
		
		--Checks if the current block position is valid within the table context
		validpos = function()
		
			--Loop trough the piece
			for key, val in ipairs(blocks.block_data[tetrisGame.currentBlock.index_in_blocks][tetrisGame.currentBlock.frame]) do
				
				for key1, val1 in ipairs(val) do 
					
					--If this is ok
					if val1 ~= 0 then
						
						--Check bounds
						local tx = (key1 - 1 + tetrisGame.currentBlock.px)
						local ty = (key  - 1 + tetrisGame.currentBlock.py)
						
						if tx < 0 or tx + 1 > tetrisGame.size_x then
							
							return false
							
						elseif ty < 0 or ty + 1 > tetrisGame.size_y then
							
							return false
						
						end
						
						--x : (key1 - 1 + tetrisGame.currentBlock.px)
						--y : (key  - 1 + tetrisGame.currentBlock.py)
						
						--Draw block
						love.graphics.rectangle('fill',
						tetrisGame.currentBlock.x + (key1 - 1 + tetrisGame.currentBlock.px) * tetrisGame.block_size * tetrisGame.render_scale_x,
						tetrisGame.currentBlock.y + (key  - 1 + tetrisGame.currentBlock.py) * tetrisGame.block_size * tetrisGame.render_scale_y,
						(tetrisGame.block_size - tetrisGame.border_size) * tetrisGame.render_scale_x,
						(tetrisGame.block_size - tetrisGame.border_size) * tetrisGame.render_scale_y)
						
					end
				
				end

			end
			
			return true
			
		end,
	},
	
	--Special block that can replace the next one if you do not desire that one
	grabbedBlock = {
		index_in_blocks = 0,
		frame = 1,
		x = 0,
		y = 0,
		color = {0, 0, 0},
		
		--Function that draws the block
		draw = function()
			
			--Update position
			tetrisGame.grabbedBlock.x = love.graphics.getWidth() * 1 / 6
			tetrisGame.grabbedBlock.y = love.graphics.getHeight() * 2 / 8
			
			--Only if there is a block grabbed
			if tetrisGame.grabbedBlock.index_in_blocks ~= 0 then
			
				--Rectangle around the boundary of the piece
				love.graphics.rectangle('line',
				tetrisGame.grabbedBlock.x - (blocks.block_data[tetrisGame.grabbedBlock.index_in_blocks].size_x / 2 * tetrisGame.block_size + 2 * tetrisGame.border_size) * tetrisGame.render_scale_x,
				tetrisGame.grabbedBlock.y - (blocks.block_data[tetrisGame.grabbedBlock.index_in_blocks].size_y / 2 * tetrisGame.block_size + 2 * tetrisGame.border_size) * tetrisGame.render_scale_y,
				(blocks.block_data[tetrisGame.grabbedBlock.index_in_blocks].size_x * tetrisGame.block_size + 3 * tetrisGame.border_size) * tetrisGame.render_scale_x,
				(blocks.block_data[tetrisGame.grabbedBlock.index_in_blocks].size_y * tetrisGame.block_size + 3 * tetrisGame.border_size) * tetrisGame.render_scale_y)
			
				--Loop trough the piece
				for key, val in ipairs(blocks.block_data[tetrisGame.grabbedBlock.index_in_blocks][tetrisGame.grabbedBlock.frame]) do
					
					
					for key1, val1 in ipairs(val) do 
						
						--If this is ok
						if val1 ~= 0 then
							
							-- Set drawing color
							love.graphics.setColor(tetrisGame.grabbedBlock.color[1], tetrisGame.grabbedBlock.color[2], tetrisGame.grabbedBlock.color[3])
							
							--Draw block
							love.graphics.rectangle('fill',
							tetrisGame.grabbedBlock.x - (blocks.block_data[tetrisGame.grabbedBlock.index_in_blocks].size_x / 2 - (key1 - 1)) * tetrisGame.block_size * tetrisGame.render_scale_x,
							tetrisGame.grabbedBlock.y - (blocks.block_data[tetrisGame.grabbedBlock.index_in_blocks].size_y / 2 - (key  - 1)) * tetrisGame.block_size * tetrisGame.render_scale_x,
							(tetrisGame.block_size - tetrisGame.border_size) * tetrisGame.render_scale_x,
							(tetrisGame.block_size - tetrisGame.border_size) * tetrisGame.render_scale_y)
							
							-- Reset drawing color
							love.graphics.setColor(1, 1, 1)
							
						end
					
					end
					
				end
				
			else
			
				love.graphics.setColor(0.8, 0.8, 0.8)
				love.graphics.setFont(tetrisGame.gameFont)
				love.graphics.print("No block grabbed", tetrisGame.grabbedBlock.x, tetrisGame.grabbedBlock.y, 0, 0.25 * tetrisGame.render_scale_x, 0.25 * tetrisGame.render_scale_y, 250, 20)
				
			end
			
		end,
		
		grabNext = function()
			
			--Grab the next then generate
			tetrisGame.grabbedBlock.index_in_blocks = tetrisGame.nextBlock.index_in_blocks
			tetrisGame.grabbedBlock.frame = tetrisGame.nextBlock.frame
			tetrisGame.grabbedBlock.color = tetrisGame.nextBlock.color
			
			--Generate another one
			tetrisGame.nextBlock.generate()
			
		end,
	},
}


-- Called when initialising the state
tetrisGame.init = function()
	
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
	tetrisGame.currentBlock.grabNext()
	
end

-- Called during the update event
tetrisGame.update = function(delta_time)

	tetrisGame.currentBlock.update(delta_time)
	
end

-- Called during the draw event
tetrisGame.draw = function()
	
	-- Size of the entire table
	local tableSizeX = tetrisGame.size_x * tetrisGame.block_size
	local tableSizeY = tetrisGame.size_y * tetrisGame.block_size
	
	tetrisGame.currentBlock.x = love.graphics.getWidth()  / 2 - tableSizeX / 2 * tetrisGame.render_scale_x
	tetrisGame.currentBlock.y = love.graphics.getHeight()  / 2 - tableSizeY / 2 * tetrisGame.render_scale_y
	
	tetrisGame.render_scale_x = love.graphics.getWidth() / 960
	tetrisGame.render_scale_y = love.graphics.getHeight() / 540
	
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
			love.graphics.getWidth()  / 2 - (tableSizeX / 2 - (x - 1) * tetrisGame.block_size) * tetrisGame.render_scale_x,
			love.graphics.getHeight() / 2 - (tableSizeY / 2 - (y - 1) * tetrisGame.block_size) * tetrisGame.render_scale_y,
			(tetrisGame.block_size - tetrisGame.border_size) * tetrisGame.render_scale_x,
			(tetrisGame.block_size - tetrisGame.border_size) * tetrisGame.render_scale_y)
			
			-- Reset drawing color
			love.graphics.setColor(1, 1, 1)
		end
		
	end
	
	--Draw blocks
	tetrisGame.nextBlock.draw()
	tetrisGame.grabbedBlock.draw()
	tetrisGame.currentBlock.draw()
	
	--Draw text
	love.graphics.setColor(0.8, 0.8, 0.8)
	love.graphics.setFont(tetrisGame.gameFont)
	love.graphics.print("NEXT", tetrisGame.nextBlock.x, tetrisGame.nextBlock.y, 0, tetrisGame.render_scale_x, tetrisGame.render_scale_y, 65, 105)
	love.graphics.print("GRAB", tetrisGame.grabbedBlock.x, tetrisGame.grabbedBlock.y, 0, tetrisGame.render_scale_x, tetrisGame.render_scale_y, 65, 105)
	love.graphics.setColor(1, 1, 1)
	
end

--Called when a key was released
tetrisGame.onKeyRelease = function(key)
	
	--Reset down speed
	if key == "down" then
		
		tetrisGame.currentBlock.speed = 1
		
	end

end

--Called when a key was pressed
tetrisGame.onKeyPress = function(key)
	
	--Piece rotation
	if key == "x" then
		
		--Change the frame, if it exceeds the limit then reset
		tetrisGame.currentBlock.frame = tetrisGame.currentBlock.frame + 1
		if tetrisGame.currentBlock.frame > blocks.block_data[tetrisGame.currentBlock.index_in_blocks].frames then
			tetrisGame.currentBlock.frame = 1
		end
		
	elseif key == "z" then
	
		--Change the frame, if it exceeds the limit then reset
		tetrisGame.currentBlock.frame = tetrisGame.currentBlock.frame - 1
		if tetrisGame.currentBlock.frame < 1 then
			tetrisGame.currentBlock.frame = blocks.block_data[tetrisGame.currentBlock.index_in_blocks].frames
		end
		
	elseif key == "down" then
		
		--Move down
		tetrisGame.currentBlock.speed = 5
		
	elseif key == "left" then
	
		--Move left
		tetrisGame.currentBlock.px = tetrisGame.currentBlock.px - 1
		
		--If not valid then go back
		if tetrisGame.currentBlock.validpos() ~= true then
		
			tetrisGame.currentBlock.px = tetrisGame.currentBlock.px + 1
			
		else 
			
			--If valid, then timer can be reset
			tetrisGame.currentBlock.timer = 0
			
		end
	
	elseif key == "right" then
	
		--Move right
		tetrisGame.currentBlock.px = tetrisGame.currentBlock.px + 1
		
		--If not valid then go back
		if tetrisGame.currentBlock.validpos() ~= true then
		
			tetrisGame.currentBlock.px = tetrisGame.currentBlock.px - 1
			
		else 
			
			--If valid, then timer can be reset
			tetrisGame.currentBlock.timer = 0
			
		end
		
	elseif key == "up" then
		
		--If the block is not picked up already
		if tetrisGame.grabbedBlock.index_in_blocks == 0 then
		
			--Grab next block
			tetrisGame.grabbedBlock.grabNext()
			
		else
			
			--Restore the block and reset
			tetrisGame.nextBlock.grabGrabbed()
			
		end

	end
	
end