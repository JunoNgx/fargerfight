-- Menu display
function menuDisplay ()

	-- FARBENDUELL
	love.graphics.setFont(SQxl)
	love.graphics.setColor(200,200,200,255)
	love.graphics.print(titleCont, winW*0.5, winH*0.17,
		0,1,1,
		SQxl:getWidth(titleCont)/2, SQxl:getHeight(titleCont)/2)

	-- Subtitle
	love.graphics.setFont(SQs)
	love.graphics.setColor(200,200,200,255)
	love.graphics.print('created by Juno Nguyen @JunoNgx', winW*0.5, winH*0.30,
		0,1,1,
		SQs:getWidth('created by Juno Nguyen @JunoNgx')/2, SQs:getHeight('created by Juno Nguyen @JunoNgx')/2)

	love.graphics.draw(b_play, winW*0.5, winH*0.6,
			0,1,1,
			b_play:getWidth()/2, b_play:getHeight()/2)

	-- Aureoline Tetrahedron
	love.graphics.setFont(SQs)
	love.graphics.setColor(200,200,200,255)
	love.graphics.print('2014 Aureoline Tetrahedron', winW*0.5, winH*0.95,
		0,1,1,
		SQs:getWidth('2014 Aureoline Tetrahedron')/2, SQs:getHeight('2014 Aureoline Tetrahedron')/2)

end

--Menu interaction
function menuUpdate ()
	if Tapped(winW*0.5 - b_play:getWidth()/2, winH*0.6 - b_play:getHeight()/2, 
		winW*0.5 + b_play:getWidth()/2, winH*0.6 + b_play:getHeight()/2) then

		gameState = 'play'
	end
end


--Endgame display
function endDisplay()
	love.graphics.setFont(SQl)
	love.graphics.setColor(200,200,200,255)

	love.graphics.print(titleCont, winW*0.5, winH*0.35,
		0,1,1,
		SQl:getWidth(titleCont)/2, SQl:getHeight(titleCont)/2)

	love.graphics.draw(b_replay, winW*0.5, winH*0.6,
		0,1,1,
		b_replay:getWidth()/2, b_replay:getHeight()/2)
end

--Endgame Interaction
function endUpdate ()
	if Tapped(winW*0.5 - b_replay:getWidth()/2, winH*0.6 - b_replay:getHeight()/2, 
		winW*0.5 + b_replay:getWidth()/2, winH*0.6 + b_replay:getHeight()/2) then

		world:destroy()
		createWorld()
		p_create()
		getReady()
	end
end


-- HP display during gameplay
function playDisplay()
	-- Draw HP
	-- P1 is on the right, not left
	for i = 1, p1.HP do
		love.graphics.setColor(color_viridian)
		love.graphics.rectangle('fill', 
			(winW - 100) - (i-1)*80, 50,
			30,30)
	end

	-- This is on the left
	for i = 1, p2.HP do
		love.graphics.setColor(color_vermillion)
		love.graphics.rectangle('fill',
			70 + (i-1)*80, 50,
			30,30)
	end
end