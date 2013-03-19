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

	--when user presses no, fire this function


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

	--text image
	local txtImage = display.newImage("assets/score_screen/warning.png",0,0,758,344);
	txtImage:setReferencePoint(display.CenterReferencePoint);
	txtImage.x,txtImage.y = display.contentWidth/2,display.contentHeight/2-30;
	dialog.group:insert(txtImage);

	dialog.txtImage = txtImage;

	pulser = require("pulse").new(dialog.txtImage);
	pulser.scaleTo = 0.95;
	pulser.startPulse();

	function dialog:closeClick(evt)
		print("dialog_warning : noClick");
		--print("dialog.cancelFunc = "..dialog.cancelFunc);

		dialog:display(false);
		
	end

	--close button
	local closeButton = widget.newButton{
		label="",
		defaultFile="assets/score_screen/close.png",
		overFile="assets/score_screen/close.png",
		width=129, height=37,
		onRelease = dialog.closeClick
	}
	closeButton:setReferencePoint(display.CenterReferencePoint);
	closeButton.x = display.contentWidth/2;
	closeButton.y = display.contentHeight-50;
	dialog.group:insert(closeButton);


	function dialog:display(shouldDisplay)
		dialog.group.isVisible = shouldDisplay;

		if(shouldDisplay == true) then
			-- play alert sound
			audioManager:playSound("alert1");
		end
	end

	function dialog:destroy()
		print("dialog_warning : destroy");
		pulser:stopPulse();
		dialog.bk.removeEventListener("touch", dialog.blockTouch);
	end

	dialog:display(false);

	return dialog;
end