-----------------------------------------------------------------------------------------
--
-- how_to_play.lua
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
	print("how_to_play :: backClick");
	native.cancelWebPopup();
	storyboard.gotoScene("main_menu","slideRight",200);
end

-- Called when the scene's view does not exist:
function scene:createScene( event )

	print("how_to_play :: createScene");

	local group = self.view;

	-- main menu bk
	local bk  = display.newImageRect("assets/game_options_screen/blue_bk.jpg",615,392);
	bk:setReferencePoint(display.TopLeftReferencePoint);
	bk.x,bk.y = 0,0;
	group:insert(bk);

	-- animated sun rays
	local rays = require("sun_rays").new();
	rays.sunRays.x = 0;
	group:insert(rays.sunRays);

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
	native.showWebPopup(0,44,display.contentWidth,display.contentHeight-44,"assets/html/help_screen.html",{urlRequest=listener,baseUrl=system.ResourceDirectory,hasBackground=false});

	--add navigation bar
	local navi = require("navi_bar").newBar();
	navi:setup(backClick);
	group:insert(navi.group);

	--activity indicator
	--native.setActivityIndicator(true);
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	print("how_to_play :: enterScene");

	local group = self.view

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	print("how_to_play :: exitScene");
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	print("how_to_play :: destroyScene");
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




