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

Tank.bodyX=250
Tank.bodyY=250 
Tank.bodyW=40 
Tank.bodyH=50
Tank.centerX=Tank.bodyX+Tank.bodyW/2
Tank.centerY=Tank.bodyY+Tank.bodyH/2


Tank.bodyA=0	--坦克躯干角度
Tank.headA=0	--坦克头部角度
Tank.bulletA=0	--子弹发射角度
Tank.headR=15	--坦克头部半径
Tank.headS=6	--坦克头部边数
Tank.fireW=5	--炮管宽度
Tank.fireH=40	--炮管长度
Tank.speed=50	--坦克移动速度
Tank.bulletsCount=10000	--坦克子弹个数
Tank.maxbs=10000	--最大子弹个数
Tank.maxshoot=500
Tank.bulletSize=4

Tank.fireX=Tank.centerX-Tank.fireW/2
Tank.fireY=Tank.centerY-Tank.fireH-math.cos(math.pi/6)*Tank.headR
 --headR:坦克脑袋半径，headS:坦克脑袋边数

Tank.bullets={}	--The table that contains all bullets.

function Tank.draw()
	--输出子弹个数
	love.graphics.print("BULLETS:> "..Tank.bulletsCount,500,200)
	love.graphics.print("Tank body Angle:> "..Tank.bodyA,500,250)
	love.graphics.print("Tank head Agnle:> "..Tank.headA,500,300)
	love.graphics.print("Tank.fireX: "..Tank.fireX.." Tank.fireY: "..Tank.fireY,500,350)
	love.graphics.print("targetX: "..Tank.fireX+Tank.fireW/2 +Tank.fireH*math.sin(Tank.headA),500,400)
	love.graphics.print("targetY: "..Tank.fireY+Tank.fireH -Tank.fireH*math.cos(Tank.headA),500,450)
	--Sets the color to red and draws the "bullets".
	love.graphics.setColor(255, 255, 255)
	
	--画坦克躯干
	love.graphics.origin()
	rotateGraph(Tank.centerX,Tank.centerY,Tank.bodyA);
	love.graphics.rectangle("line", Tank.bodyX, Tank.bodyY, Tank.bodyW, Tank.bodyH)

	--画坦克头部
	love.graphics.origin()
	rotateGraph(Tank.centerX,Tank.centerY,Tank.headA)
	love.graphics.circle("line", Tank.centerX, Tank.centerY, Tank.headR, Tank.headS)
	love.graphics.rectangle("line",Tank.fireX,Tank.fireY,Tank.fireW,Tank.fireH)

	--画子弹
	for i,v in pairs(Tank.bullets) do
		love.graphics.origin()
		-- rotateBuilet(v.angle)
		rotateGraph(v.cx,v.cy,v.angle)
		love.graphics.circle("line", v.x, v.y,Tank.bulletSize,10)
	end
end

function Tank.move(dir,dt)
	Tank.bodyY=Tank.bodyY+dir*dt*Tank.speed*math.cos(Tank.bodyA)
	Tank.centerY=Tank.centerY+dir*dt*Tank.speed*math.cos(Tank.bodyA)
	Tank.fireY=Tank.fireY+dir*dt*Tank.speed*math.cos(Tank.bodyA)
	if Tank.bodyA~=0 then
		Tank.bodyX=Tank.bodyX-dir*dt*Tank.speed*math.sin(Tank.bodyA)
		Tank.centerX=Tank.centerX-dir*dt*Tank.speed*math.sin(Tank.bodyA)
		Tank.fireX=Tank.fireX-dir*dt*Tank.speed*math.sin(Tank.bodyA)
	end
end

function Tank.fire()
	
	local targetX = Tank.fireX+Tank.fireW/2 
	local targetY = Tank.fireY
	  
	--Creates a new bullet and appends it to the table we created earlier.
	if(Tank.bulletsCount>0) then
		newbullet={x=targetX,y=targetY,angle=Tank.headA,cx=Tank.centerX,cy=Tank.centerY}
		table.insert(Tank.bullets,newbullet)
		Tank.bulletsCount=Tank.bulletsCount-1
	end
end
return Tank