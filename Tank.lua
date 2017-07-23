--Tank
--[[
	本文件用于将坦克绘制模块化，预留
	接收参数：
	中心坐标 X，Y（还是躯干左上角坐标？)
	躯干宽度，长度
	头部半径，边数
	炮管宽度，长度
	炮弹半径（边数定为10成圆形)
	炮弹个数
--]]
Tank = {}

Tank.tickCount = 0
Tank.body={}
Tank.body.x=250
Tank.body.y=250
Tank.body.w=40
Tank.body.h=50
Tank.body.angle=0	--坦克躯干角度
Tank.center={}
Tank.center.x=Tank.body.x+Tank.body.w/2
Tank.center.y=Tank.body.y+Tank.body.h/2

Tank.head={}
Tank.head.angle=0	--坦克头部角度
Tank.head.radius=15	--坦克头部半径
Tank.head.edges=6	--坦克头部边数

Tank.bulletA=0	--子弹发射角度

Tank.fire={}
Tank.fire.w=5	--炮管宽度
Tank.fire.h=40	--炮管长度
Tank.fire.x=Tank.center.x-Tank.fire.w/2
Tank.fire.y=Tank.center.y-Tank.fire.h-math.cos(math.pi/6)*Tank.head.radius
Tank.fire.cd=0
Tank.speed=50	--坦克移动速度
Tank.bulletsCount=5	--坦克子弹个数
Tank.maxshoot=500
Tank.bulletSize=4

 --head.radius:head.edges:坦克脑袋边数

Tank.bullets={}	--The table that contains all bullets.
Tank.booms={}

function Tank.draw()
	
	--Sets the color to red and draws the "bullets".
	love.graphics.setColor(255, 255, 255)
	--画坦克躯干
	love.graphics.origin()
	rotateGraph(Tank.center.x,Tank.center.y,Tank.body.angle);
	love.graphics.rectangle("line", Tank.body.x, Tank.body.y, Tank.body.w, Tank.body.h)

	--画坦克头部
	love.graphics.origin()
	rotateGraph(Tank.center.x,Tank.center.y,Tank.head.angle)
	love.graphics.circle("line", Tank.center.x, Tank.center.y, Tank.head.radius, Tank.head.edges)
	love.graphics.rectangle("line",Tank.fire.x,Tank.fire.y,Tank.fire.w,Tank.fire.h)

	--画子弹
	for i,v in pairs(Tank.bullets) do
		love.graphics.origin()
		-- rotateBuilet(v.angle)
		rotateGraph(v.cx,v.cy,v.angle)
		love.graphics.circle("fill", v.x, v.y,Tank.bulletSize)
	end

	--画子弹
	
	for i,v in pairs(Tank.booms) do
		love.graphics.origin()
		rotateGraph(v.cx,v.cy,v.angle)
		love.graphics.circle("line", v.x,v.y,v.r)
	end

	love.graphics.origin()
	love.graphics.print(os.clock(),200,240)
	love.graphics.print(Tank.bulletsCount,200,220)
end

function Tank.move(dir,dt)
	Tank.body.y=Tank.body.y+dir*dt*Tank.speed*math.cos(Tank.body.angle)
	Tank.center.y=Tank.center.y+dir*dt*Tank.speed*math.cos(Tank.body.angle)
	Tank.fire.y=Tank.fire.y+dir*dt*Tank.speed*math.cos(Tank.body.angle)
	if Tank.body.angle~=0 then
		Tank.body.x=Tank.body.x-dir*dt*Tank.speed*math.sin(Tank.body.angle)
		Tank.center.x=Tank.center.x-dir*dt*Tank.speed*math.sin(Tank.body.angle)
		Tank.fire.x=Tank.fire.x-dir*dt*Tank.speed*math.sin(Tank.body.angle)
	end
end

function Tank.makeFire()
	local targetX = Tank.fire.x+Tank.fire.w/2 
	local targetY = Tank.fire.y
	--Creates a new bullet and appends it to the table we created earlier.
	if Tank.bulletsCount>0 then
		newBullet={x=targetX,y=targetY,r=10,angle=Tank.head.angle,cx=Tank.center.x,cy=Tank.center.y}
		table.insert(Tank.bullets,newBullet)
		Tank.bulletsCount=Tank.bulletsCount-1
		Tank.tickCount = os.clock()
	end


end

function Tank.run(dt)
	-- 限制子弹发射的频率，如果想要一个子弹一个子弹的限制
	-- 可以将bulletsCount设置为1，并通过另外一个变量来控制子弹总量
	if os.clock() - Tank.tickCount >= 0.3 and Tank.bulletsCount < 5 then
		Tank.tickCount = os.clock()
		Tank.bulletsCount = Tank.bulletsCount + 1
	end

	--以下这段代码决定了射程
	for i,v in pairs(Tank.bullets) do
        local shootAngle=math.atan2((Tank.fire.y - Tank.center.y), (Tank.fire.x+Tank.fire.w/2 - Tank.center.x))
        local Dx = speed* math.cos(shootAngle)      --Physics: deltaX is the change in the x direction.
        local Dy = speed* math.sin(shootAngle)
        v.x = v.x + (Dx * dt)
        v.y = v.y + (Dy * dt)
        local length=math.sqrt((v.y-v.cy)^2+(v.x-v.cx)^2)
        if length>Tank.maxshoot then
        	table.remove(Tank.bullets,i)
        	newBoom={x=v.x,y=v.y,r=v.r,angle=v.angle,cx=v.cx,cy=v.cy}
			table.insert(Tank.booms,newBoom)
    	end
    end

    checkHit()
    Tank.boom(dt)
end

function Tank.boom(dt)
	for i,v in pairs(Tank.booms) do
		v.r = v.r + dt*10
		if v.r >= 20 then
			table.remove(Tank.booms,i)
		end
	end
end


return Tank