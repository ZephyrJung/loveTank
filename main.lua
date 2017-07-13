require "Tank"
require "Target"
--灰机
function love.load()	
	speed = 100
	hitFlag=false;
end

function love.draw()
	Tank.draw()

	--画靶子
	love.graphics.origin()
	Target.draw(Target.normal)
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
			Tank.body.angle = Tank.body.angle - dt * math.pi/2
			Tank.body.angle = Tank.body.angle % (2*math.pi)
		elseif love.keyboard.isDown("s") then
			Tank.body.angle = Tank.body.angle + dt * math.pi/2
			Tank.body.angle = Tank.body.angle % (2*math.pi)
		end
	end
	if love.keyboard.isDown("d") then
		if love.keyboard.isDown("w") then
			Tank.body.angle = Tank.body.angle + dt * math.pi/2
			Tank.body.angle = Tank.body.angle % (2*math.pi)
		elseif love.keyboard.isDown("s") then
			Tank.body.angle = Tank.body.angle - dt * math.pi/2
			Tank.body.angle = Tank.body.angle % (2*math.pi)
		end
	end
	if love.keyboard.isDown("w") then
		Tank.move(-1,dt)
	end
	if love.keyboard.isDown("s") then
		Tank.move(1,dt)
	end
	if love.keyboard.isDown("q") then
		Tank.head.angle = Tank.head.angle - dt * math.pi/2
		Tank.head.angle = Tank.head.angle % (2*math.pi)
	end
	if love.keyboard.isDown("e") then
		Tank.head.angle = Tank.head.angle + dt * math.pi/2
		Tank.head.angle = Tank.head.angle % (2*math.pi)
	end
end

function checkHit()
	for i,v in pairs(Tank.bullets) do
		if v.y>=50 and v.y<=60 then
			if v.x>=Target.normal[1] and v.x<=Target.normal[3] then
				Target.normal[1]=0		
				Target.normal[2]=0
				Target.normal[3]=0
				Target.normal[4]=0
				Target.normal[5]=0
				Target.normal[6]=0
				Target.normal[7]=0
				Target.normal[8]=0
				hitFlag=true
			end
		end
	end
end

function love.keyreleased(key)
   if key == "j" then
      	Tank.makeFire()
   elseif key == "k" then
   		Tank.bulletsCount=Tank.maxbs
   	elseif key=="r" then 
   		Target.normal={
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
		local shootAngle=math.atan2((Tank.fire.y - Tank.center.y), (Tank.fire.x+Tank.fire.w/2 - Tank.center.x))
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
		-- Target.normal[1]=Target.normal[1]+speed*dt;
		-- Target.normal[3]=Target.normal[3]+speed*dt;
		-- Target.normal[5]=Target.normal[5]+speed*dt;
		-- Target.normal[7]=Target.normal[7]+speed*dt;
		-- if Target.normal[1]>love.graphics.getWidth() then
		-- 	Target.normal[1]=50
		-- 	Target.normal[3]=100
		-- 	Target.normal[5]=100
		-- 	Target.normal[7]=50
		-- end
	end
end