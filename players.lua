p1 = {}
p2 = {}

p1_b = {}
p1_s = {}

p2_b = {}
p2_s = {}

start_hp = 3

density = 2
density_dev = 7

-- The delay for checking match's result after one player dies
endCheck_delay = 1

-- cooldown before the player can hit and score again
hitRate = 1.5

-- boundary threshold
bo_th = 50


function createWorld()
	-- Set up world
	love.physics.setMeter(50)
	world = love.physics.newWorld(0, 0, true)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function p_draw()

	--Shadow for player 1, derived from below
	love.graphics.push()
	love.graphics.translate(10,10)
	love.graphics.setColor(40, 40, 40, 150)
	love.graphics.polygon('fill', p1.body:getWorldPoints(p1.shape:getPoints()))
	love.graphics.polygon('fill', p1_s.body:getWorldPoints(p1_s.shape:getPoints()))
	love.graphics.polygon('fill', p1_b.body:getWorldPoints(p1_b.shape:getPoints()))
	love.graphics.pop()

	--Shadow for player 2, derived from below
	love.graphics.push()
	love.graphics.translate(10,10)
	love.graphics.setColor(40, 40, 40, 150)
	love.graphics.polygon('fill', p2.body:getWorldPoints(p2.shape:getPoints()))
	love.graphics.polygon('fill', p2_s.body:getWorldPoints(p2_s.shape:getPoints()))
	love.graphics.polygon('fill', p2_b.body:getWorldPoints(p2_b.shape:getPoints()))
	love.graphics.pop()
	

	--Actual graphics
	--Shield1
	love.graphics.setColor(140, 140, 140, 255)
	love.graphics.polygon('fill', p1_s.body:getWorldPoints(p1_s.shape:getPoints()))
	--Blade1
	love.graphics.setColor(240, 240, 240, 255)
	love.graphics.polygon('fill', p1_b.body:getWorldPoints(p1_b.shape:getPoints()))
	--Body1
	love.graphics.setColor(color_viridian)
	love.graphics.polygon('fill', p1.body:getWorldPoints(p1.shape:getPoints()))


	--Actual graphics, derived from below
	--Shield2
	love.graphics.setColor(140, 140, 140, 255)
	love.graphics.polygon('fill', p2_s.body:getWorldPoints(p2_s.shape:getPoints()))
	--Blade2
	love.graphics.setColor(240, 240, 240, 255)
	love.graphics.polygon('fill', p2_b.body:getWorldPoints(p2_b.shape:getPoints()))
	--Body2
	love.graphics.setColor(color_vermillion)
	love.graphics.polygon('fill', p2.body:getWorldPoints(p2.shape:getPoints()))
end

function p_update()
	if p1.body:getX()> 1280 - bo_th then p1.body:setX(1280 - bo_th) end 
	if p1.body:getX()< bo_th then p1.body:setX(bo_th) end
	if p1.body:getY()> winH - bo_th then p1.body:setY(winH - bo_th) end
	if p1.body:getY()< bo_th  then p1.body:setY(bo_th) end	


	if p2.body:getX()> 1280 - bo_th then p2.body:setX(1280 - bo_th) end 
	if p2.body:getX()< bo_th then p2.body:setX(bo_th) end
	if p2.body:getY()> winH - bo_th then p2.body:setY(winH - bo_th) end
	if p2.body:getY()< bo_th  then p2.body:setY(bo_th) end

	-- Workaround for the spinning bug
	p1.body:setLinearDamping(4)
	p1.body:setAngularDamping(math.pi*4)	

	p2.body:setLinearDamping(4)
	p2.body:setAngularDamping(math.pi*4)

	-- cooldown hitRate reset
	if love.timer.getTime() - p1.lastHit > hitRate then
		p1.canHit = true
	end	

	if love.timer.getTime() - p2.lastHit > hitRate then
		p2.canHit = true
	end

	-- Checking for mortality
	if p1.HP == 0 and p1.isAlive then
		p1_die()
		endCheckTime = love.timer.getTime() + endCheck_delay
		endCheck()
	end

	if p2.HP == 0 and p2.isAlive then
		p2_die()
		endCheckTime = love.timer.getTime() + endCheck_delay
		endCheck()
	end

	-- Performing result checking
	if endCheckTime ~= nil and love.timer.getTime() >= endCheckTime and gameState == 'play' then
		endCheck()
	end

end


function p_create()
	-- Player One ------------
	
	-- Main body ----
	p1.body = love.physics.newBody(world, winW * 0.75, winH/2, 'dynamic')
	p1.shape = love.physics.newPolygonShape(60,0,  19,-57,  -49,-35,  -49,35,  19,57) -- radius 60
	p1.fixture = love.physics.newFixture(p1.body, p1.shape, density)

	-- Blade ----
	p1_b.body = love.physics.newBody(world, winW * 0.75, winH/2, 'dynamic')
	p1_b.shape = love.physics.newPolygonShape(0,-6,  0,6,  150,6,   160,-6)
	p1_b.fixture = love.physics.newFixture(p1_b.body, p1_b.shape, density/density_dev)

	-- Shield ----
	p1_s.body = love.physics.newBody(world, winW * 0.75, winH/2, 'dynamic')
	p1_s.shape = love.physics.newPolygonShape(0,0  ,  -64,-88  ,  -48,-88  ,  16,0)
	p1_s.fixture = love.physics.newFixture(p1_s.body, p1_s.shape, density/density_dev)

	p1isArmed = false
	p1isPresent = true



	-- Player Two ------------

	-- Main Body ----
	p2.body = love.physics.newBody(world, winW * 0.25, winH/2, 'dynamic')
	p2.shape = love.physics.newPolygonShape(60,0,  19,-57,  -49,-35,  -49,35,  19,57)
	p2.fixture = love.physics.newFixture(p2.body, p2.shape, density)

	-- Blade ----
	p2_b.body = love.physics.newBody(world, winW * 0.25, winH/2, 'dynamic')
	p2_b.shape = love.physics.newPolygonShape(0,-6,  0,6,  150,6,   160,-6)
	p2_b.fixture = love.physics.newFixture(p2_b.body, p2_b.shape, density/density_dev)

	-- Shield ----
	p2_s.body = love.physics.newBody(world, winW * 0.25, winH/2, 'dynamic')
	p2_s.shape = love.physics.newPolygonShape(0,0  ,  -64,-88  ,  -48,-88  ,  16,0)
	p2_s.fixture = love.physics.newFixture(p2_s.body, p2_s.shape, density/density_dev)

	p2isArmed = false
	p2isPresent = true
	

end


function getReady()

	-- Reset position ----

	-- Rearmed if not armed (after death)
	if not p1isArmed then

	--setAngle afterwards instead
	--p1.body:setAngle(-math.pi)
		
		p1.body:setPosition(winW * 0.75, winH/2)
		p1.body:setLinearVelocity(0,0)

		p1_b.body:setPosition(winW * 0.75, winH/2)
		p1_b.body:setLinearVelocity(0,0)
		
		p1_s.body:setPosition(winW * 0.75, winH/2)
		p1_s.body:setLinearVelocity(0,0)

		-- ArmJoint ----
		p1_armJoint = love.physics.newWeldJoint(p1.body, p1_b.body, 12,30 , 0,0 , false)
		-- ShieldJoimt ----
		p1_shieldJoint = love.physics.newWeldJoint(p1.body, p1_s.body, 75,0 , 0,0 , false)

		-- p1.body:setLinearVelocity(0,0)
		-- p1.body:setPosition(winW * 0.75, winH/2)
	
	else 
		p1.body:setLinearVelocity(0,0)
		p1.body:setPosition(winW * 0.75, winH/2)
	end

	-- Fucking Box2d bug
	-- This one is acceptable for N5
	p1.body:setAngle(-2*math.pi-0.125)



	-- Player 2
	if not p2isArmed then
		p2.body:setLinearVelocity(0,0)
		p2.body:setPosition(winW * 0.25, winH/2)

		p2_b.body:setLinearVelocity(0,0)
		p2_b.body:setPosition(winW * 0.25, winH/2)

		p2_s.body:setLinearVelocity(0,0)
		p2_s.body:setPosition(winW * 0.25, winH/2)

	
		-- Joint ----
		p2_armJoint = love.physics.newWeldJoint(p2.body, p2_b.body, 12,30 , 0,0 , false)
		-- ShieldJoimt ----
		p2_shieldJoint = love.physics.newWeldJoint(p2.body, p2_s.body, 75,0 , 0,0 , false)
	else
		p2.body:setLinearVelocity(0,0)
		p2.body:setPosition(winW * 0.25, winH/2)
	end

	p2.body:setAngle(0)


	-- Resetting values
	p1.canHit = true
	p2.canHit = true

	p1.lastHit = love.timer.getTime()
	p2.lastHit = love.timer.getTime()

	p1.hitCount = 0
	p2.hitCount = 0

	p1.HP = start_hp
	p2.HP = start_hp

	p1.isAlive = true
	p2.isAlive = true

	p1.deathTime = nil
	p2.deathTime = nil


	-- System stuff
	if gameState ~= 'menu' then gameState = 'play' end
	dustSys:stop()
end


function beginContact(a, b, coll)

	-- Player One hits -----
	if a == p1_b.fixture and b == p2.fixture and p1.canHit then
	    p1.hitCount = p1.hitCount + 1
	    p2.HP = p2.HP - 1

	    p1.lastHit = love.timer.getTime()
		p1.canHit = false

		playHit(love.math.random(1,3))

		dustSys:setPosition(coll:getPositions())
		dustSys:start()
	end	

	-- Player Two hits -----
	if b == p2_b.fixture and a == p1.fixture and p2.canHit then
	    p2.hitCount = p2.hitCount + 1
	    p1.HP = p1.HP - 1

	    p2.lastHit = love.timer.getTime()
		p2.canHit = false

		playHit(love.math.random(1,3))

		dustSys:setPosition(coll:getPositions())
		dustSys:start()
	end

end

function endContact(a, b, coll)
	-- Player One hits -----
	if a == p1_b.fixture and b == p2.fixture then
		dustSys:stop()
    end

    -- Player One hits -----
	if b == p2_b.fixture and a == p1.fixture then
		dustSys:stop()
    end
end

function preSolve(a, b, coll)
    
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
    
end


function p1_die ()
	p1.deathTime = love.timer.getTime()
	p1.isAlive = false

	p1_armJoint:destroy()
	p1_shieldJoint:destroy()

	p1.body:setLinearDamping(0.1)
	p1.body:setAngularDamping(math.pi/360)

	p1isArmed = false
end

function p2_die ()
	p2.deathTime = love.timer.getTime()
	p2.isAlive = false

	p2_armJoint:destroy()
	p2_shieldJoint:destroy()

	p2.body:setLinearDamping(0.1)
	p2.body:setAngularDamping(math.pi/360)

	p2isArmed = false
end


-- function pDestroy ()

-- 	if p1isArmed then
-- 		p1_armJoint:destroy()
-- 		p1_shieldJoint:destroy()

-- 		p1isArmed = false
-- 	end

-- 	if p2isArmed then
-- 		p2_armJoint:destroy()
-- 		p2_shieldJoint:destroy()

-- 		p2isArmed = false
-- 	end

-- 	if p1isPresent then
-- 		p1.fixture:destroy()
-- 		p1.body:destroy()
-- 		-- p1.shape:destroy()


-- 		p1_b.fixture:destroy()
-- 		-- p1_b.shape:destroy()
-- 		p1_b.body:destroy()

-- 		p1_s.fixture:destroy()
-- 		-- p1_s.shape:destroy()
-- 		p1_s.body:destroy()

-- 		p1isPresent = false
-- 	end

-- 	if p2isPresent then
-- 		p2.fixture:destroy()
-- 		-- p2.shape:destroy()
-- 		p2.body:destroy()

-- 		p2_b.fixture:destroy()
-- 		-- p2_b.shape:destroy()
-- 		p2_b.body:destroy()

-- 		p2_s.fixture:destroy()
-- 		-- p2_s.shape:destroy()
-- 		p2_s.body:destroy()

-- 		p2isPresent = false
-- 	end
-- end


function endCheck ()
	-- p1 wins
	if p1.isAlive and not p2.isAlive then
		titleCont = 'viridian wins'
	end

	-- P2 wins
	if p2.isAlive and not p1.isAlive then
		titleCont = 'vermillion wins'
	end

	-- Draw
	if not p1.isAlive and not p2.isAlive then
		titleCont = 'draw'
	end

	gameState = 'end'

	endCheckTime = nil
end