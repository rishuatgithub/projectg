message = "Lua is awesome !!!" -- creating a variable
message_int = 5

if message_int == 5 then
    message = "Condition met."
end



function love.draw()
    love.graphics.setFont(love.graphics.newFont(50)) -- making the text size larger
    love.graphics.print(message)
end