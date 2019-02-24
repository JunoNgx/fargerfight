-- the distance between current cursor position to p1_p1
-- to engage in movement and maneuvering
dist_thresh = 7

force_multiplier = 770


function micControl(i, p, dt)
	
	local force = math.dist(tt[i].rx, tt[i].ry, tt[i].x, tt[i].y)
	if force > dist_thresh then
		
		local desAngle = math.angle(tt[i].rx, tt[i].ry, tt[i].x, tt[i].y)
		local diff = (desAngle - p.body:getAngle() + math.pi) % (2* math.pi) - math.pi

		p.body:setAngularVelocity(diff*5)
		p.body:setAngularDamping(diff)

		p.body:setLinearDamping(force/70)
		p.body:applyForce(
			force*math.cos(desAngle) * force_multiplier,
			force*math.sin(desAngle) * force_multiplier
		)	
	else 
		p.body:setLinearDamping(4)
		p.body:setAngularDamping(math.pi*4)
	end
end

function macControl()
	for i = 1, 2 do
		if gameState == 'play' or gameState == 'end' then
			if tt[i].isOn and tt[i].ox > winW/2 and p1.isAlive then micControl(i, p1, dt) end
			if tt[i].isOn and tt[i].ox < winW/2 and p2.isAlive then micControl(i, p2, dt) end
		end
	end
end

function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end