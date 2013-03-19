module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene();
-- include Corona's "widget" library
local widget = require("widget");

local scaleTo = 1.05;
local timerScale = 0.75;
local scaleToClock = 1.3;
local animTime=500;
local animTimeClock=800;

--buttons
local noButton;
local yesButton;
local continueButton;
local team1Button;
local team2Button;

-- button click evnts
function continueClick(evt)
	print("final_guess_screen: continueClick");

	--make sure they filled out required fields
	if updateContinue()==true then

		--update scores
		if(team1Button:selected() == true) then
			scoreKeeper.team1_score = scoreKeeper.team1_score+1;

			--add final word score if selected too
			if(yesButton.alpha == 1.0) then
				scoreKeeper.team1_score = scoreKeeper.team1_score+1;
			end
		end

		if(team2Button:selected() == true) then
			scoreKeeper.team2_score = scoreKeeper.team2_score+1;

			--add final word score if selected too
			if(yesButton.alpha == 1.0) then
				scoreKeeper.team2_score = scoreKeeper.team2_score+1;
			end
		end

		--increment round
		scoreKeeper.currRound = scoreKeeper.currRound + 1;

		-- have we passed our final round / score?
		-- if so show congrats screen, otherwise go back to score screen


		if(scoreKeeper.playToText == "Rounds") then
			if(scoreKeeper.currRound >= scoreKeeper.playTo) then
				storyboard.gotoScene("game_over_screen","slideLeft",200);
			else
				storyboard.gotoScene("score_screen","slideRight",200);
			end
		elseif(scoreKeeper.playToText == "Points") then
			if(scoreKeeper.team1_score >= scoreKeeper.playTo or scoreKeeper.team2_score >= scoreKeeper.playTo) then
				storyboard.gotoScene("game_over_screen","slideLeft",200);
			else
				storyboard.gotoScene("score_screen","slideRight",200);
			end
		end


		
	end
end

function noClick(evt)
	yesButton.alpha = 0.5;
	noButton.alpha = 1.0;

	updateContinue();
end

function yesClick(evt)
	yesButton.alpha = 1.0;
	noButton.alpha = 0.5;

	updateContinue();
end

function updateContinue()
	print("final_guess_screen : updateContinue");

	if((yesButton.alpha == 1.0 or noButton.alpha == 1.0) and (team1Button:selected()==true or team2Button:selected()==true)) then
		continueButton.alpha = 1.0;

		return true;
	end
end

-- Called when the scene's view does not exist:
function scene:createScene(event)
	print("final_guess_screen :: createScene");
	as_analytics:logEvent("final_guess_screen : createScene")
	local group = self.view;

	--create transparent black bk
	local bk = display.newImageRect("assets/final_guess_screen/bk.jpg",display.contentWidth,display.contentHeight);
	bk:setReferencePoint(display.TopLeftReferencePoint);
	bk.x,bk.y = 0,0;
	group:insert(bk);

	-- animated sun rays
	local rays = require("sun_rays").new();
	--top right hand corner
	rays.sunRays.x = display.contentWidth;
	rays.sunRays.y = rays.sunRays.y - display.contentHeight/2;
	group:insert(rays.sunRays);

	-- final guess word
	local guessText = display.newText(scoreKeeper.current_word,50,40,"Soup of Justice",40);
	guessText:setTextColor(255,255,255);
	guessText:setReferencePoint(display.TopCenterReferencePoint);
	guessText.x,guessText.y=display.contentWidth/2,20;
	group:insert(guessText);

	-- which team won round?
	local whoWon = display.newText("WHICH TEAM WON THE ROUND?",50,25,"Soup of Justice",25);
	whoWon:setTextColor(255,255,255);
	whoWon:setReferencePoint(display.TopCenterReferencePoint);
	whoWon.x,whoWon.y=display.contentWidth/2,80;
	group:insert(whoWon);


	-- did winner also guess final word?
	local finalWordGuess = display.newText("DID WINNER ALSO GUESS FINAL WORD?",50,25,"Soup of Justice",25);
	finalWordGuess:setTextColor(255,255,255);
	finalWordGuess:setReferencePoint(display.TopCenterReferencePoint);
	finalWordGuess.x,finalWordGuess.y=display.contentWidth/2,180;
	group:insert(finalWordGuess);

	--create times up image
	local img  = display.newImageRect("assets/final_guess_screen/final_word.png",153,25);
	img:setReferencePoint(display.TopCenterReferencePoint);
	img.x,img.y = display.contentWidth/2,0;
	group:insert(img);

	
	-- team buttons

	function team1Click(evt)
		print("team1click");
		team1Button:setSelected(true);
		team2Button:setSelected(false);

		updateContinue();
	end

	function team2Click(evt)
		print("team2click");
		team1Button:setSelected(false);
		team2Button:setSelected(true);

		updateContinue();
	end

	--team 1
	team1Button = require("radio_button").new("assets/final_guess_screen/button_selected.png","assets/final_guess_screen/button_not_selected.png",scoreKeeper.team1_name,228,52,team1Click);
	team1Button.setSelected(false);
	team1Button.group.x = 10;
	team1Button.group.y = 120;
	group:insert(team1Button.group);

	-- team 2 button
	team2Button = require("radio_button").new("assets/final_guess_screen/button_selected.png","assets/final_guess_screen/button_not_selected.png",scoreKeeper.team2_name,228,52,team2Click);
	team2Button.setSelected(false);
	team2Button.group.x = display.contentWidth-10-team2Button.group.width;
	team2Button.group.y = 120;
	group:insert(team2Button.group);

	--no button
	noButton = widget.newButton{
		label="",
		defaultFile="assets/final_guess_screen/no.png",
		overFile="assets/final_guess_screen/no.png",
		width=136, height=40,
		onRelease = noClick
	}
	noButton:setReferencePoint(display.BottomRightReferencePoint);
	noButton.x = display.contentWidth/2-10;
	noButton.y = display.contentHeight-60;
	noButton.alpha = 0.5;
	group:insert(noButton);

	--yes button
	yesButton = widget.newButton{
		label="",
		defaultFile="assets/final_guess_screen/yes.png",
		overFile="assets/final_guess_screen/yes.png",
		width=136, height=40,
		onRelease = yesClick
	}
	yesButton:setReferencePoint(display.BottomLeftReferencePoint);
	yesButton.x = display.contentWidth/2+10;
	yesButton.y = display.contentHeight-60;
	yesButton.alpha = 0.5;
	group:insert(yesButton);

	--continue button
	continueButton = widget.newButton{
		label="",
		defaultFile="assets/final_guess_screen/continue.png",
		overFile="assets/final_guess_screen/continue.png",
		width=161, height=40,
		onRelease = continueClick
	}
	continueButton:setReferencePoint(display.BottomCenterReferencePoint);
	continueButton.x = display.contentWidth/2;
	continueButton.y = display.contentHeight-10;
	continueButton.alpha = 0.5;
	group:insert(continueButton);

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	print("final_guess_screen :: enterScene");
	local group = self.view;
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	print("final_guess_screen :: exitScene");
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	print("final_guess_screen :: destroyScene");
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