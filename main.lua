HC = require 'HC'
-- test for git
-- array to hold collision messages
local text = {}
local x=300
local y=100
function love.load()
    -- add a rectangle to the scene

    rect = HC.rectangle(x,y,200,20)
    ball = nil
    -- add a circle to the scene
    mouse = HC.circle(400,300,20)
    mouse:moveTo(love.mouse.getPosition())
end

function love.update(dt)
    keyboardListener(dt)
    -- move circle to mouse position
    mouse:moveTo(love.mouse.getPosition())

    -- rotate rectangle
    -- rect:rotate(-dt)

    -- check for collisions
    for shape, delta in pairs(HC.collisions(mouse)) do
        rect:rotate(-dt) -- stop the rect rotation
    end


    while #text > 40 do
        table.remove(text, 1)
    end
    text[#text+1] = rect:rotation()..","..x..","..y

end

function keyboardListener(dt)
    if love.keyboard.isDown("q") then
        rect:rotate(dt,x,y+10)
        -- rect:setRotation(dt,200,400)
    end
    if love.keyboard.isDown("e") then
        -- angle = rect:rotation() % (2*math.pi)
        y = y + dt*50
        rect:move(0,dt*50)

    end
end

function love.draw()
    -- print messages
    for i = 1,#text do
        love.graphics.setColor(255,255,255, 255 - (i-1) * 6)
        love.graphics.print(text[#text - (i-1)], 10, i * 15)
    end

    -- shapes can be drawn to the screen
    love.graphics.setColor(255,255,255)
    rect:draw('fill')
    mouse:draw('fill')
    if ball ~= nil then
        ball:draw('fill')
    end
end
