-----------------------------------------------------------------------------------------
--
-- score_screen.lua
--
-----------------------------------------------------------------------------------------

module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require("widget");

local menuItems = {};

local team1score;
local team2score;
local roundTF;
local endGameDialog;

local warningDialog;

local t1MinusButton;
local t2MinusButton;

function backClick()
	print("options :: backClick");

	storyboard.gotoScene("game_options_screen","slideRight",200);
end

function updateScoresText()
	team1score.text = tostring(scoreKeeper.team1_score);
	team2score.text = tostring(scoreKeeper.team2_score);

	-- set alpha for minus buttons
	if scoreKeeper.team1_score <= 0 then
		t1MinusButton.alpha = 0.5;
	else
		t1MinusButton.alpha = 1.0;
	end

	if scoreKeeper.team2_score <= 0 then
		t2MinusButton.alpha = 0.5;
	else
		t2MinusButton.alpha = 1.0;
	end

	-- current round
	roundTF.text = "ROUND "..scoreKeeper.currRound.."!";
end

-- score functions

function team1_inc_cancel()
	print("team1_inc_cancel");
	scoreKeeper:decrementScore("TEAM1");
	updateScoresText();
end

function team2_inc_cancel()
	print("team2_inc_cancel");
	scoreKeeper:decrementScore("TEAM2");
	updateScoresText();
end

function scoreInc(team)
	print("score_screen : scoreInc - "..team);
	audioManager:playSound("score_inc");
	scoreKeeper:incrementScore(team);
	updateScoresText();

	-- display dialog if user manaully increased points past playto value

	if(team=="team1") then
		if(scoreKeeper.team1_score >= scoreKeeper.playTo) and scoreKeeper.playToText == "Points" then
			endGameDialog.cancelFunc = team1_inc_cancel;
			endGameDialog:display(true);
		end

	else
		if(scoreKeeper.team2_score >= scoreKeeper.playTo)  and scoreKeeper.playToText == "Points" then
			endGameDialog.cancelFunc = team2_inc_cancel;
			endGameDialog:display(true);
		end
	end
end

function scoreDec(team)
	print("score_screen : scoreDec - "..team);
	audioManager:playSound("score_inc");
	scoreKeeper:decrementScore(team);
	updateScoresText();
end

function team1Inc()
	scoreInc("team1");
end

function team1Dec()
	if scoreKeeper.team1_score > 0 then
		scoreDec("team1");
	end
end

function team2Inc()
	scoreInc("team2");
end

function team2Dec()
	if scoreKeeper.team2_score > 0 then
		scoreDec("team2");
	end
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

	-- overlay
	local overlay  = display.newImageRect("assets/game_screen/bk_overlay.jpg",480,320);
	overlay:setReferencePoint(display.TopLeftReferencePoint);
	overlay.x,overlay.y = 0,0;
	overlay.blendMode = "multiply";
	group:insert(overlay);


	-- animated sun rays
	local rays = require("sun_rays").new();
	rays.sunRays.x = 0;
	group:insert(rays.sunRays);

	-- playing to image
	local play_to_bk  = display.newImageRect("assets/score_screen/playing_to.png",153,104);
	play_to_bk:setReferencePoint(display.CenterTopReferencePoint);
	play_to_bk.x,play_to_bk.y = display.contentWidth/2,95;
	group:insert(play_to_bk);

	-- playing to score text
	local playingToTF = display.newText(scoreKeeper.playTo,380,60,"Soup of Justice",60);
	playingToTF:setTextColor(255,255,255);
	playingToTF:setReferencePoint(display.CenterTopReferencePoint);
	playingToTF.x,playingToTF.y=play_to_bk.x,88 + textOffsetFix:offset(11);
	group:insert(playingToTF);

	-- playing to rounds/points
	local playingToRounds = display.newText(scoreKeeper.playToText,380,15,"Soup of Justice",15);
	playingToRounds:setTextColor(255,255,255);
	playingToRounds:setReferencePoint(display.CenterTopReferencePoint);
	playingToRounds.x,playingToRounds.y=play_to_bk.x,120 + textOffsetFix:offset(5);
	group:insert(playingToRounds);
	


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

	-- next round
	roundTF = display.newText("ROUND "..scoreKeeper.currRound.."!",380,37,"Soup of Justice",37);
	roundTF:setTextColor(255,255,255);
	roundTF:setReferencePoint(display.CenterTopReferencePoint);
	roundTF.x,roundTF.y=startRound.x,startRound.y + textOffsetFix:offset(9) - 28;
	group:insert(roundTF);

	-- team names
	-- team 1 name
	local team1name = display.newText(scoreKeeper.team1_name,50,20,"Soup of Justice",20);
	team1name:setTextColor(255,255,255);
	team1name:setReferencePoint(display.TopLeftReferencePoint);
	team1name.x,team1name.y=10,163 + textOffsetFix:offset(3);
	group:insert(team1name);

	-- team 2 name
	local team2name = display.newText(scoreKeeper.team2_name,20,20,"Soup of Justice",20);
	team2name:setTextColor(255,255,255);
	team2name:setReferencePoint(display.TopRightReferencePoint);
	team2name.x,team2name.y=display.contentWidth-10,160 + textOffsetFix:offset(3);
	group:insert(team2name);

	print(textOffsetFix.use);


	warningDialog = require("dialog_warning").new();
	warningDialog:display(true);

	-- scores
	-- team 1 score
	team1score = display.newText("15",50,20,"Soup of Justice",50);
	team1score:setTextColor(255,255,255);
	team1score:setReferencePoint(display.TopLeftReferencePoint);
	team1score.x,team1score.y=20,179 + textOffsetFix:offset(13);
	group:insert(team1score);

	-- team 2 score
	team2score = display.newText("25",50,20,"Soup of Justice",50);
	team2score:setTextColor(255,255,255);
	team2score:setReferencePoint(display.TopLeftReferencePoint);
	team2score.x,team2score.y=display.contentWidth-60,177 + textOffsetFix:offset(13);
	group:insert(team2score);

	--add navigation bar
	local navi = require("navi_bar").newBar();
	navi:setup(backClick,"SCOREBOARD");
	group:insert(navi.group);

	-------------------------------
	-- TEAM 1 SCORE BUTTONS
	-------------------------------

	-- add score to team 1 button
	local t1AddButton = widget.newButton{
		label="",
		defaultFile="assets/score_screen/add_point.png",
		overFile="assets/score_screen/add_point.png",
		width=50, height=50,
		onRelease = team1Inc
	}
	t1AddButton:setReferencePoint(display.BottomLeftReferencePoint);
	t1AddButton.x = 10;
	t1AddButton.y = display.contentHeight-10;
	group:insert(t1AddButton);

	-- minus score to team 1 button
	t1MinusButton = widget.newButton{
		label="",
		defaultFile="assets/score_screen/minus_point.png",
		overFile="assets/score_screen/minus_point.png",
		width=50, height=50,
		onRelease = team1Dec
	}
	t1MinusButton:setReferencePoint(display.BottomLeftReferencePoint);
	t1MinusButton.x = 70;
	t1MinusButton.y = display.contentHeight-10;
	group:insert(t1MinusButton);

	-------------------------------
	-- TEAM 2 SCORE BUTTONS
	-------------------------------

	-- add score to team 1 button
	local t2AddButton = widget.newButton{
		label="",
		defaultFile="assets/score_screen/add_point.png",
		overFile="assets/score_screen/add_point.png",
		width=50, height=50,
		onRelease = team2Inc
	}
	t2AddButton:setReferencePoint(display.BottomRightReferencePoint);
	t2AddButton.x = display.contentWidth-10;
	t2AddButton.y = display.contentHeight-10;
	group:insert(t2AddButton);

	-- minus score to team 1 button
	t2MinusButton = widget.newButton{
		label="",
		defaultFile="assets/score_screen/minus_point.png",
		overFile="assets/score_screen/minus_point.png",
		width=50, height=50,
		onRelease = team2Dec
	}
	t2MinusButton:setReferencePoint(display.BottomRightReferencePoint);
	t2MinusButton.x = display.contentWidth-70;
	t2MinusButton.y = display.contentHeight-10;
	group:insert(t2MinusButton);

	--update scores
	updateScoresText();

	--test end game dialog
	endGameDialog = require("dialog_end_game").new();
	group:insert(endGameDialog.group);

end




-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	print("score_screen :: enterScene");

	local group = self.view

	-- play audio
	audioManager:stopMusicChannel();

	storyboard.purgeScene("game_screen");

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.
	updateScoresText();
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
	endGameDialog:destroy();
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




