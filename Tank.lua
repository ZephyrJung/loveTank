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
Tank.speed=50	--坦克移动速度
Tank.bulletsCount=10000	--坦克子弹个数
Tank.maxbs=10000	--最大子弹个数
Tank.maxshoot=500
Tank.bulletSize=4

 --head.radius:head.edges:坦克脑袋边数

Tank.bullets={}	--The table that contains all bullets.

function Tank.draw()
	--输出子弹个数
	love.graphics.print("BULLETS:> "..Tank.bulletsCount,500,200)
	love.graphics.print("Tank body Angle:> "..Tank.body.angle,500,250)
	love.graphics.print("Tank head Agnle:> "..Tank.head.angle,500,300)
	love.graphics.print("Tank.fire.x: "..Tank.fire.x.." Tank.fire.y: "..Tank.fire.y,500,350)
	love.graphics.print("targetX: "..Tank.fire.x+Tank.fire.w/2 +Tank.fire.h*math.sin(Tank.head.angle),500,400)
	love.graphics.print("targetY: "..Tank.fire.y+Tank.fire.h -Tank.fire.h*math.cos(Tank.head.angle),500,450)
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
		love.graphics.circle("line", v.x, v.y,Tank.bulletSize,10)
	end
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
	if(Tank.bulletsCount>0) then
		newbullet={x=targetX,y=targetY,angle=Tank.head.angle,cx=Tank.center.x,cy=Tank.center.y}
		table.insert(Tank.bullets,newbullet)
		Tank.bulletsCount=Tank.bulletsCount-1
	end
end
return Tank