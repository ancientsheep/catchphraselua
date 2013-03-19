-----------------------------------------------------------------------------------------
--
-- more_games.lua
--
-----------------------------------------------------------------------------------------

module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require("widget");

--fps
local fps = require("fps").new();

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------

function backClick()
	print("more_games :: backClick");
	native.cancelWebPopup();
	storyboard.gotoScene("main_menu","slideRight",200);
end

-- Called when the scene's view does not exist:
function scene:createScene( event )

	print("more_games :: createScene");

	local group = self.view;

	local function listener(event)
		print("urlEvents");

		native.setActivityIndicator(false);

        local shouldLoad = true;
 
	        local url = event.url
	        if 1 == string.find(url,"corona:close") then
	                -- Close the web popup
	                shouldLoad = false;
	        end
	 
	        if event.errorCode then
	                -- Error loading page
	                native.showAlert(dialogTitle,dialogText,{"Close"}, votariphone )
	                shouldLoad = false
	        end
		return shouldLoad;
	end

	--open web popup
	local options = {hasBackground=true,urlRequest=listener};
	native.showWebPopup(0,48,display.contentWidth,display.contentHeight-48,"http://www.ancientsheep.com",{urlRequest=listener});

	--add navigation bar
	local navi = require("navi_bar").newBar();
	navi:setup(backClick);
	group:insert(navi.group);

	--activity indicator
	native.setActivityIndicator(true);
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	print("more_games :: enterScene");

	local group = self.view

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	print("more_games :: exitScene");
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	print("more_games :: destroyScene");
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




