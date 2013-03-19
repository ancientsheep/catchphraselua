-----------------------------------------------------------------------------------------
--
-- options.lua
--
-----------------------------------------------------------------------------------------

module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene();
local facebook = require "facebook"

-- include Corona's "widget" library
local widget = require("widget");

local menuItems = {};

function backClick()
	print("options :: backClick");

	storyboard.gotoScene("main_menu","slideLeft",200);
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )

	print("options :: createScene");

	local group = self.view

	-- main menu bk
	local bk  = display.newImageRect("assets/main_menu/main_menu_bk.jpg",480,320);
	bk:setReferencePoint(display.TopLeftReferencePoint);
	bk.x,bk.y = 0,0;
	group:insert(bk);

	-- animated sun rays
	local rays = require("sun_rays").new();
	rays.sunRays.x = 0;
	group:insert(rays.sunRays);

	--add navigation bar
	local navi = require("navi_bar").newBar();
	navi:setup(backClick,"Options");
	group:insert(navi.group);

	local function facebookLisener( event )
	    if ( "session" == event.type ) then
	        -- upon successful login, request list of friends
	        if ( "login" == event.phase ) then
	            facebook.showDialog( "apprequests", {
	                message = "You should download this game!"
	            })
	        end
	    elseif ( "dialog" == event.type ) then
	        print( event.response )
	    end
	end




	--facebook test shit
	facebook.login("213242208813097",facebookListener,{"publish_stream"});

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	print("options :: enterScene");

	local group = self.view

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)

	-- play audio
	audioManager:playMusic("main_menu2.mp3",0);


end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	print("options :: exitScene");
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	print("options :: destroyScene");
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




