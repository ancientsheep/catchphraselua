module(...,package.seeall);

-- include Corona's "widget" library
local widget = require("widget");

function newBar()
	local bar = {};
	bar.width = display.contentWidth;
	bar.height = 48;

	--create/setup our navigation bar
	function bar:setup(clickFunc,title)
		print("navi_bar :: setup");

		--create our group
		bar.group = display.newGroup(0,0,bar.width,bar.height);
		bar.group:setReferencePoint(display.TopLeftReferencePoint);
		bar.group.name = "naviBar";

		--
		--create our background
		--
		bar.bg = display.newImageRect("assets/navi_bar/navi_bk.png",bar.width,bar.height);
		bar.bg:setReferencePoint(display.TopLeftReferencePoint);
		bar.bg.x, bar.bg.y = 0,0;
		bar.group:insert(bar.bg);

		--
		-- add back button
		--

		-- Insert how to play buttons
		local backButton = widget.newButton{
			label="Back",
			fontSize=14,
			labelColor={default={255},overFile={200}},
			defaultFile="assets/navi_bar/back_button.png",
			overFile="assets/navi_bar/back_button_down.png",
			width=99, height=30,
			onRelease = clickFunc
		}
		backButton:setReferencePoint(display.TopLeftReferencePoint);
		backButton.x = 10;
		backButton.y = 5;

		bar.group:insert(backButton);

		-- create the title even if we're not using it yet
		local titleText = display.newText("",380,25,"Soup of Justice",25);
		titleText:setTextColor(255,255,255);
		titleText:setReferencePoint(display.CenterTopReferencePoint);
		titleText.x,titleText.y=display.contentWidth/2,19;
		bar.group:insert(titleText);

		bar.titleText = titleText;

		if title~="" then
			bar.titleText.text = title;
		end

		--set the group reference point to the center
		bar.group:setReferencePoint(display.TopLeftReferencePoint);

	end

	return bar;
end