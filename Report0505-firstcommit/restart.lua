local composer = require( 'composer' )
local scene = composer.newScene( )
local data = require( 'data' )
local score = require( 'score' )

-------------------------------------------
--Actions
-------------------------------------------

function drawScene( sceneGroup )
	-- body

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    background = display.newImageRect("bg.png",900,1425)
	background.anchorX = 0.5
	background.anchorY = 0.5
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)
	
	gameOver = display.newImageRect("gameOver.png",500,100)
	gameOver.anchorX = 0.5
	gameOver.anchorY = 0.5
	gameOver.x = display.contentCenterX 
	gameOver.y = display.contentCenterY - 400
	gameOver.alpha = 0
	sceneGroup:insert(gameOver)

	restart = display.newImageRect("start_btn.png",300,65)
	restart.anchorX = 0.5
	restart.anchorY = 1
	restart.x = display.contentCenterX
	restart.y = display.contentCenterY + 400
	restart.alpha = 0
	sceneGroup:insert(restart)
	
	scoreBg = display.newImageRect("menuBg.png",480,393)
	scoreBg.anchorX = 0.5
	scoreBg.anchorY = 0.5
    scoreBg.x = display.contentCenterX
    scoreBg.y = display.contentHeight + 500
    sceneGroup:insert(scoreBg)

	scoreText = display.newText(data.score,display.contentCenterX + 70,
	display.contentCenterY - 60, native.systemFont, 50)
	scoreText:setFillColor(0,0,0)
	scoreText.alpha = 0 
	sceneGroup:insert(scoreText)
	
	bestText = score.init({
	fontSize = 50,
	font = "Helvetica",
	x = display.contentCenterX + 70,
	y = display.contentCenterY + 85,
	maxDigits = 7,
	leadingZeros = false,
	filename = "scorefile.txt",
	})
	bestScore = score.get()
	bestText.text = bestScore
	bestText.alpha = 0
	bestText:setFillColor(0,0,0)
	sceneGroup:insert(bestText)

end

function registerEvents(  )
	-- body
	restart:addEventListener( 'touch', restartGame )
end

function restartGame( event )
	-- body
	if event.phase == 'ended' then
		saveScore()
		composer.gotoScene( 'start' )
	end
end

function showGameOver( )
	fadeTransition = transition.to(gameOver,{time=600, alpha=1,onComplete=showScore})
end

function showScore( )
	scoreTransition = transition.to(scoreBg,{time=600, y=display.contentCenterY,onComplete=startShow})
end

function startShow( )
	startTransition = transition.to(restart,{time=200, alpha=1})
	scoreTextTransition = transition.to(scoreText,{time=600, alpha=1})
	scoreTextTransition = transition.to(bestText,{time=600, alpha=1})
end

function saveScore( )
	-- body
	local prevScore = score.load()
	if prevScore then
		if prevScore < data.score then
			score.set(data.score)
		else
			score.set(prevScore)
		end
	else
		score.set(data.score)
	end
	score.save()
end

-------------------------------------------
--
-------------------------------------------

function scene:create( event )
	print( 'restart scene created' )
	local sceneGroup = self.view
	drawScene( sceneGroup )
	registerEvents()
end

function scene:show ( event )
	print( 'restart scene show' )
	local phase = event.phase
	if phase == 'did' then
		composer.removeScene( 'game' )
		showGameOver()
	end
end

function  scene:hide( event )
   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
	  
		restart:removeEventListener("touch", restartGame)
		transition.cancel(fadeTransition)
		transition.cancel(scoreTransition)
		transition.cancel(scoreTextTransition)
		transition.cancel(startTransition)
	  
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end

function scene:destroy( event )
	print ( 'restart scene destroyed' )
end

scene:addEventListener( 'create', scene )
scene:addEventListener( 'show', scene )
scene:addEventListener( 'hide', scene )
scene:addEventListener( 'destroy', scene )

return scene