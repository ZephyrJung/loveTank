function love.load()	
	speed = 100
	bodyX=250
	bodyY=250 
	bodyW=40 
	bodyH=50
	centerX=bodyX+bodyW/2
	centerY=bodyY+bodyH/2
	Tank={
		bodyA=0,	--坦克躯干角度
		headA=0,	--坦克头部角度
		bulletA=0,	--子弹发射角度
		headR=15,	--坦克头部半径
		headS=6,	--坦克头部边数
		fireW=5,	--炮管宽度
		fireH=40,	--炮管长度
		speed=50,	--坦克移动速度
		bullets=10000,	--坦克子弹个数
		maxbs=10000,	--最大子弹个数
		maxshoot=500,
		bulletSize=4
	} --headR:坦克脑袋半径，headS:坦克脑袋边数
	Target={
		50,50,
		100,50,
		100,60,
		50,60
	}
	fireX=centerX-Tank.fireW/2
	fireY=centerY-Tank.fireH-math.cos(math.pi/6)*Tank.headR
	bullets={}										--The table that contains all bullets.
	hitFlag=false;
end

function love.draw()
	--输出子弹个数
	love.graphics.print("BULLETS:> "..Tank.bullets,500,200)
	love.graphics.print("Tank body Angle:> "..Tank.bodyA,500,250)
	love.graphics.print("Tank head Agnle:> "..Tank.headA,500,300)
	love.graphics.print("fireX: "..fireX.." fireY: "..fireY,500,350)
	love.graphics.print("targetX: "..fireX+Tank.fireW/2 +Tank.fireH*math.sin(Tank.headA),500,400)
	love.graphics.print("targetY: "..fireY+Tank.fireH -Tank.fireH*math.cos(Tank.headA),500,450)
	--Sets the color to red and draws the "bullets".
	love.graphics.setColor(255, 255, 255)
	
	--画坦克躯干
	love.graphics.origin()
	rotateGraph(centerX,centerY,Tank.bodyA);
	love.graphics.rectangle("line", bodyX, bodyY, bodyW, bodyH)

	--画坦克头部
	love.graphics.origin()
	rotateGraph(centerX,centerY,Tank.headA)
	love.graphics.circle("line", centerX, centerY, Tank.headR, Tank.headS)
	love.graphics.rectangle("line",fireX,fireY,Tank.fireW,Tank.fireH)

	--画子弹
	for i,v in pairs(bullets) do
		love.graphics.origin()
		-- rotateBuilet(v.angle)
		rotateGraph(v.cx,v.cy,v.angle)
		love.graphics.circle("line", v.x, v.y,Tank.bulletSize,10)
	end

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
	
	local targetX = fireX+Tank.fireW/2 
	local targetY = fireY
	  
	--Creates a new bullet and appends it to the table we created earlier.
	if(Tank.bullets>0) then
		newbullet={x=targetX,y=targetY,angle=Tank.headA,cx=centerX,cy=centerY}
		table.insert(bullets,newbullet)
		Tank.bullets=Tank.bullets-1
	end
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

function checkHit()
	for i,v in pairs(bullets) do
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
      	tankFire()
   elseif key == "k" then
   		Tank.bullets=Tank.maxbs
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
	for i,v in pairs(bullets) do
		local shootAngle=math.atan2((fireY - centerY), (fireX+Tank.fireW/2 - centerX))
		local Dx = speed* math.cos(shootAngle) 		--Physics: deltaX is the change in the x direction.
		local Dy = speed* math.sin(shootAngle)
		v.x = v.x + (Dx * dt)
		v.y = v.y + (Dy * dt)
		local length=math.sqrt((v.y-v.cy)^2+(v.x-v.cx)^2)
		--以下这段代码决定了射程
		if length>Tank.maxshoot then
			table.remove(bullets,i)
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