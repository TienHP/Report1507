----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local physics = require 'physics'
physics.start()

----------------------------------------------------------------------------------
-- 
--  NOTE:
--  
--  Code outside of listener functions (below) will only be executed once,
--  unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:create( event )

    -----------------------------------------------------------------------------

    --  CREATE display objects and add them to 'group' here.
    --  Example use-case: Restore 'group' from previously saved state.

    -----------------------------------------------------------------------------

    local sceneGroup = self.view

    drawScene(sceneGroup)

end


function drawScene( sceneGroup )
	--draw the background    
    background = display.newImageRect('bg.png', 900, 1425)
    background.anchorX = 0.5
    background.anchorY = 1	
    background.x = display.contentCenterX
    background.y = display.contentHeight
    sceneGroup:insert(background)
    
	--draw the platform
	platform = display.newImageRect('platform.png',900,53)
	platform.anchorX = 0
	platform.anchorY = 1
	platform.x = 0
	platform.y = display.viewableContentHeight - 110
	physics.addBody(platform, "static", {density=.1, bounce=0.1, friction=.2})
	platform.speed = 4
	sceneGroup:insert(platform)

	platform2 = display.newImageRect('platform.png',900,53)
	platform2.anchorX = 0
	platform2.anchorY = 1
	platform2.x = platform.width
	platform2.y = display.viewableContentHeight - 110
	physics.addBody(platform2, "static", {density=.1, bounce=0.1, friction=.2})
	platform2.speed = 4
	sceneGroup:insert(platform2)

	--draw the start button
	startBtn = display.newImageRect("start_btn.png",300,65)
	startBtn.anchorX = 0.5
	startBtn.anchorY = 1
	startBtn.x = display.contentCenterX
	startBtn.y = display.contentHeight - 400
	sceneGroup:insert(startBtn)

	--draw the title group

	--draw the title
    title = display.newImageRect("title.png", 500, 100)
	title.anchorX = 0.5
	title.anchorY = 0.5
	title.x = display.contentCenterX - 80
	--title.y = display.contentCenterY
	sceneGroup:insert(title)

	p_options = {

		width = 80,
		height = 42,
		numFrames = 2,

		sheetContentWidth = 160,
		sheetContentHeight = 42,

	}

	--draw player
	playerSheet = graphics.newImageSheet('bat.png', p_options)
	sequenceData = {

		name = 'player',
		start = 1,
		count = 2,
		time = 500,
	}
	player = display.newSprite(playerSheet, sequenceData)
	player.anchorX = 0.5
	player.anchorY = 0.5
	player.x = display.contentCenterX + 240
	--player.y = display.contentCenterY 
	player:play()
	sceneGroup:insert(player)

	titleGroup = display.newGroup()
	titleGroup.anchorChildren = true
	titleGroup.anchorX = 0.5
	titleGroup.anchorY = 0.5
	titleGroup.x = display.contentCenterX
	titleGroup.y = display.contentCenterY - 250

	titleGroup:insert(title)
	titleGroup:insert(player)

	sceneGroup:insert(titleGroup)
	titleAnimation()

end


function titleTransitionDown()
	downTransition = transition.to(titleGroup,{time=400, y=titleGroup.y+20,onComplete=titleTransitionUp})
	
end

function titleTransitionUp()
	upTransition = transition.to(titleGroup,{time=400, y=titleGroup.y-20, onComplete=titleTransitionDown})
	
end

function titleAnimation()
	titleTransitionDown()
end


-- Called immediately after scene has moved onscreen:
function scene:show( event )
    local group = self.view
    phase = event.phase
    if phase == 'will' then
    elseif phase == 'did' then
    	composer.removeScene( 'restart' )
    	--move the platform
    	platform.enterFrame = scrollGround
    	Runtime:addEventListener( 'enterFrame', platform )
    	platform2.enterFrame = scrollGround
    	Runtime:addEventListener( 'enterFrame', platform2 )
    	startBtn:addEventListener( 'touch', startGame )
    end

    print("entered")

    -----------------------------------------------------------------------------

    --  INSERT code here (e.g. start timers, load audio, start listeners, etc.)

    -----------------------------------------------------------------------------

end

-------------------------------------------
-- ACTIONS
-------------------------------------------
			
function scrollGround( self, event )

	if self.x - self.speed < -900 then
		self.x = 900 - (-900 - self.x + self.speed)
	else
		self.x = self.x - self.speed 
	end
end

function startGame( event )
	-- body
	if event.phase == 'ended' then
		composer.gotoScene( 'game' )
	end
end


-- Called when scene is about to move offscreen:
function scene:hide( event )
   local group = self.view
   local phase = event.phase
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
	    startBtn:removeEventListener("touch", startGame)
		Runtime:removeEventListener("enterFrame", platform)
		Runtime:removeEventListener("enterFrame", platform2)
		transition.cancel(downTransition)
		transition.cancel(upTransition)
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
    local group = self.view

    print('destroyed')

    -----------------------------------------------------------------------------

    --  INSERT code here (e.g. remove listeners, widgets, save state, etc.)

    -----------------------------------------------------------------------------

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene