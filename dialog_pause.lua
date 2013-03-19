module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene();
local widget = require("widget");

local onSkip;
local onRestart;
local onResume;

function new(skip, restart, resume)

	local dialog = {};

	function dialog:blockTouch()
		return true;
	end

	onSkip = skip;
	onRestart = restart;
	onResume = resume;

	dialog.group = display.newGroup(0,0,display.contentWidth,display.contentHeight);
	dialog.group:setReferencePoint(display.TopLeftReferencePoint);

	--create transparent black bk
	dialog.bk = display.newRect(0,0,display.contentWidth,display.contentHeight);
	dialog.bk:setReferencePoint(display.TopLeftReferencePoint);
	dialog.bk.x,dialog.bk.y = 0,0;
	dialog.bk:setFillColor(0,0,0);
	dialog.bk.alpha = 0.8;
	dialog.group:insert(dialog.bk);

	dialog.bk:addEventListener("touch", dialog.blockTouch);

	function dialog:skipClick(event)

		onSkip();
	end

	function dialog:restartClick(event)

		onRestart();
	end

	function dialog:resumeClick(event)

		onResume();
	end

	--skip button
	local skipButton = widget.newButton{
		label="Skip",
		defaultFile="assets/score_screen/close.png",
		overFile="assets/score_screen/close.png",
		width=129, height=37,
		onRelease = dialog.skipClick
	}
	skipButton:setReferencePoint(display.CenterReferencePoint);
	skipButton.x = display.contentWidth/2;
	skipButton.y = display.contentHeight-130;
	dialog.group:insert(skipButton);

	--restart button
	local restartButton = widget.newButton{
		label="Restart",
		defaultFile="assets/score_screen/close.png",
		overFile="assets/score_screen/close.png",
		width=129, height=37,
		onRelease = dialog.restartClick
	}
	restartButton:setReferencePoint(display.CenterReferencePoint);
	restartButton.x = display.contentWidth/2;
	restartButton.y = display.contentHeight-90;
	dialog.group:insert(restartButton);

	--resume button
	local resumeButton = widget.newButton{
		label="Resume",
		defaultFile="assets/score_screen/close.png",
		overFile="assets/score_screen/close.png",
		width=129, height=37,
		onRelease = dialog.resumeClick
	}
	resumeButton:setReferencePoint(display.CenterReferencePoint);
	resumeButton.x = display.contentWidth/2;
	resumeButton.y = display.contentHeight-50;
	dialog.group:insert(resumeButton);


	function dialog:display(shouldDisplay)
		dialog.group.isVisible = shouldDisplay;
	end

	function dialog:destroy()

		onSkip = nil;
		onRestart = nil;
		onResume = nil;
	end

	dialog:display(false);

	return dialog;
end