-----------------------------------------------------------------------------------------
--
-- game_screen.lua - most important screen
--
-----------------------------------------------------------------------------------------

module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require("widget");
local game;


-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )

	print("game_screen :: createScene");

	as_analytics:logEvent("game_screne : createScene");

	local group = self.view;

	game = require("game").new();
	--setup game
	game:setup();
	group:insert(game.group);

	storyboard.removeScene("final_guess_screen");

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	print("game_screen :: enterScene");

	local group = self.view

	-- play audio
	--audioManager:stopMusicChannel();

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)

	--update
	game:updateGame();

	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view;

	audioManager:stopClock();

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	print("game_screen :: exitScene");

	game:destroy();

	--profiler.diffSnapshot();
	
end


-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	print("game_screen :: destroyScene");

	--profiler.diffSnapshot();


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




