module(...,package.seeall);

-- include Corona's "widget" library
local widget = require("widget");

function new(titler,titles,currIndex,values)
	local slider = {};
	slider.titler = titler;
	slider.possibleTitles = titles;

	if values==nil then
		slider.possibleValues = titles;
	else
		slider.possibleValues = values;
	end

	slider.currIndex = currIndex;

	slider.headerFontSize = 10;
	slider.yPadding = 25;
	slider.spacing = 65;

	--create/setup our navigation bar
	function slider:setup()
		print("slider :: setup: "..slider.titler);

		--create our group
		slider.group = display.newGroup(0,0);
		slider.group:setReferencePoint(display.TopLeftReferencePoint);
		slider.group.name = "naviBar";

		--
		--create our background
		--
		local sliderBk  = display.newImageRect("assets/game_options_screen/slider_bk.png",218,40);
		sliderBk:setReferencePoint(display.TopLeftReferencePoint);
		sliderBk.x,sliderBk.y = 0,slider.yPadding;
		slider.group:insert(sliderBk);

		--
		--	add textfield
		--

		-- create current game word
		local titleShadow = display.newText(slider.titler,380,40,"Soup of Justice",18);
		titleShadow:setTextColor(255,255,255);
		titleShadow.alpha = 0.5;
		titleShadow:setReferencePoint(display.TopLeftReferencePoint);
		titleShadow.x,titleShadow.y=21,1 + textOffsetFix:offset(3);
		slider.group:insert(titleShadow);
		slider.titleShadow = titleShadow;

		local titleTF = display.newText(slider.titler,380,40,"Soup of Justice",18);
		titleTF:setTextColor(0,0,0);
		titleTF:setReferencePoint(display.TopLeftReferencePoint);
		titleTF.x,titleTF.y=20,0 + textOffsetFix:offset(3);
		slider.group:insert(titleTF);
		slider.titleTF = titleTF;


		local sliderValueTF = display.newText("9",380,40,"Soup of Justice",25);
		sliderValueTF:setTextColor(40,40,40);
		sliderValueTF:setReferencePoint(display.CenterReferencePoint);
		sliderValueTF.x,sliderValueTF.y=218/2,slider.yPadding+20 + textOffsetFix:offset(3);
		slider.group:insert(sliderValueTF);
		slider.sliderValueTF = sliderValueTF;
		-- set initial value
		slider.sliderValueTF.text = slider.possibleTitles[slider.currIndex];

		--
		-- add back button
		--

		-- Insert how to play buttons
		local rightButton = widget.newButton{
			label="",
			labelColor={default={255},overFile={200}},
			defaultFile="assets/game_options_screen/button_right.png",
			overFile="assets/game_options_screen/button_right.png",
			width=44, height=44,
			onRelease = slider.nextValue
		}
		rightButton:setReferencePoint(display.CenterReferencePoint);
		rightButton.x = 195;
		rightButton.y = slider.yPadding+20;
		slider.rightButton = rightButton;
		--rightButton.alpha = 0.75;
		slider.group:insert(rightButton);

		local leftButton = widget.newButton{
			label="",
			labelColor={default={255},overFile={200}},
			defaultFile="assets/game_options_screen/button_left.png",
			overFile="assets/game_options_screen/button_left.png",
			width=44, height=44,
			onRelease = slider.prevValue
		}
		leftButton:setReferencePoint(display.CenterReferencePoint);
		leftButton.x = 21;
		leftButton.y = slider.yPadding+20;
		slider.leftButton = leftButton;
		--leftButton.alpha = 0.75;
		slider.group:insert(leftButton);


		--set the group reference point to the center
		slider.group:setReferencePoint(display.TopCenterReferencePoint);

		slider:checkLimits();
	end

	function slider:nextValue()
		print("slider : nextValue - currIndex: "..slider.currIndex);

		-- make sure we can't go beyond our limits
		if (slider.currIndex+1) <= #slider.possibleTitles then
			slider.currIndex = slider.currIndex+1;

			-- change value text
			slider.sliderValueTF.text = slider.possibleTitles[slider.currIndex];

			-- check limits
			slider.checkLimits();
		else
			-- over our limit
		end

	end

	function slider:prevValue()
		print("slider : prevValue - currIndex: "..slider.currIndex);
		
		-- make sure we can't go beyond our limits
		if (slider.currIndex-1) > 0 then
			slider.currIndex = slider.currIndex-1;

			-- change value text
			slider.sliderValueTF.text = slider.possibleTitles[slider.currIndex];

			-- check limits
			slider.checkLimits();
		else
			-- over our limit
		end
	end

	function slider:checkLimits()
		-- is this the last option available?
		-- if so lets disable the button
		if slider.currIndex == #slider.possibleTitles then
			slider.rightButton.alpha = 0.5;
		else
			slider.rightButton.alpha = 1.0;
		end

		--check left button
		-- is this the first option available?
		-- if so lets disable the button
		if slider.currIndex == 1 then
			slider.leftButton.alpha = 0.5;
		else
			slider.leftButton.alpha = 1.0;
		end
	end

	function slider:currValue()
		print("slider : currValue - "..slider.possibleValues[slider.currIndex]);

		return slider.possibleValues[slider.currIndex];
	end

	return slider;
end