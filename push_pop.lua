function love.draw()
   love.graphics.push()   -- stores the coordinate system
     love.graphics.scale(0.5, 0.5)   -- reduce everything by 50% in both X and Y coordinates
     love.graphics.print("Scaled text", 50, 50)   -- print half-sized text at 25x25
     love.graphics.push()
       love.graphics.origin()  -- Rest the state to the defaults.
       -- love.graphics.draw(image, 0, 0) -- Draw the image on screen as if nothing was scaled.
     love.graphics.pop()   -- return to our scaled coordinate state.
     --pop之前必有push，默认栈是空的
     love.graphics.print("Scaled text", 100, 100)   -- print half-sized text at 50x50
   love.graphics.pop()   -- return to the previous stored coordinated
   love.graphics.print("Normal text", 150, 150)
end