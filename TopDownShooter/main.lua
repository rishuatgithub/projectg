--[[
    Top down shooter game
    @credited to Lua Programming and Game Development with LÖVE (udemy)

]]

function love.load()

    math.randomseed(os.time())

    sprites = {}
    sprites.background = love.graphics.newImage('sprites/background.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')

    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.speed = 3*60

    zombies = {}
    bullets = {}

    gameFont = love.graphics.newFont(30)

    gameState = 1
    maxTime = 2
    timer = maxTime

    score = 0

end

function love.update(dt)
    if gameState == 2 then
        if love.keyboard.isDown('d') and player.x < love.graphics.getWidth() then
            player.x = player.x + player.speed*dt
        end
        if love.keyboard.isDown('a') and player.x > 0 then
            player.x = player.x - player.speed*dt
        end
        if love.keyboard.isDown('s') and player.y < love.graphics.getHeight() then
            player.y = player.y + player.speed*dt
        end
        if love.keyboard.isDown('w') and player.y > 0 then
            player.y = player.y - player.speed*dt
        end
    end

    for i, z in ipairs(zombies) do 
        -- make the zombies move towards the player at every frame
        z.x = z.x + (math.cos(zombieMouseAngel(z)) * z.speed * dt)
        z.y = z.y + (math.sin(zombieMouseAngel(z)) * z.speed * dt)

        -- basic collision
        if distanceBetween(z.x, z.y, player.x, player.y) < 30 then
            for i, z in ipairs(zombies) do
                zombies[i] = nil  -- delete the zombies on collision with the players
                gameState = 1
                player.x = love.graphics.getWidth()/2
                player.y = love.graphics.getHeight()/2
            end
        end

    end

    -- update the direction of the bullets at every frame
    for i, b in ipairs(bullets) do 
        b.x = b.x + (math.cos(b.direction) * b.speed * dt)
        b.y = b.y + (math.sin(b.direction) * b.speed * dt)
    end

    -- remove the bullets from table if it moves out of screen (must have to improve memory)
    -- delete from the last element of the table. Hence -1
    for i=#bullets, 1, -1 do
        local b = bullets[i]
        if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end

    -- if the bullet and zombie hit, then set the dead property to true
    for i, z in ipairs(zombies) do 
        for j,b in ipairs(bullets) do  
            if distanceBetween(z.x, z.y, b.x, b.y) < 20 then
                z.dead = true
                b.dead = true
                score = score + 1
            end
        end
    end

    -- remove the zombies from the table if the dead property is true
    for i=#zombies,1,-1 do
        local z = zombies[i]
        if z.dead == true then
            table.remove(zombies, i)
        end
    end

     -- remove the bulltets from the table if the dead property is true
     for i=#bullets,1,-1 do
        local b = bullets[i]
        if b.dead == true then
            table.remove(bullets, i)
        end
    end

    if gameState == 2 then
        timer = timer - dt
        if timer <= 0 then
            spawnZombie()
            maxTime = 0.95 * maxTime
            timer = maxTime
        end
    end



end


function love.draw()

    love.graphics.draw(sprites.background,0,0)

    if gameState==1 then
        love.graphics.setFont(gameFont)
        love.graphics.printf("Click anywhere to begin!!!", 0, 50, love.graphics.getWidth(), "center")
    end
    love.graphics.printf("Score: "..score,0, love.graphics.getHeight()-100, love.graphics.getWidth(), "center")

    love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngel(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)

    for i, z in ipairs(zombies) do
        love.graphics.draw(sprites.zombie, z.x, z.y, zombieMouseAngel(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
    end

    for i, b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x, b.y, nil, 0.5, 0.5, sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
    end
end

--[[ temp function to spawn a zombie based on keypress = SPACE
function love.keypressed(key)
    if key == 'space' then
        spawnZombie()
    end
end
]]

-- set the player and mouse position in the same direction
function playerMouseAngel()
    return math.atan2((player.y - love.mouse.getY()),(player.x - love.mouse.getX()) ) + math.pi
end

-- set the player and zombie position in the same direction
function zombieMouseAngel(enemy)
    return math.atan2((player.y - enemy.y),(player.x - enemy.x))
end

-- based on left click spawn a bullet from the player
function love.mousepressed(x,y,button)
    if button == 1 and gameState==2 then
        spawnBullet()
    elseif button == 1 and gameState==1 then
        gameState = 2
        maxTime = 2
        timer = maxTime
        score = 0
    end
end


-- spawn a single zombie
function spawnZombie()
    local zombie = {}
    zombie.x = 0
    zombie.y = 0
    zombie.speed = 140
    zombie.dead = false

    local side = math.random(1,4) -- select the side of the screen where the zombies will spawn
    if side == 1 then -- left side
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then -- right side
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 3 then -- top side
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -30
    elseif side == 4 then -- bottom side
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 30
    end
    
    table.insert(zombies, zombie) -- insert the single zombie into the zombies table
end

-- spawn a bullet
function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 500
    bullet.direction = playerMouseAngel()
    bullet.dead = false

    table.insert(bullets, bullet)
end

-- calculate the distance
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end