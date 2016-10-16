function love.load()	
	speed = 100
	bodyX=250
	bodyY=250 
	bodyW=40 
	bodyH=50
	centerX=bodyX+bodyW/2
	centerY=bodyY+bodyH/2
	Tank={bodyA=0,headA=0,headR=15,headS=6,fireW=5,fireH=40,speed=50,bullets=10} --headR:坦克脑袋半径，headS:坦克脑袋边数
	fireX=centerX-Tank.fireW/2
	fireY=centerY-Tank.fireH-math.cos(math.pi/6)*Tank.headR
	bullets={}										--The table that contains all bullets.
end

function love.draw()
	--输出子弹个数
	love.graphics.print("BULLETS:> "..Tank.bullets,500,200)

	--Sets the color to red and draws the "bullets".
	love.graphics.setColor(255, 0, 0)
	
	--This loops the whole table to get every bullet. Consider v being the bullet.
	for i,v in pairs(bullets) do
		love.graphics.circle("fill", v.x, v.y, 4,4)
	end
	

	love.graphics.push();
	roateTank(centerX,centerY,Tank.bodyA);
	love.graphics.push()
	love.graphics.pop()
	--Sets the color to white and draws the "player" and writes instructions.
	love.graphics.setColor(255, 255, 255)	
	love.graphics.rectangle("line", bodyX, bodyY, bodyW, bodyH)
	love.graphics.pop()
	-- resetAngle();
	roateTank(centerX,centerY,Tank.headA)
	love.graphics.circle("line", centerX, centerY, Tank.headR, Tank.headS)
	love.graphics.rectangle("line",fireX,fireY,Tank.fireW,Tank.fireH)

end

function roateTank(posX,posY,angle)
	love.graphics.translate(posX, posY)--设定初始位置
	love.graphics.rotate(angle)--从该位置进行旋转
	love.graphics.translate(-posX, -posY)--返回初始位置
end

function resetAngle()
	love.graphics.translate(0,0)
end

function moveTank(dir,dt)
	bodyY=bodyY+dir*dt*Tank.speed
	centerY=centerY+dir*dt*Tank.speed
	fireY=fireY+dir*dt*Tank.speed
end

function tankFire()
	local startX = fireX+Tank.fireW/2
	local startY = fireY
		
	local targetX, targetY = startX,startY-1
	  
	--Basic maths and physics, calculates the angle so the code can calculate deltaX and deltaY later.
	local angle = math.atan2((targetY - startY), (targetX - startX))
		
	--Creates a new bullet and appends it to the table we created earlier.
	if(Tank.bullets>0) then
		newbullet={x=startX,y=startY,angle=angle}
		table.insert(bullets,newbullet)
		Tank.bullets=Tank.bullets-1
	end
end

function keyboardLinstener(dt)
	if love.keyboard.isDown("a") then
		Tank.bodyA = Tank.bodyA - dt * math.pi/2
		Tank.bodyA = Tank.bodyA % (2*math.pi)
	elseif love.keyboard.isDown("d") then
		Tank.bodyA = Tank.bodyA + dt * math.pi/2
		Tank.bodyA = Tank.bodyA % (2*math.pi)
	elseif love.keyboard.isDown("w") then
		moveTank(-1,dt)
	elseif love.keyboard.isDown("s") then
		moveTank(1,dt)
	elseif love.keyboard.isDown("q") then
		Tank.headA = Tank.headA - dt * math.pi/2
		Tank.headA = Tank.headA % (2*math.pi)
	elseif love.keyboard.isDown("e") then
		Tank.headA = Tank.headA + dt * math.pi/2
		Tank.headA = Tank.headA % (2*math.pi)
	end
end

function love.keyreleased(key)
   if key == "j" then
      	tankFire()
   elseif key == "k" then
   		Tank.bullets=10
   	end
end

function love.update(dt)
	keyboardLinstener(dt)
	for i,v in pairs(bullets) do
		local Dx = speed * math.cos(v.angle)		--Physics: deltaX is the change in the x direction.
		local Dy = speed * math.sin(v.angle)
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