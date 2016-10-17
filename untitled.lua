function love.load()
	Tank={
		speed=50,	--坦克移动速度
		bodyW=40,	--坦克身体宽度
		bodyH=50,	--坦克身体长度
		headR=15,	--坦克头部半径
		headS=6,	--坦克头部边数
		fireW=5,	--炮管宽度
		fireH=40,	--炮管长度
		bullets=10,	--子弹个数
		maxbs=10	--最大子弹数目
	}	
	speed = 100
	bodyX=250
	bodyY=250 
	bodyW=40 
	bodyH=50
	centerX=bodyX+bodyW/2
	centerY=bodyY+bodyH/2
	fireX=centerX-Tank.fireW/2
	fireY=centerY-Tank.fireH-math.cos(math.pi/6)*Tank.headR
	bullets={}										--The table that contains all bullets.
end

function love.draw()

	for i,v in pairs(bullets) do
		love.graphics.circle("line", v.x, v.y, 4,10)
	end

	--输出子弹个数
	love.graphics.print("BULLETS:> "..Tank.bullets,500,200)
	love.graphics.print("Tank body Angle:> "..Tank.bodyA,500,250)
	love.graphics.print("Tank head Agnle:> "..Tank.headA,500,300)
	love.graphics.print("fireX: "..fireX.." fireY: "..fireY,500,350)
	love.graphics.print("targetX: "..fireX+Tank.fireW/2 +Tank.fireH*math.sin(Tank.headA),500,400)
	love.graphics.print("targetY: "..fireY+Tank.fireH -Tank.fireH*math.cos(Tank.headA),500,450)
	--Sets the color to red and draws the "bullets".
	love.graphics.setColor(255, 255, 255)
	
	

	love.graphics.push();
	roateTank(centerX,centerY,Tank.bodyA);
	love.graphics.push()
	love.graphics.pop()
	love.graphics.rectangle("line", bodyX, bodyY, bodyW, bodyH)
	love.graphics.pop()

	-- roateTank(centerX,centerY,Tank.headA)
	-- love.graphics.push()
	love.graphics.circle("line", centerX, centerY, Tank.headR, Tank.headS)
	love.graphics.rectangle("line",fireX,fireY,Tank.fireW,Tank.fireH)
	-- love.graphics.rectangle("fill",fireX+Tank.fireW/2 +Tank.fireH*math.sin(Tank.headA),
		-- fireY+Tank.fireH -Tank.fireH*math.cos(Tank.headA),Tank.fireW,Tank.fireH)
	-- love.graphics.pop()
	-- giving the coordinates directly
love.graphics.polygon('line', 300, 100, 200, 100, 150, 200,600,300)
 
-- defining a table with the coordinates
-- this table could be built incrementally too
local vertices = {100, 100, 200, 100, 150, 200}
 
-- passing the table to the function as a second argument
love.graphics.polygon('fill', vertices)

end

function roateTank(posX,posY,angle)
	love.graphics.translate(posX, posY)--设定初始位置
	love.graphics.rotate(angle)--从该位置进行旋转
	love.graphics.translate(-posX, -posY)--返回初始位置
end

function rotateBuilet(angle)
	love.graphics.translate(centerX,centerY)
	love.graphics.rotate(angle)
	love.graphics.translate(-centerX,-centerY)
end

function moveTank(dir,dt)
	bodyY=bodyY+dir*dt*Tank.speed*math.cos(Tank.bodyA)
	centerY=centerY+dir*dt*Tank.speed*math.cos(Tank.bodyA)
	fireY=fireY+dir*dt*Tank.speed*math.cos(Tank.bodyA)
	if Tank.bodyA~=0 then
		bodyX=bodyX-dir*dt*Tank.speed*math.sin(Tank.bodyA)
		centerX=centerX-dir*dt*Tank.speed*math.sin(Tank.bodyA)
		fireX=fireX-dir*dt*Tank.speed*math.sin(Tank.bodyA)
	end
end

function tankFire()
	local targetX = fireX+Tank.fireW/2 +Tank.fireH*math.sin(Tank.headA)
	local targetY = fireY+Tank.fireH -Tank.fireH*math.cos(Tank.headA)
	  
	--Basic maths and physics, calculates the angle so the code can calculate deltaX and deltaY later.
	local angle =  math.atan2((targetY - centerY), (targetX - centerX))
		
	--Creates a new bullet and appends it to the table we created earlier.
	if(Tank.bullets>0) then
		newbullet={x=targetX,y=targetY,angle=angle}
		table.insert(bullets,newbullet)
		Tank.bullets=Tank.bullets-1
	end
end

function keyboardLinstener(dt)
	if love.keyboard.isDown("a") then
		Tank.bodyA = Tank.bodyA - dt * math.pi/2
		Tank.bodyA = Tank.bodyA % (2*math.pi)
	end
	if love.keyboard.isDown("d") then
		Tank.bodyA = Tank.bodyA + dt * math.pi/2
		Tank.bodyA = Tank.bodyA % (2*math.pi)
	end
	if love.keyboard.isDown("w") then
		moveTank(-1,dt)
	end
	if love.keyboard.isDown("s") then
		moveTank(1,dt)
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

function love.keyreleased(key)
   if key == "j" then
      	tankFire()
   elseif key == "k" then
   		Tank.bullets=Tank.maxbs
   	end
end

function love.update(dt)
	keyboardLinstener(dt)
	for i,v in pairs(bullets) do
		local Dx = speed * math.cos(v.angle)		--Physics: deltaX is the change in the x direction.
		local Dy = speed * math.sin(v.angle)
		v.x = v.x + (Dx * dt)
		v.y = v.y + (Dy * dt)	
		--以下这段代码决定了射程
		if v.x > love.graphics.getWidth() or
		   v.y > love.graphics.getHeight() or
		   v.x < 0 or
		   v.y < 0 then
			table.remove(bullets,i)
		end
	end
end