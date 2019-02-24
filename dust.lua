dust = {}


function dust:create()
	dust = love.graphics.newImage('dust.png')

	dustSys = love.graphics.newParticleSystem(dust, 170)

	dustSys:setDirection(0)
	dustSys:setEmissionRate(70)
	dustSys:setEmitterLifetime(0.5)
	dustSys:setParticleLifetime(3)
	dustSys:setLinearAcceleration(-200,-200, 200,200)
	dustSys:setSpeed(1000,2000)
	dustSys:setSpread(math.pi*2)
	dustSys:setSpin(math.pi*4, math.pi*7)
	dustSys:setSpinVariation( 0.7 )
	dustSys:stop()
end