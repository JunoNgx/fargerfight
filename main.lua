-- 2014 Aureoline Tetrahedron
-- Created by Juno Nguyen @JunoNgx
-- Made with LÖVE v0.9.1
-- Typeface used: SF Square Head
-- SFX generated with Bfxr
-- (Processed with Audacity)
-- LÖVE Android port by Martin Felis @fysxdotorg


require 'android'
require 'players'
require 'control'
require 'gui'
require 'dust'
require 'color'

debugMode = 0

gameState = 'menu'

gameName = 'Fargerfight'

-- Declaring constants




function love.load()

	--create particles
	dust:create()

	-- button images
	love.graphics.setDefaultFilter('nearest','nearest',0)
	b_play = love.graphics.newImage('b_play.png')
	b_replay = love.graphics.newImage('b_replay.png')

	-- audio
	hit4 = love.audio.newSource('hit4.wav','static')
	hit2 = love.audio.newSource('hit2.wav','static')
	hit6 = love.audio.newSource('hit6.wav','static')

	-- Resize game runtime
	multiplatformResize()

	-- Set up world
	createWorld()

	-- Create players, called from players.lua
	p_create()

	-- Setting up variables and repositioning
	getReady()

	titleCont = gameName

	SQs = love.graphics.newFont('SFSquareHead.ttf', 40)
	SQs:setFilter('nearest', 'nearest', 0)
	SQl = love.graphics.newFont('SFSquareHead.ttf', 74)
	SQl:setFilter('nearest', 'nearest', 0)
	SQxl = love.graphics.newFont('SFSquareHead.ttf', 128)
	SQxl:setFilter('nearest', 'nearest', 0)
end

-------==========

function love.update(dt)
	-- Self-created touch tracing engine
	touchRecord()

	-- Keep the world running
	world:update(dt)

	-- Maintain boundary
	p_update()

	-- Control methods
	macControl()

	-- Update while in menu
	if gameState == 'menu' then menuUpdate() end

	-- Update while in endGame
	if gameState == 'end' then endUpdate() end

	-- Particles system update
	dustSys:update(dt)
end

--------=========

function love.draw()
	mobileScale()
	love.graphics.setBackgroundColor(80, 80, 80, 255)

	-- Draw players, pretty much all the damn times
	p_draw()

	-- particles
	-- love.graphics.draw(dustSys, dustSys:getPosition())
	love.graphics.draw(dustSys, 0,0)

	-- Draw GUI while in play, which is actually just HP
	if gameState == 'play' then playDisplay() end
	-- For other states
	if gameState == 'menu' then menuDisplay() end 
	if gameState == 'end' then endDisplay() end 

	-- enable touch debug mode
	if debugMode == 1 then debugTrace() end

	-- debug when needed
	-- love.graphics.setColor(255, 255, 255, 255)
	-- love.graphics.print(tostring(world:getBodyCount( )), 20,20)
	love.graphics.setColor(color_vermillion)
	love.graphics.rectangle('line', 0,0, 1280, 720)
end

function playHit(x)
	if x == 1 then hit2:play()
	elseif x == 2 then hit4:play()
	elseif x == 3 then hit6:play()
	end
end

function love.keypressed(key)
   if key == "escape" then
      love.event.quit()
   end
end