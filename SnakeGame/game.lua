
GameStates = {pause='pause', running='running', game_over='game over'}
state = GameStates.running

local snakeX = 15
local snakeY = 15
local dirX = 0
local dirY = 0

local SIZE = 30
local appleX = 0
local appleY = 0
local tail = {}

cellSize  = SIZE -- Width and height of cells.
gridLines = {}

local windowWidth, windowHeight = love.graphics.getDimensions()


up = false
down = false
left = false
right = false

tail_length = 0

function add_apple()
    math.randomseed(os.time())
    appleX = math.random(SIZE-1)
    appleY = math.random(SIZE-1)
end

function game_draw()
-- Vertical lines.
    for x = cellSize, windowWidth, cellSize do
	local line = {x, 0, x, windowHeight}
	table.insert(gridLines, line)
    end
-- Horizontal lines.
    for y = cellSize, windowHeight, cellSize do
	local line = {0, y, windowWidth, y}
	table.insert(gridLines, line)
    end
    
    love.graphics.setColor(0.25, 1.0, 0, 1.0) -- draw snake head
    love.graphics.rectangle("fill", snakeX * SIZE, snakeY * SIZE, SIZE, SIZE)

    love.graphics.setColor(0.5, 0.8, 0, 1.0)
    for _, v in ipairs(tail) do
        love.graphics.rectangle('fill', v[1]*SIZE, v[2]*SIZE, SIZE, SIZE)
    end

    love.graphics.setColor(1.0, 0.25, 0.0, 1.0) -- draw apple
    love.graphics.rectangle('fill', appleX*SIZE, appleY*SIZE, SIZE, SIZE, SIZE/2, SIZE/2)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Score: '.. tail_length, 10, 10,0, 1.5, 1.5)
end

function game_update()
    if up and dirY == 0 then
        dirX, dirY = 0, -1
    elseif down and dirY == 0 then
        dirX, dirY = 0, 1
    elseif left and dirX == 0 then
        dirX, dirY = -1, 0
    elseif right and dirX == 0 then
        dirX, dirY = 1, 0
    end

    local oldX = snakeX
    local oldY = snakeY

    snakeX = snakeX + dirX
    snakeY = snakeY + dirY

    if snakeX == appleX and snakeY == appleY then
        add_apple()
        tail_length = tail_length+1
        table.insert(tail, {0,0})
    end

    if snakeX < 0 then
        state = GameStates.game_over
    elseif snakeX > SIZE - 1 then
        state = GameStates.game_over
    elseif snakeY < 0 then
        state = GameStates.game_over
    elseif snakeY > SIZE - 1 then
        state = GameStates.game_over
    end

    if tail_length > 0 then
        for _, v in ipairs(tail) do
            local x, y = v[1], v[2]
            v[1], v[2] = oldX, oldY
            oldX, oldY = x, y
        end
    end

    for _, v in ipairs(tail) do
        if snakeX == v[1] and snakeY ==v[2] then
            state = GameStates.game_over
        end
    end
end

function game_restart()
    snakeX, snakeY = 15, 15
    dirX, dirY = 0, 0
    tail = {}
    up, down, left, right = false, false, false, false
    tail_length = 0
    state = GameStates.running
    add_apple()
end
