module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene();
local widget = require("widget");

function new()
	local dialog={};
	local pulser;

	function dialog:blockTouch()
		return true;
	end

	dialog.group = display.newGroup(0,0,display.contentWidth,display.contentHeight);
	dialog.group:setReferencePoint(display.TopLeftReferencePoint);

	--create transparent black bk
	local bk = display.newRect(0,0,display.contentWidth,display.contentHeight);
	bk:setReferencePoint(display.TopLeftReferencePoint);
	bk.x,bk.y = 0,0;
	bk:setFillColor(0,0,0);
	bk.alpha = 0.8;
	dialog.group:insert(bk);

	bk:addEventListener("touch", dialog.blockTouch);

	--text image
	local txtImage = display.newImage("assets/score_screen/end_game.png",0,0,361,62);
	txtImage:setReferencePoint(display.TopCenterReferencePoint);
	txtImage.x,txtImage.y = display.contentWidth/2,100;
	dialog.group:insert(txtImage);

	dialog.txtImage = txtImage;

	pulser = require("pulse").new(dialog.txtImage);
	pulser.scaleTo = 0.95;
	pulser.startPulse();

	function dialog:noClick(evt)
		print("dialog_end_game : noClick");
		--print("dialog.cancelFunc = "..dialog.cancelFunc);

		dialog:display(false);

		
			print("cancel should have fired");
			dialog.cancelFunc();
		
	end

	function dialog:yesClick(evt)
		storyboard.gotoScene("game_over_screen","slideLeft",200);
	end

	--no button
	local noButton = widget.newButton{
		label="",
		defaultFile="assets/final_guess_screen/no.png",
		overFile="assets/final_guess_screen/no.png",
		width=136, height=40,
		onRelease = dialog.noClick
	}
	noButton:setReferencePoint(display.BottomRightReferencePoint);
	noButton.x = display.contentWidth/2-10;
	noButton.y = display.contentHeight-60;
	dialog.group:insert(noButton);

	--yes button
	local yesButton = widget.newButton{
		label="",
		defaultFile="assets/final_guess_screen/yes.png",
		overFile="assets/final_guess_screen/yes.png",
		width=136, height=40,
		onRelease = dialog.yesClick
	}
	yesButton:setReferencePoint(display.BottomLeftReferencePoint);
	yesButton.x = display.contentWidth/2+10;
	yesButton.y = display.contentHeight-60;
	dialog.group:insert(yesButton);

	function dialog:display(shouldDisplay)
		dialog.group.isVisible = shouldDisplay;
		-- play alert
		if(shouldDisplay == true) then
			-- play alert sound
			audioManager:playSound("alert2");
		end

	end

	function dialog:destroy()
		print("dialog_end_game : destroy");
		pulser:stopPulse();
	end

	dialog:display(false);

	return dialog;
end