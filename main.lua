function love.load()	
	speed = 10
	bodyX=250
	bodyY=250 
	bodyW=40 
	bodyH=50
	centerX=bodyX+bodyW/2
	centerY=bodyY+bodyH/2
	Tank={angle=0,headR=15,headS=6,fireW=5,fireH=40} --headR:坦克脑袋半径，headS:坦克脑袋边数
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
	
	roateTank(centerX,centerY);
	--Sets the color to white and draws the "player" and writes instructions.
	love.graphics.setColor(255, 255, 255)	
	love.graphics.rectangle("line", bodyX, bodyY, bodyW, bodyH)

	-- resetAngle();
	love.graphics.circle("line", centerX, centerY, Tank.headR, Tank.headS)
	love.graphics.rectangle("line",fireX,fireY,Tank.fireW,Tank.fireH)
end

function roateTank(posX,posY)
	love.graphics.translate(posX, posY)--设定初始位置
	love.graphics.rotate(Tank.angle)--从该位置进行旋转
	love.graphics.translate(-posX, -posY)--返回初始位置
end

function resetAngle()
	love.graphics.translate(0,0)
end

function moveTank(dir,dt)
	bodyY=bodyY+dir*dt*speed
	centerY=centerY+dir*dt*speed
	fireY=fireY+dir*dt*speed
end

function keyboardLinstener(dt)
	if love.keyboard.isDown("a") then
		Tank.angle = Tank.angle - dt * math.pi/2
		Tank.angle = Tank.angle % (2*math.pi)
	elseif love.keyboard.isDown("d") then
		Tank.angle = Tank.angle + dt * math.pi/2
		Tank.angle = Tank.angle % (2*math.pi)
	elseif love.keyboard.isDown("w") then
		moveTank(-1,dt)
	elseif love.keyboard.isDown("s") then
		moveTank(1,dt)
	elseif love.keyboard.isDown("q") then
		-- roateTank
	elseif love.keyboard.isDown("e") then
		-- roateTank
	end
end

function love.update(dt)
	keyboardLinstener(dt)
	-- love.timer.sleep(.01)
	-- Tank.angle = Tank.angle + dt * math.pi/2
	-- Tank.angle = Tank.angle % (2*math.pi)
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