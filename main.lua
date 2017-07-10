require "Tank"
--灰机
function love.load()	
	speed = 100

	Target={
		50,50,
		100,50,
		100,60,
		50,60
	}
										--The table that contains all bullets.
	hitFlag=false;
end

function love.draw()
	Tank.draw()

	--画靶子
	love.graphics.origin()
	love.graphics.polygon('fill', Target)
	-- lorve.graphics.polygon('line',100,100,120,158,137,49,143,166,180,122,163,152)

	love.graphics.circle("line", 300, 300, 30, 4)
end

function rotateGraph(posX,posY,angle)
	love.graphics.translate(posX, posY)--设定初始位置
	love.graphics.rotate(angle)--从该位置进行旋转
	love.graphics.translate(-posX, -posY)--返回初始位置
end

function keyboardLinstener(dt)
	if love.keyboard.isDown("a") then
		if love.keyboard.isDown("w") then
			Tank.bodyA = Tank.bodyA - dt * math.pi/2
			Tank.bodyA = Tank.bodyA % (2*math.pi)
		elseif love.keyboard.isDown("s") then
			Tank.bodyA = Tank.bodyA + dt * math.pi/2
			Tank.bodyA = Tank.bodyA % (2*math.pi)
		end
	end
	if love.keyboard.isDown("d") then
		if love.keyboard.isDown("w") then
			Tank.bodyA = Tank.bodyA + dt * math.pi/2
			Tank.bodyA = Tank.bodyA % (2*math.pi)
		elseif love.keyboard.isDown("s") then
			Tank.bodyA = Tank.bodyA - dt * math.pi/2
			Tank.bodyA = Tank.bodyA % (2*math.pi)
		end
	end
	if love.keyboard.isDown("w") then
		Tank.move(-1,dt)
	end
	if love.keyboard.isDown("s") then
		Tank.move(1,dt)
	end
	if love.keyboard.isDown("q") then
		Tank.headA = Tank.headA - dt * math.pi/2
		Tank.headA = Tank.headA % (2*math.pi)
	end
	if love.keyboard.isDown("e") then
		Tank.headA = Tank.headA + dt * math.pi/2
		Tank.headA = Tank.headA % (2*math.pi)
	end
end

function checkHit()
	for i,v in pairs(Tank.bullets) do
		if v.y>=50 and v.y<=60 then
			if v.x>=Target[1] and v.x<=Target[3] then
				Target[1]=0		
				Target[2]=0
				Target[3]=0
				Target[4]=0
				Target[5]=0
				Target[6]=0
				Target[7]=0
				Target[8]=0
				hitFlag=true
			end
		end
	end
end

function love.keyreleased(key)
   if key == "j" then
      	Tank.fire()
   elseif key == "k" then
   		Tank.bulletsCount=Tank.maxbs
   	elseif key=="r" then 
   		Target={
			50,50,
			100,50,
			100,60,
			50,60
		}
		hitFlag=false
   	end
end

function love.update(dt)
	keyboardLinstener(dt)
	for i,v in pairs(Tank.bullets) do
		local shootAngle=math.atan2((Tank.fireY - Tank.centerY), (Tank.fireX+Tank.fireW/2 - Tank.centerX))
		local Dx = speed* math.cos(shootAngle) 		--Physics: deltaX is the change in the x direction.
		local Dy = speed* math.sin(shootAngle)
		v.x = v.x + (Dx * dt)
		v.y = v.y + (Dy * dt)
		local length=math.sqrt((v.y-v.cy)^2+(v.x-v.cx)^2)
		--以下这段代码决定了射程
		if length>Tank.maxshoot then
			table.remove(Tank.bullets,i)
		end
		checkHit()
	end
	if hitFlag~=true then
		Target[1]=Target[1]+speed*dt;
		Target[3]=Target[3]+speed*dt;
		Target[5]=Target[5]+speed*dt;
		Target[7]=Target[7]+speed*dt;
		if Target[1]>love.graphics.getWidth() then
			Target[1]=50
			Target[3]=100
			Target[5]=100
			Target[7]=50
		end
	end
end