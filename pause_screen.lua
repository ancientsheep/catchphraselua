-----------------------------------------------------------------------------------------
--
-- options.lua
--
-----------------------------------------------------------------------------------------

module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require("widget");

local menuItems = {};

function backClick()
	print("options :: backClick");

	storyboard.gotoScene("main_menu","slideRight",200);
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
	local bk  = display.newImageRect("assets/game_screen/game_bg.jpg",display.contentWidth,display.contentHeight);
	bk:setReferencePoint(display.TopLeftReferencePoint);
	bk.x,bk.y = 0,0;
	group:insert(bk);

	-- animated sun rays
	local rays = require("sun_rays").new();
	rays.sunRays.x = 0;
	group:insert(rays.sunRays);

	-- playing to image
	local play_to_bk  = display.newImageRect("assets/score_screen/playing_to.png",152,102);
	play_to_bk:setReferencePoint(display.CenterTopReferencePoint);
	play_to_bk.x,play_to_bk.y = display.contentWidth/2,95;
	group:insert(play_to_bk);

	-- playing to score text
	local playingToTF = display.newText("7",380,60,"Soup of Justice",60);
	playingToTF:setTextColor(255,255,255);
	playingToTF:setReferencePoint(display.CenterTopReferencePoint);
	playingToTF.x,playingToTF.y=display.contentWidth/2,98;
	group:insert(playingToTF);

	-- team 1 bk
	local team1bk  = display.newImageRect("assets/score_screen/team1_bk.png",212,101);
	team1bk:setReferencePoint(display.TopLeftReferencePoint);
	team1bk.x,team1bk.y = 0,150;
	group:insert(team1bk);

	-- team 2 bk
	local team2bk  = display.newImageRect("assets/score_screen/team2_bk.png",212,99);
	team2bk:setReferencePoint(display.TopRightReferencePoint);
	team2bk.x,team2bk.y = display.contentWidth,150;
	group:insert(team2bk);

	local function startRound()
		storyboard.gotoScene("game_screen","slideLeft",200);
	end

	-- start round button
	local startRound = widget.newButton{
		labelColor={default={255},overFile={200}},
		defaultFile="assets/score_screen/start_round.png",
		overFile="assets/score_screen/start_round.png",
		width=187, height=74,
		onRelease = startRound
	}
	startRound:setReferencePoint(display.BottomCenterReferencePoint);
	startRound.x = display.contentWidth/2;
	startRound.y = display.contentHeight - 10;
	group:insert(startRound);

	--add navigation bar
	local navi = require("navi_bar").newBar();
	navi:setup(backClick,"GAME STATS");
	group:insert(navi.group);

	--[[function game:score_increment_team1(event)
		print("game : score_increment - team1");
		audioManager:playSound("score_inc");
		scoreKeeper:incrementScore("team1");
		game:updateHUD();
	end

	function game:score_increment_team2(event)
		print("game : score_increment - team2");
		audioManager:playSound("score_inc");
		scoreKeeper:incrementScore("team2");
		game:updateHUD();
	end

	-- update the hud (scores, etc)
	function game:updateHUD()
		print("game : updateHUD");
		game.team1score.text = tostring(scoreKeeper.team1_score);
		game.team2score.text = tostring(scoreKeeper.team2_score);
	end



	]]--

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




