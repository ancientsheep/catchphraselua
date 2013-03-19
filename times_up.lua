module(...,package.seeall);

local storyboard = require("storyboard");
-- include Corona's "widget" library
local widget = require("widget");

local scaleTo = 1.05;
local timerScale = 0.75;
local scaleToClock = 1.3;
local animTime=500;
local animTimeClock=800;

function new()
	local timesup={};
	timesup.group = display.newGroup(0,0,display.contentWidth,display.contentHeight);
	timesup.group:setReferencePoint(display.TopLeftReferencePoint);

	function timesup:blockTouch()
		return true;
	end

	--create transparent black bk
	local bk = display.newRect(0,0,display.contentWidth,display.contentHeight);
	bk:setReferencePoint(display.TopLeftReferencePoint);
	bk.x,bk.y = 0,0;
	bk:setFillColor(0,0,0);
	bk.alpha = 0.8;
	timesup.group:insert(bk);
	timesup.bk = bk;

	timesup.bk:addEventListener("touch", timesup.blockTouch);

	--create times up image
	local img  = display.newImageRect("assets/game_screen/times_up.png",412*timerScale,136*timerScale);
	img:setReferencePoint(display.TopCenterReferencePoint);
	img.x,img.y = display.contentWidth/2,20;
	timesup.group:insert(img);

	-- create clock image
	local clock  = display.newImageRect("assets/game_screen/times_up_clock.png",109*timerScale,114*timerScale);
	clock:setReferencePoint(display.TopCenterReferencePoint);
	clock.x,clock.y = display.contentWidth/2+(33*timerScale),100*timerScale;
	timesup.group:insert(clock);

	--close button clicked
	function timesup:closeClick()
		print("times_up : closeClick");
		-- go to new score screen / remove this game scene
		timesup.bk:removeEventListener("touch", timesup.blockTouch);
		storyboard.gotoScene("final_guess_screen","slideLeft",200);
		storyboard.removeScene("game_screen");
	end

	--continue button
	local continueButton = widget.newButton{
		label="",
		defaultFile="assets/game_screen/close.png",
		overFile="assets/game_screen/close.png",
		width=200, height=57,
		onRelease = timesup.closeClick
	}
	continueButton:setReferencePoint(display.BottomCenterReferencePoint);
	continueButton.x = display.contentWidth/2;
	continueButton.y = display.contentHeight-10;
	timesup.group:insert(continueButton);

	-- chance fixed text
	local guessText = display.newText("OTHER TEAM HAS A CHANCE TO GUESS WORD:",50,20,"Soup of Justice",20);
	guessText:setTextColor(255,255,255);
	guessText:setReferencePoint(display.TopCenterReferencePoint);
	guessText.x,guessText.y=display.contentWidth/2,170;
	timesup.group:insert(guessText);

	-- final word
	local finalWord = display.newText("FINAL WORD",50,40,"Soup of Justice",40);
	finalWord:setTextColor(255,255,255);
	finalWord:setReferencePoint(display.TopCenterReferencePoint);
	finalWord.x,finalWord.y=display.contentWidth/2,190;
	timesup.group:insert(finalWord);

	-- fade in
	function timesup:fadeIn()
		timesup.group.isVisible = true;
		-- start animating
		timesup:animateBk();
		timesup:animateClockDelay();

		--set our current word
		finalWord.text = scoreKeeper.current_word;
		timesup.group.alpha = 0;
		transition.to(timesup.group,{time=100,alpha=1.0});
	end	

	-- animations
	function timesup:animateBk()
		transition.to(img,{time=animTime,width=412*scaleTo*timerScale,height=136*scaleTo*timerScale,onComplete=timesup.animateBkRestart});
	end

	function timesup:animateBkRestart()
		transition.to(img,{time=animTime,width=412*timerScale,height=136*timerScale,onComplete=timesup.animateBk});
	end

	-- clock animations
	function timesup:animateClockDelay()
		transition.to(clock,{delay=200,time=animTimeClock,width=109*scaleToClock*timerScale,height=114*scaleToClock*timerScale,onComplete=timesup.animateClockRestart});
	end

	function timesup:animateClock()
		transition.to(clock,{time=animTimeClock,width=109*scaleToClock*timerScale,height=114*scaleToClock*timerScale,onComplete=timesup.animateClockRestart});
	end

	function timesup:animateClockRestart()
		transition.to(clock,{time=animTimeClock,width=109*timerScale,height=114*timerScale,onComplete=timesup.animateClock});
	end

	timesup.group.isVisible = false;

	return timesup;
end