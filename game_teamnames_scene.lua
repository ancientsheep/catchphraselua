module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene();
local facebook = require "facebook"

-- include Corona's "widget" library
local widget = require("widget");

local team1tf;
local team2tf;

function team1handler(evt)
	print("team1handler "..evt.phase);

	if evt.phase=="submitted" or evt.phase=="ended" then
		--set team name
		scoreKeeper.team1_name = team1tf.text;
		--hide keyboard
		native.setKeyboardFocus(nil);
	end
end

function team2handler(evt)
	print("team2handler "..evt.phase);

	if evt.phase=="submitted" or evt.phase=="ended" then
		--set team name
		scoreKeeper.team2_name = team2tf.text;
		--hide keyboard
		native.setKeyboardFocus(nil);
	end
end

function backClick()
	print("game_mode_screen :: backClick");
	storyboard.gotoScene("main_menu","slideRight",200);
	storyboard.removeScene("game_mode_screen");
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

	print("game_mode_screen :: createScene");

	local group = self.view;

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
	navi:setup(backClick,"TEAM NAMES");
	group:insert(navi.group);

	-- team names
	local teamNames  = display.newImageRect("assets/game_options_screen/team_names.png",152,23);
	teamNames:setReferencePoint(display.TopCenterReferencePoint);
	teamNames.x,teamNames.y = display.contentWidth/4,44;
	group:insert(teamNames);

	-- team names image bks
	--[[local tfbk1  = display.newImageRect("assets/game_options_screen/text_field.png",219,36);
	tfbk1:setReferencePoint(display.TopCenterReferencePoint);
	tfbk1.x,tfbk1.y = display.contentWidth/4,75;
	group:insert(tfbk1);

	local tfbk2  = display.newImageRect("assets/game_options_screen/text_field.png",219,36);
	tfbk2:setReferencePoint(display.TopCenterReferencePoint);
	tfbk2.x,tfbk2.y = display.contentWidth/4,115;
	group:insert(tfbk2);--]]

	

	-- Play game buttons

	local function playGameClick()
		print("Play game clicked.");

		-- save our game mode settings
		preference.save({team1name=team1tf.text});
		preference.save({team2name=team2tf.text});

		storyboard.gotoScene("game_options_screen","slideLeft",200);
	end

	-- team hot potatoe button
	local playGameButton = widget.newButton{
		label="",
		width=172, height=48,
		defaultFile = "assets/game_options_screen/play.png",
		onRelease = playGameClick
	}
	playGameButton:setReferencePoint(display.BottomCenterReferencePoint);
	playGameButton.x = display.contentWidth/2;
	playGameButton.y = display.contentHeight-10;
	group:insert(playGameButton);
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	print("game_mode_screen :: enterScene");

	local group = self.view;

	-- load our game mode settings
	local settings_team1 = preference.getValue("team1name");
	local settings_team2 = preference.getValue("team2name");

	if(settings_team1 == nil) then settings_team1 = "Team 1 Name"; end
	if(settings_team2 == nil) then settings_team2 = "Team 2 Name"; end

	-- team name textfields
	local textFont = native.newFont(native.systemFont);
	local padding = 10;

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	team1tf = native.newTextField(20,80,200,28);
	team1tf.font = textFont;
	team1tf.text = settings_team1;
	team1tf.size = 14;

	team2tf = native.newTextField(20,120,200,28);
	team2tf.font = textFont;
	team2tf.text = settings_team2;
	team2tf.size = 14;

	team1tf:addEventListener("userInput", team1handler);
	team2tf:addEventListener("userInput", team2handler);

	-- play audio
	audioManager:playMusic("main_menu2.mp3",0);
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	team1tf:removeEventListener("userInput", team1handler);
	team2tf:removeEventListener("userInput", team2handler);

	-- remove our text fields. so weird but corona needs it
	display.remove(team1tf);
	display.remove(team2tf);

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	print("game_mode_screen :: exitScene");
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	print("game_mode_screen :: destroyScene");
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




