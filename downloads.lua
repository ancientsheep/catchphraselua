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
-- json
local json = require "json"
-- iap
local store = require("store")

--fps
local fps = require("fps").new();

-- navigation bar
local navi;
local restoreButton 

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------

function backClick()
	print("downloads :: backClick");
	storyboard.gotoScene("main_menu","slideRight",200);
end

-- Called when the scene's view does not exist:
function scene:createScene( event )

	print("downloads :: createScene");

	as_analytics:logEvent("downloads : createScene");

	local group = self.view;

	-- main menu bk
	local bk  = display.newImageRect("assets/downloads/bk.png",615,392);
	bk:setReferencePoint(display.TopLeftReferencePoint);
	bk.x,bk.y = 0,0;
	group:insert(bk);

	-- animated sun rays
	local rays = require("sun_rays").new();
	rays.sunRays.x,rays.sunRays.y = display.contentWidth/2,0;
	rays.sunRays.alpha = 0.02;
	group:insert(rays.sunRays);

	local function finishedDownloading(event)
		 if (event.isError) then
                print("Network error - download failed");
                alert("Error occured");
        else
                print("success");

                -- json decode response
                local json_data = json.decode(event.response);

                local compared_json_data = require("categories").compareLocalToRemoteList(json_data);

                -- create our download table view
                local tableView = require("download_table").new(compared_json_data);
                group:insert(tableView.list);
        end
      
        print("RESPONSE: "..event.response);
		native.setActivityIndicator(false);

		-- bring navi to front
		group:insert(navi.group);

	end

	if isLiteVersion~=true then
		-- download json list
		network.request("http://www.mashmyaveragelife.com/catchphrase/view_list.php?app=catchphrase_paid","GET",finishedDownloading);
	else
		-- download json list
		network.request("http://www.mashmyaveragelife.com/catchphrase/view_list.php?app=catchphrase_free","GET",finishedDownloading);
	end

	--add navigation bar
	navi = require("navi_bar").newBar();
	navi:setup(backClick,"Downloads");
	group:insert(navi.group);

	function restoreClick(evt)
		as_store:restorePurchases();
	end

	--restore button
	restoreButton = widget.newButton{
		label="",
		defaultFile="assets/downloads/restore.png",
		overFile="assets/downloads/restore_hi.png",
		width=143, height=33,
		onRelease = restoreClick
	}
	restoreButton:setReferencePoint(display.TopRightReferencePoint);
	restoreButton.x = display.contentWidth-10;
	restoreButton.y = 2;
	navi.group:insert(restoreButton);

	--earn cards bk
	--[[local earn_bk  = display.newImageRect("assets/downloads/earn_cards_bk.png",417,53);
	earn_bk:setReferencePoint(display.BottomLeftReferencePoint);
	earn_bk.x,earn_bk.y = 20,display.contentHeight;
	group:insert(earn_bk);

	--learn more earn cards
	local learnMore = widget.newButton{
		label="",
		defaultFile="assets/downloads/learn_more.png",
		overFile="assets/downloads/learn_more_hi.png",
		width=144, height=40,
		onRelease = restoreClick
	}
	learnMore:setReferencePoint(display.TopLeftReferencePoint);
	learnMore.x = earn_bk.x+160;
	learnMore.y = earn_bk.y-61;
	group:insert(learnMore);

	--create earn tips text
	local earnText = require("downloads_earn_tips").new();
	group:insert(earnText.text);--]]


	--activity indicator
	native.setActivityIndicator(true);
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	print("downloads :: enterScene");

	local group = self.view

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	print("downloads :: exitScene");
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	print("downloads :: destroyScene");
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




