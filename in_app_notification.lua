module(...,package.seeall);

local widget = require("widget");

local json = require("json");

function new()

	local notification = {};

	function notification:checkForNewNotification()

		local function networkListener(event)
			if (event.isError) then
				print( "Network error!");
			else
				print(event.response);
				local data = json.decode(event.response);

				if(preference.getValue("lastUpdate") == nil) then

					preference.save{lastUpdate = -1};

				elseif(preference.getValue("lastUpdate") ~= data.entry_date) then
					
					preference.save{lastUpdate = data.entry_date};
					notification.group.isVisible = true;
				end
			end
		end

		network.request("http://www.mashmyaveragelife.com/index.php/mole/notification_lite?debug=0&app=Lite", "GET", networkListener);
	end

	function notification:clickClose(event)

		print("Don\'t");

		notification.group.isVisible = false;
	end

	function notification:clickAction(event)

		print("Do");

		notification.group.isVisible = false;
	end

	notification.group = display.newGroup(0,0,display.contentWidth,display.contentHeight);
	notification.group:setReferencePoint(display.TopLeftReferencePoint);

	--create transparent black bk
	notification.bk = display.newRect(0,0,display.contentWidth,display.contentHeight);
	notification.bk:setReferencePoint(display.TopLeftReferencePoint);
	notification.bk.x,notification.bk.y = 0,0;
	notification.bk:setFillColor(0,0,0);
	notification.bk.alpha = 0.8;
	notification.group:insert(notification.bk);

	--close button
	local closeButton = widget.newButton{
		label="Don\'t",
		defaultFile="assets/score_screen/close.png",
		overFile="assets/score_screen/close.png",
		width=129, height=37,
		onRelease = notification.clickClose
	}
	closeButton:setReferencePoint(display.CenterReferencePoint);
	closeButton.x = display.contentWidth/2;
	closeButton.y = display.contentHeight-50;
	notification.group:insert(closeButton);

	--action button
	local actionButton = widget.newButton{
		label="Do",
		defaultFile="assets/score_screen/close.png",
		overFile="assets/score_screen/close.png",
		width=129, height=37,
		onRelease = notification.clickAction
	}
	actionButton:setReferencePoint(display.CenterReferencePoint);
	actionButton.x = display.contentWidth/2;
	actionButton.y = display.contentHeight-90;
	notification.group:insert(actionButton);

	notification.group.isVisible = false;

	return notification;
end