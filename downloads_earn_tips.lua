module(...,package.seeall);

-- include Corona's "widget" library
local widget = require("widget");

function new()
	local tips = {};
	local fontName = "Akzedenz-Grotesk BQ Light Condensed";

	-- create the title for tip even  if we're not using it yet
	local tipText = display.newText("Testing aslkfja slfk j",380,25,"Soup of Justice",16);
	tipText:setTextColor(255,255,255);
	tipText:setReferencePoint(display.CenterTopReferencePoint);
	tipText.x,tipText.y=display.contentWidth/2,display.contentHeight-20;
	--bar.group:insert(tipText);
    tips.text = tipText;

	return tips;
end