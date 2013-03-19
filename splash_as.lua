-----------------------------------------------------------------------------------------
--
-- splash_as.lua
--
-----------------------------------------------------------------------------------------

module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require("widget");

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )

	print("splash_as :: createScene");

	local group = self.view

	-- create/position logo/title image on upper-half of the screen
	local splashLogo  = display.newImageRect("assets/splash/ancient_sheep.png",122,83);
	splashLogo:setReferencePoint(display.CenterReferencePoint);
	splashLogo.x,splashLogo.y = display.contentWidth/2,display.contentHeight/2;

	-- all display objects must be inserted into group
	group:insert(splashLogo);

	-- when finished fading out logo, call this to exit scene and enter main menu
	local function exitSplash(event)
	 	print("exitSplash");

	 	-- load menu screen
		storyboard.gotoScene("main_menu","fade",0);
	 end

	-- setup our timer / fade out event
	local function fadeHerOut(event)
	    print("finishedHere");

	    -- fade out image
	    transition.to(splashLogo,{time=1000,alpha=0,onComplete=exitSplash})
	 end

	-- run timer to start fade out / exit	 
	timer.performWithDelay(3000,fadeHerOut);

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	print("splash_as :: enterScene");

	local group = self.view

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)

	-- play audio
	audioManager:playMusic("splash_screen.mp3",0);
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	-- stop music channel
	audioManager:stopMusicChannel();

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	print("splash_as :: exitScene");
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	print("splash_as :: destroyScene");
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene
