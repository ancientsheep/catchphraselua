module(...,package.seeall);

-- set timer
function new()
	local fps = {};

	-- create our group
	fps.group = display.newGroup(0,0);
	fps.group:setReferencePoint(display.TopLeftReferencePoint);


	if _debugMode == true then
		-- setup / create our text field
		fps.textField = display.newText("-- fps",50,10,"Soup of Justice",14);
		fps.textField:setTextColor(255,255,255);
		fps.textField:setReferencePoint(display.TopLeftReferencePoint);
		fps.textField.x,fps.textField.y=10,10;
		fps.group:insert(fps.textField);
	end

	-- update fps each enter frame
	local function updater(event)
		if _debugMode == true then
			--print("fps updated");
			fps.textField.text = display.fps.." fps";
		end
	end

	-- destroy function
	function destroy()
		Runtime:removeEventListener("enterFrame",updater);
	end

	-- add update event
	Runtime:addEventListener("enterFrame",updater);

	return fps;
end

