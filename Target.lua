Target = {}
Target.normal = {
		50,50,
		100,50,
		100,60,
		50,60
	}
function Target.draw(target)
	love.graphics.polygon('fill',target)
end

return Target 