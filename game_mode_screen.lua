module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene();
local facebook = require "facebook"

-- include Corona's "widget" library
local widget = require("widget");

local menuItems = {};

function backClick()
	print("game_mode_screen :: backClick");
	storyboard.gotoScene("main_menu","slideRight",200);
	storyboard.removeScene("game_mode_screen");
end

function teamHot()
	print("game_mode_screen :: teamHot");

	--set our game mode
	scoreKeeper.gameMode = "team_hot";
	storyboard.gotoScene("game_options_screen","slideLeft",200);
end

function elimHot()
	print("game_mode_screen :: elimHot");
	--set our game mode
	scoreKeeper.gameMode = "elim_hot";
	storyboard.gotoScene("game_options_screen","slideLeft",200);
end

function highScore()
	print("game_mode_screen :: highScore");

	--set our game mode
	scoreKeeper.gameMode = "high_score";
	storyboard.gotoScene("game_options_screen","slideLeft",200);
end

function partyMode()
	print("game_mode_screen :: partyMode");

	--set our game mode
	scoreKeeper.gameMode = "party_mode";
	storyboard.gotoScene("game_options_screen","slideLeft",200);
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
	navi:setup(backClick,"GAME MODE");
	group:insert(navi.group);

	--Add our game buttons

	-- team hot potatoe button
	local teamPotato = widget.newButton{
		label="Team Hot Potato",
		width=172, height=48,
		onRelease = teamHot
	}
	teamPotato:setReferencePoint(display.TopCenterReferencePoint);
	teamPotato.x = display.contentWidth/4;
	teamPotato.y = 50;
	group:insert(teamPotato);

	-- eliminator hot potato
	local elimPotato = widget.newButton{
		label="Eliminator Hot Potato",
		width=172, height=48,
		onRelease = elimHot
	}
	elimPotato:setReferencePoint(display.TopCenterReferencePoint);
	elimPotato.x = display.contentWidth-100;
	elimPotato.y = 50;
	group:insert(elimPotato);

	-- high score mode button
	local highScore = widget.newButton{
		label="High Score Mode",
		width=172, height=48,
		onRelease = highScore
	}
	highScore:setReferencePoint(display.TopCenterReferencePoint);
	highScore.x = display.contentWidth/4;
	highScore.y = 140;
	group:insert(highScore);

	-- party mode button
	local elimPotato = widget.newButton{
		label="Party Mode",
		width=172, height=48,
		onRelease = partyMode
	}
	elimPotato:setReferencePoint(display.TopCenterReferencePoint);
	elimPotato.x = display.contentWidth-100;
	elimPotato.y = 140;
	group:insert(elimPotato);

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	print("game_mode_screen :: enterScene");

	local group = self.view

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	storyboard.removeScene("game_options_screen");

	-- play audio
	audioManager:playMusic("main_menu2.mp3",0);
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

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




