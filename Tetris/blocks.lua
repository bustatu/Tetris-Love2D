--[[
	Blocks table that can be modified
	If you are looking trough this code and want to mod the game, my target is acomplished
		^-^
--]]	

--Blocks table
blocks = {
	
	-- How many blocks are there in the game and other stuff
	count = 5,
	max_size_x = 4,
	max_size_y = 4,
	
	-- Block data of each individual block
	block_data = {
		
		-- 1
		{
			frames = 4,
			size_x = 4,
			size_y = 4,
			{
				{0, 0, 0, 0},
				{1, 1, 1, 1},
				{0, 0, 0, 0},
				{0, 0, 0, 0},
			},
			{
				{0, 0, 1, 0},
				{0, 0, 1, 0},
				{0, 0, 1, 0},
				{0, 0, 1, 0},
			},
			{
				{0, 0, 0, 0},
				{0, 0, 0, 0},
				{1, 1, 1, 1},
				{0, 0, 0, 0},
			},
			{
				{0, 1, 0, 0},
				{0, 1, 0, 0},
				{0, 1, 0, 0},
				{0, 1, 0, 0},
			},
		},
		
		-- 2
		{
			frames = 4,
			size_x = 3,
			size_y = 3,
			{
				{0, 0, 1},
				{1, 1, 1},
				{0, 0, 0},
			},
			{
				{0, 1, 0},
				{0, 1, 0},
				{0, 1, 1},
			},
			{
				{0, 0, 0},
				{1, 1, 1},
				{1, 0, 0},
			},
			{
				{1, 1, 0},
				{0, 1, 0},
				{0, 1, 0},
			},
		},
		
		-- 3
		{
			frames = 4,
			size_x = 3,
			size_y = 3,
			{
				{1, 0, 0},
				{1, 1, 1},
				{0, 0, 0},
			},
			{
				{0, 1, 1},
				{0, 1, 0},
				{0, 1, 0},
			},
			{
				{0, 0, 0},
				{1, 1, 1},
				{0, 0, 1},
			},
			{
				{0, 0, 1},
				{0, 0, 1},
				{0, 1, 1},
			},
		},
		
		-- 4
		{
			frames = 1,
			size_x = 2,
			size_y = 2,
			{
				{1, 1},
				{1, 1},
			},
		},
		
		-- 5
		{
			frames = 4,
			size_x = 3,
			size_y = 3,
			{
				{0, 1, 1},
				{1, 1, 0},
				{0, 0, 0},
			},
			{
				{0, 1, 0},
				{0, 1, 1},
				{0, 0, 1},
			},
			{
				{0, 0, 0},
				{0, 1, 1},
				{1, 1, 0},
			},
			{
				{1, 0, 0},
				{1, 1, 0},
				{0, 1, 0},
			},		
		},
	},
}


