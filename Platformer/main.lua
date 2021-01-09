--[[
    Platform game with animation and love
    @credited to Lua Programming and Game Development with LÖVE (udemy)
]]

function love.load()
    -- import the windfield and animation lib
    anim8 = require 'libraries.anim8.anim8'
    wf = require 'libraries.windfield.windfield'
    
    world = wf.newWorld(0,800, false)
    world:setQueryDebugDrawing(true)

    sprites = {}
    sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')

    local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())

    animations = {}
    animations.idle = anim8.newAnimation(grid('1-15',1), 0.05)
    animations.jump = anim8.newAnimation(grid('1-7',2), 0.05)
    animations.run = anim8.newAnimation(grid('1-15',3), 0.05)

    -- add collision to physics objects
    world:addCollisionClass('Platform')
    world:addCollisionClass('Player'--[[,{ignores = {'Platform'}} ]])
    world:addCollisionClass('Danger')

    require('player')

    platform = world:newRectangleCollider(250,400,300,100,{collision_class='Platform'})
    platform:setType('static')

    dangerZone = world:newRectangleCollider(0,550,800,50,{collision_class='Danger'})
    dangerZone:setType('static')

end

function love.update(dt)
    world:update(dt)
    playerUpdate(dt)
    

end

function love.draw()
    world:draw()
    playerDraw()
    
end

function love.keypressed(key)
    if key == 'up' then
        if player.grounded then
            player:applyLinearImpulse(0, -4000)
            --player.animation = animations.jump
        end

    end
end