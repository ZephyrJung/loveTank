function love.load()	
	SPEED = 250
	bodyX=250
	bodyY=250 
	bodyW=40 
	bodyH=50
	centerX=bodyX+bodyW/2
	centerY=bodyY+bodyH/2
	Tank={headR=15,headS=6,fireW=5,fireH=40} --headR:坦克脑袋半径，headS:坦克脑袋边数
	fireX=centerX-Tank.fireW/2
	fireY=centerY-Tank.fireH-math.cos(math.pi/6)*Tank.headR
	bullets={}										--The table that contains all bullets.
end

function love.draw()
	--Sets the color to red and draws the "bullets".
	love.graphics.setColor(255, 0, 0)
	
	--This loops the whole table to get every bullet. Consider v being the bullet.
	for i,v in pairs(bullets) do
		love.graphics.circle("fill", v.x, v.y, 4,4)
	end
	
	--Sets the color to white and draws the "player" and writes instructions.
	love.graphics.setColor(255, 255, 255)
	
	love.graphics.print("Left click to fire towards the mouse.", 50, 50)
	love.graphics.rectangle("line", bodyX, bodyY, bodyW, bodyH)
	love.graphics.circle("line", centerX, centerY, Tank.headR, Tank.headS)
	love.graphics.rectangle("line",fireX,fireY,Tank.fireW,Tank.fireH)

	love.graphics.draw(love.graphics.circle("line", 50, 50, 10, 10),x, y,angle)
end

function love.update(dt)
	
	if love.mouse.isDown(1) then
		--Sets the starting position of the bullet, this code makes the bullets start in the middle of the player.
		local startX = fireX+Tank.fireW/2
		local startY = fireY
		
		local targetX, targetY = love.mouse.getPosition()
	  
		--Basic maths and physics, calculates the angle so the code can calculate deltaX and deltaY later.
		local angle = math.atan2((targetY - startY), (targetX - startX))
		
		--Creates a new bullet and appends it to the table we created earlier.
		newbullet={x=startX,y=startY,angle=angle}
		table.insert(bullets,newbullet)
	end
	
	for i,v in pairs(bullets) do
		local Dx = SPEED * math.cos(v.angle)		--Physics: deltaX is the change in the x direction.
		local Dy = SPEED * math.sin(v.angle)
		v.x = v.x + (Dx * dt)
		v.y = v.y + (Dy * dt)
		
		--Cleanup code, removes bullets that exceeded the boundries:
		
		if v.x > love.graphics.getWidth() or
		   v.y > love.graphics.getHeight() or
		   v.x < 0 or
		   v.y < 0 then
			table.remove(bullets,i)
		end
	end
end