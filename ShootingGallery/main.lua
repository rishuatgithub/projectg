--[[
    Shooting gallery game
    @credited to Lua Programming and Game Development with LÖVE (udemy)
]]

function love.load()
    -- number = 0
    target = {}
    target.x=300
    target.y=200
    target.radius=50

    score=0
    timer=0
    gameState=1

    gameFont = love.graphics.newFont(40)

    sprites = {}
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.target = love.graphics.newImage('sprites/target.png')
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')

    love.mouse.setVisible(false)

end

function love.update(dt)
    -- number = number + 1
    if timer > 0 then
        timer = timer - dt
    end
    
    if timer < 0 then
        timer = 0
        gameState = 1
    end
end

function love.draw()
    -- love.graphics.print(number)
    -- love.graphics.setColor(0,0,1)
    -- love.graphics.rectangle("fill",200,250,200,100)

    -- love.graphics.setColor(204/255, 51/255, 255/255)
    --love.graphics.circle("fill",300,200,100,100)

    -- draw the background
    love.graphics.draw(sprites.sky,0,0)

    -- drawing the circle
    -- love.graphics.setColor(1,0,0)
    -- love.graphics.circle("fill",target.x,target.y, target.radius)

    -- printing the score
    love.graphics.setColor(1,1,1) -- white
    love.graphics.setFont(gameFont)
    love.graphics.print("Score: "..score, 5, 5) 
    love.graphics.print("Timer: "..math.ceil(timer), 300, 5)

    if gameState == 1 then
        love.graphics.printf("Click anywhere to begin !!!",0,250,love.graphics.getWidth(),"center")
    end

    if gameState == 2 then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end

    love.graphics.draw(sprites.crosshairs, love.mouse.getX()-20, love.mouse.getY()-20)

end

-- for handling mouse press by the user.
function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and gameState == 2 then
        local mouseToPressed = distanceBetween(x,y, target.x, target.y)
        if mouseToPressed < target.radius then
            score = score + 1

            -- put some randomnees to the code
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)

        end  
    elseif button == 1 and gameState ==1 then
        gameState = 2
        timer = 10
        score = 0
    end      
    
end

-- calculate the distance
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end
