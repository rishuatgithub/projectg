message = "Lua is awesome !!!" -- creating a variable
message_int = 5
counter = 0

if message_int == 5 then
    message = "Condition met."
end

-- loops

for i=1,3,1 do
    message_int = message_int+10
end

-- functions

function incrementCounter(i)
    counter = counter + i
end

function incrementCounter2()
    val = 100
    return val
end

incrementCounter(10)
incrementCounter(10)

counter = incrementCounter2()

-- comment
-- use double dash

-- for multiple line comment use: --[[]]
-- eg.
--[[
    function commented()
    end
]]


-- tables

mytables = {} -- empty table

table.insert(mytables, 10)
table.insert(mytables, 20)
table.insert(mytables, 30)

counter = mytables[1]

-- iterate in a table
result = 0
for i,n in ipairs(mytables) do
    --local result = 0
    result = result + n
    --return result
end

counter = result

function love.draw()
    love.graphics.setFont(love.graphics.newFont(50)) -- making the text size larger
    love.graphics.print(counter)
end