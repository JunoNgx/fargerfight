traceGhost = 1

-- Record rate (every x seconds)
recRate = 0.2

tt = {}
for i=1, 10 do
	tt[i] = {}
	tt[i].isOn = false
end

function love.touchpressed(id, x, y, pressure)

	tt[id+1].isOn = true

	tt[id+1].ox = x * getW / scale
	tt[id+1].oy = y * getH / scale

	tt[id+1].lastRecTime = love.timer.getTime()
	tt[id+1].rx = x * getW / scale
	tt[id+1].ry = y * getH / scale

end


function love.touchreleased(id, x, y, pressure)
	tt[id+1].zx = x * getW / scale
	tt[id+1].zy = y * getH / scale
	tt[id+1].isOn = false
end

function touchRecord()
	for i = 1, love.touch.getTouchCount() do
		
		tt[i].id, tt[i].x, tt[i].y, tt[i].pressure = love.touch.getTouch(i)
		-- Convert this to viewport coordinates
		tt[i].x = tt[i].x * getW / scale
		tt[i].y = tt[i].y * getH / scale

		-- Enable ghost tracing to trace direction of touch movement
		if traceGhost == 1 and love.timer.getTime() - tt[i].lastRecTime > recRate then
			tt[i].lastRecTime = love.timer.getTime()

			tt[i].rx = tt[i].x
			tt[i].ry = tt[i].y
		end

	end
end

function multiplatformResize()
	if love.system.getOS() == "Windows" then
		love.window.setMode(1280, 720)
		winW = 1280
		winH = 720
	end

	if love.system.getOS() == "Android"	then
		love.window.setMode(0, 0)

		scale = love.graphics.getWidth()/1280
		-- setting constants to facilitate coding
		ratio = love.graphics.getWidth()/love.graphics.getHeight()	
		
		winW = 1280
		winH = winW / ratio

		-- shortcuts to these long commands
		getW = love.graphics.getWidth()
		getH = love.graphics.getHeight()	
	end
end

function mobileScale()
	if love.system.getOS() == "Android"	then love.graphics.scale(scale) end
end


function Tapped(x, y, xH, yH)
	for i=1, love.touch.getTouchCount() do
		if tt[i].isOn then
			if tt[i].ox >= x and tt[i].ox < xH and tt[i].oy >= y and tt[i].oy < yH
			-- and tt[i].zx >= x and tt[i].zx < xH and tt[i].zy >= y and tt[i].zy < yH 
			then
			return true end
		end
	end
end